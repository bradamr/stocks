require_relative '../services/apis/ally/account'
require_relative 'properties'

module Utils
  class ApiQuery
    attr_reader :api, :command, :properties, :type

    def initialize(command, type)
      @command    = command
      @properties = Utils::Properties.load('brokers/live/ally.yml')
      @type       = type
    end

    def run
      api
      api_with_command
    end

    def api_with_command
      case type
        when 'account'
          account_api_handler
      end
    end

    def account_api_handler
      case command
        when /info/
          api.info
      end
    end

    def api
      case type
        when /account/
          @api = Api::Ally::Account.new(properties)
      end
    end

    def self.run
      type    = ARGV[0]
      command = ARGV[1]
      new(command, type).run
    end
  end
end

ApiQuery.run