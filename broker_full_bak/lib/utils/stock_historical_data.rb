require 'pg'

module Utils
  class StockHistoricalData
    attr_reader :db, :user

    def initialize
      @db   = 'stock_data'
      @user = 'xwps'
    end

    def data_statement(symbol, market_date, limit)
      limit_clause = limit ? "limit #{limit}" : ''
      "select * from stock_data where symbol = '#{symbol}' AND trade_date = '#{market_date}' ORDER BY ID ASC #{limit_clause} OFFSET 100"
    end

    def self.single_day(symbol, market_date, limit = nil)
      new.single_day(symbol, market_date, limit) do |record|
        yield record
      end
    end

    def single_day(symbol, market_date, limit)
      con = nil

      begin
        statement = data_statement(symbol, market_date, limit)
        con       = PG.connect(dbname: db, user: user)
        con.exec(statement).each { |rec| yield rec }
      rescue PG::Error => e
        puts "Error opening connection: #{e.message}"
      ensure
        con&.close
      end
    end
  end
end