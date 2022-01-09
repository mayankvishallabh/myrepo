## load packages
source("C:/Users/Mayank/OneDrive/Finance/Crypto/packages.R")

## Clean data

# eth <- read_csv(file = "C:/Users/Mayank/OneDrive/Finance/Crypto/Binance_ETHUSDT_minute.csv", 
#                     skip = 1, 
#                     col_select = c(2,4,5,6,7,8,9,10))

# load daily data
eth <- read_csv(file = "C:/Users/Mayank/OneDrive/Finance/Crypto/ETH_USDT_Binance_Daily.csv")
eth$Date <- as.Date(x = eth$Date, format = "%b %d, %Y")
eth$HLC <- (eth$High + eth$Low + eth$Price)/3
eth$RSI <- TTR::RSI(price = eth$Price, n = 14)

MACD <- as.data.frame(TTR::MACD(x = eth$HLC, nFast = 12, nSlow = 26, nSig = 9, percent = FALSE))
MACD$delta <- MACD$macd - MACD$signal

eth$MACDhist <- MACD$delta
eth <- na.omit(eth)

# convert volume from character to numeric
for (i in 1:nrow(eth)) {
  if (str_detect(string = eth$Vol.[i], pattern = "K") == TRUE) {
    eth$Vol.[i] = as.numeric(str_extract(string = eth$Vol.[i], pattern = "[0-9]+(.[0-9]+)?"))*1e3
  } else if (str_detect(string = eth$Vol.[i], pattern = "M") == TRUE) {
    eth$Vol.[i] = as.numeric(str_extract(string = eth$Vol.[i], pattern = "[0-9]+(.[0-9]+)?"))*1e6
  } else {
    eth$Vol.[i] = as.numeric(str_extract(string = eth$Vol.[i], pattern = "[0-9]+(.[0-9]+)?"))
  }
}
eth$Vol. <- as.numeric(eth$Vol.)

# convert change% from character to numeric
eth$`Change %` <- as.numeric(sub(pattern = "%", replacement = "", x = eth$`Change %`))/100

# check out the dataset
summary(eth)
str(eth)


## Run analysis
