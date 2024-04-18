require_relative 'shared/callable'
require_relative 'shared/loggable'
require_relative '../models/stock_analysis'
require_relative '../models/stock_data'
require_relative 'stock_retriever'


module Services
  class StockService
    include Shared::Callable, Shared::Loggable
    attr_reader :analysis, :data, :properties, :stock_retriever

    def initialize(properties)
      @properties      = properties
      @data            = StockData.new(properties)
      @analysis        = StockAnalysis.new(data, properties)
      @stock_retriever = StockRetriever.new(data, properties)
    end

    def start
      logger.info "Retrieving stock quotes..."

      thread = Thread.new { stock_retriever.start }
      thread.join
    end
  end
end
