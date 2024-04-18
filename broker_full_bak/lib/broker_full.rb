require "full/version"

# Config ########################################################
require 'config/alpaca_api_config'
#################################################################

# Models ########################################################
require 'models/brokers/ally'
require 'models/brokers/alpaca'
require 'models/account'
require 'models/broker'
require 'models/broker_manager'
require 'models/clock'
require 'models/constants'
require 'models/decision'
require 'models/order'
require 'models/quote'
require 'models/stock_analysis'
require 'models/stock_data'
require 'models/stock_holding'
require 'models/trader'
#################################################################

# Services ######################################################
require 'services/apis/ally/account'
require 'services/apis/ally/market'
require 'services/apis/ally/order'
require 'services/apis/ally/stock_streamer'

require 'services/apis/factory'
require 'services/apis/restable'

require 'services/shared/callable'
require 'services/shared/loggable'
require 'services/shared/restable'

require 'services/serializers/account_serialization'
require 'services/serializers/market_serialization'
require 'services/serializers/order_serialization'
require 'services/serializers/json_serializers'

require 'services/account_service'
require 'services/stock_retriever'
require 'services/stock_service'
#################################################################

# Utils ##########################################################
require 'utils/api_query'
require 'utils/calculations'
require 'utils/db_logger'
require 'utils/properties'
require 'utils/stock_historical_data'
#################################################################

# Security ######################################################
require 'security/encryption'
require 'security/credentials'
require 'security/key'
#################################################################
