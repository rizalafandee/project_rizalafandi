# Load package
library(readxl)
library(tseries)
library(MVN)

# Load dataset dari Excel
df <- read_xlsx("C:/Users/Acer/Downloads/Alibaba.xlsx") ;df

# Mengambil kolom variabel
BABA <- ts(df$Terakhir)

# Pengujian linearitas dengan Terasvirta
terasvirta.test(BABA)
