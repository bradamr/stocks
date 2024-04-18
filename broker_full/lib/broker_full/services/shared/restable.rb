require 'json'
require 'oauth'

module Shared
  module Restable
    CONTENT_TYPE_GET  = { "Content-Type" => "application/json" }.freeze
    CONTENT_TYPE_POST = { "Content-Type" => "application/xml" }.freeze

    def uri
      properties[:base_uri]
    end

    def properties
      raise 'Implement: Needed for configuration'
    end

    def submit(body, additional_context = nil, params = nil)
      token_call(:post, additional_context, params, body)
    end

    def request(additional_context = nil, params = nil)
      return if context.nil? || context.empty?

      token_call(:get, additional_context, params, nil)
    end

    def success?(response)
      response['response']['error'].downcase == 'success'
    end

    private

    def token_call_by_method(action, additional_context, params, body = nil)
      full_context = context_with_format(additional_context, params)

      case action
        when :get
          oauth_token.get(full_context, Restable::CONTENT_TYPE_GET)
        when :post
          oauth_token.post(full_context, body, CONTENT_TYPE_POST)
      end
    end

    def token_call(action, additional_context, params, body = nil)
      token_call_by_method(action, additional_context, params, body).body
    end

    def oauth_token
      consumer = OAuth::Consumer.new(properties[:consumer_key], 'def', { site: properties[:base_uri] })
      OAuth::AccessToken.new(consumer, properties[:oauth_token], properties[:oauth_token_secret])
    end

    def context_with_format(additional_context = nil, params = nil)
      params = params.nil? ? "" : "?#{params}"
      return "#{context}.#{format}#{params}" if additional_context.nil?

      "#{with_subcontext(additional_context)}.#{format}#{params}"
    end

    def context
      @context ||= "/#{properties[:base_context][self.class::CONTEXT]}"
    end

    def with_subcontext(additional_context)
      "#{context}/#{additional_context}"
    end

    def format
      self.class::FORMAT
    end
  end
end