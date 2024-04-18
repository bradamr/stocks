require 'base64'
require 'io/console'

module Security
  class Credentials
    attr_reader :iv, :password, :salt

    def initialize(password, iv, salt)
      @password = password
      @iv       = iv
      @salt     = salt
    end

    def self.acquire_all
      password = display_and_get_prompt('Password')
      iv       = Base64.decode64(display_and_get_prompt('IV'))
      salt     = Base64.decode64(display_and_get_prompt('Salt'))

      new(password, iv, salt)
    end

    def self.acquire_password(cipher)
      password = display_and_get_prompt('Password')
      iv       = cipher.random_iv
      salt     = OpenSSL::Random.random_bytes 16

      new(password, iv, salt)
    end

    private

    def self.display_and_get_prompt(type)
      print "Enter #{type}: "
      STDIN.noecho(&:gets).chomp
    end
  end
end