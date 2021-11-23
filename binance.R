# libs
library(httr)
library(jsonlite)
library(TTR)

binannceEnv <- new.env()

# urls
binannceEnv$BASE_API_URL <- 'https://api.binance.com'
binannceEnv$MARKET_URL <- paste(binannceEnv$BASE_API_URL,'api/v1/ticker/24hr', sep = '/')
binannceEnv$KLINES_URL <- paste(binannceEnv$BASE_API_URL,'api/v1/klines', sep = '/')

# timeframes
binannceEnv$TIME_FRAMES_VECTOR <- c('1m', '5m', '1h', '1d', '1w','1M')
binannceEnv$TIME_FRAMES_NAMES <- c('MINUTE_1', 'MINUTE_5', 'HOUR_1', 'DAY_1', 'WEEK_1','MONTH_1')

binannceEnv$TIME_FRAMES <- rbind(binannceEnv$TIME_FRAMES_VECTOR)
colnames(binannceEnv$TIME_FRAMES) <- binannceEnv$TIME_FRAMES_NAMES
rm('TIME_FRAMES_VECTOR', 'TIME_FRAMES_NAMES', envir = binannceEnv)

binannceEnv$CANDLE_NAMES <- c(
  'openTime', 'open', 'high', 'low', 'close', 'volume',
  'closeTime', 'quoteAssetVolume', 'numberOfTrades',
  'takerBuyBaseAssetVolume',  'takerBuyQuoteAssetVolume', 'Ignore')

binannceEnv$MARKETS <- fromJSON(binannceEnv$MARKET_URL)


binannceEnv$getCandles <- function(interval, symbol) {
  url <- paste0(binannceEnv$KLINES_URL, '?interval=', interval, '&symbol=', symbol)
  matrix <- fromJSON(url)
  colnames(matrix) <- binannceEnv$CANDLE_NAMES
  return(matrix)
}


binannceEnv$getAllMarketCandles <- function(interval) {
  marketsLength <- length(binannceEnv$MARKETS$symbol)
  counter <- 0

  for(marketSymbol in binannceEnv$MARKETS$symbol){
    binannceEnv[[marketSymbol]] <- binannceEnv$getCandles(binannceEnv$TIME_FRAMES[,interval], marketSymbol)

    Sys.sleep(2)
    counter <- counter + 1
    print(sprintf("%s market %s from %s", marketSymbol, counter, marketsLength))
  }
}


