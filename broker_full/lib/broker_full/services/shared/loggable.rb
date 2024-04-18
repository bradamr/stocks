require_relative '../../utils/db_logger'
require 'logger'

module Shared
  module Loggable
    def logger

      @logger ||= LogManager.new(properties)
    end

    class LogManager
      attr_reader :file_logger, :properties

      def initialize(properties)
        @properties      = properties
        @database_logger = Utils::DBLogger.new
        @file_logger     = Logger.new(setup_log_file)
        STDOUT.sync      = true
      end

      def info(message)
        output('info', message)
      end

      def error(message, exception)
        output('error', message + error_message_with_stack(exception))
      end

      def debug(message)
        output('debug', message, true)
      end

      def warn(message)
        output('warn', message)
      end

      private

      def error_message_with_stack(exception)
        exception.message + ", Stack: #{exception.backtrace}"
      end

      def setup_log_file
        file      = File.open(properties[:log_file], 'a')
        file.sync = true
        file
      end

      def console_out(message)
        STDOUT << message + ".\n"
      end

      def output(level, message, console_only = false)
        console_out(prepend(level, message, true))
        file_log_by_level(level).call(prepend(level, message)) unless console_only
      end

      def file_log_by_level(level)
        case level.downcase
          when /debug/
            -> (message) { file_logger.debug message }
          when /info/
            -> (message) { file_logger.info message }
          when /error/
            -> (message) { file_logger.error message }
          when /warn/
            -> (message) { file_logger.warn message }
          else
            -> (message) { raise "Unknown error level called with: #{message}" }
        end
      end

      def prepend(level, message, full_prepend = false)
        return "#{timestamp} [#{properties[:name]}|#{level.upcase}] #{message}" if full_prepend

        "[#{properties[:name]}] #{message}"
      end

      def timestamp
        Time.now.strftime('%H:%M:%S')
      end
    end
  end
end