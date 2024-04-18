require 'openssl'
require 'openssl/digest'
require 'broker_full/security/credentials'
require 'broker_full/security/key'

module Security
  class Encryption
    attr_reader :cipher, :credentials

    def initialize
      @cipher = OpenSSL::Cipher.new 'AES-256-CBC'
    end

    # Must be in Base64 format
    def decrypt(data)
      cipher.decrypt
      @credentials = Credentials.acquire_all
      finish(data)
    end

    def encrypt(data)
      cipher.encrypt
      @credentials = Credentials.acquire_password(cipher)
      finish(data)
    end

    private

    def finish(data)
      key        = Key.new(credentials.password, credentials.salt, cipher.key_len)
      cipher.iv  = credentials.iv
      cipher.key = key.generate
      { value: final_value(cipher, data), credentials: credentials }
    end

    def final_value(cipher, data)
      value = cipher.update(data)
      value << cipher.final
    end
  end
end