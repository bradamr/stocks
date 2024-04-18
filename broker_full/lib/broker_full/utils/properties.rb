require 'yaml'
require_relative '../security/encryption'

module Utils
  class Properties
    attr_reader :files, :properties

    def initialize(files)
      @files      = files
      @properties = {}
      @keys       = {}
    end

    def self.load(files)
      new(files).load
    end

    def load
      return if files.nil? || files.empty?

      yaml_load(files) unless files.is_a?(Array)
      files.each { |f| yaml_load(f) } if files.is_a?(Array)

      properties
    end

    private

    def encoded_file_exists?(file)
      File.exists?(file + '.enc')
    end

    def yaml_load(file)
      dir = Dir.pwd
      env_file = File.join(dir[0,dir.index('stock_trade') + 11], 'config', file)
      env_file = env_file + '.enc' if encoded_file_exists?(env_file)
      raise "No such properties file: #{env_file}" unless File.exists?(env_file)

      file = file_contents(env_file)
      YAML.safe_load(file).each do |key, value|
        @properties[key.to_sym] = value
      end
    end

    def file_contents(file_path)
      return decrypt_file(file_path) unless file_path.index('.enc').nil?

      File.read(file_path)
    end

    def decrypt_file(file_path)
      file_data = File.read(file_path)
      puts "Decrypting file for: #{file_path}, enter any related credentials when prompted.\n"
      Encryption.new.decrypt(file_data)[:value]
    end

  end
end
