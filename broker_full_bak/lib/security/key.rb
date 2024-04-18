require 'openssl'
require 'openssl/digest'

module Security
  class Key < Struct.new(:password, :salt, :key_length)
    ITERATIONS = 25000.freeze

    def digest
      OpenSSL::Digest::SHA256.new
    end

    def generate
      OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, key_length, digest)
    end

    def iterations
      ITERATIONS
    end
  end
end