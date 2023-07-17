# Library yang dibutuhkan
library(readxl)
library(tidyverse)
library(skimr)
library(visdat)
library(mice)
library(VIM)
library(plyr)

# Import data
data1 <- read.csv("train-gamma.csv",
                  sep = ",")
View(data1)
glimpse(data1)

# Cek Kategori per variable (Noise dan Missing Value)
## 1.) DC024 (Asal provinsi)
data1 %>% group_by(DC024) %>% tally() %>% print(n=)
unique(data1$DC024) # bisa juga kek gini, tapi kurang lengkap (gak ada total observasi)

## 2.) DC025 (Jenis daerah tempat tinggal)
data1 %>% group_by(DC025) %>% tally()

## 3.) DC205 (Jenis fasilitas toilet)
data1 %>% group_by(DC205) %>% tally()

## 4.) DC206 (Kepemilikan listrik)
data1 %>% group_by(DC206) %>% tally() 

## 5.) DC207 (Kepemilikan radio)
data1 %>% group_by(DC207) %>% tally()

## 6.) DC208 (Kepemilikan televisi)
data1 %>% group_by(DC208) %>% tally()

## 7.) DC209 (Kepemilikan kulkas)
data1 %>% group_by(DC209) %>% tally()

## 8.) DC210 (Kepemilikan sepeda)
data1 %>% group_by(DC210) %>% tally()

## 9.) DC211 (Kepemilikan motor)
data1 %>% group_by(DC211) %>% tally()

## 10.) DC212 (Kepemilikan mobil)
data1 %>% group_by(DC212) %>% tally()

## 11.) DC213 (Bahan lantai utama)
data1 %>% group_by(DC213) %>% tally()

## 12.) DC214 (Bahan dinding utama)
data1 %>% group_by(DC214) %>% tally()

## 13.) DC215 (Bahan atap utama)
data1 %>% group_by(DC215) %>% tally()

## 14.) DC216 (Banyak ruangan untuk tidur) = Numerik
data1 %>% group_by(DC216) %>% tally()

## 15.) DC217 (Struktur hubungan dalam keluarga)
data1 %>% group_by(DC217) %>% tally()

## 16.) DC219 (Jenis kelamin kepala rumah tangga)
data1 %>% group_by(DC219) %>% tally()

## 17.) DC220 (Usia kepala rumah tangga) = Numerik
data1 %>% group_by(DC220) %>% tally() %>% print(n=85)

## 18.) DC226 (Jenis bahan bakar memasak)
data1 %>% group_by(DC226) %>% tally()

## 19.) DC230a (Tempat mencuci tangan)
data1 %>% group_by(DC230a) %>% tally()

## 20.) DC230b (Cuci tangan menggunakan air)
data1 %>% group_by(DC230b) %>% tally()

## 21.) DC232 (Memiliki sabun atau detergen)
data1 %>% group_by(DC232) %>% tally()

## 22.) DC232b (Memiliki abu, lumpur, pasir)
data1 %>% group_by(DC232b) %>% tally()

## 23.) DC235 (Lokasi sumber air)
data1 %>% group_by(DC235) %>% tally()

## 24.) DC237 (Apapun dilakukan untuk membuat air menjadi aman)
data1 %>% group_by(DC237) %>% tally()

## 25.) DC237a (Pengolahann air: Air direbus)
data1 %>% group_by(DC237a) %>% tally()

## 26.) DC237b (Pengolahann air: Air dikasih pemutih/kaporit)
data1 %>% group_by(DC237b) %>% tally()

## 27.) DC237c (Pengolahann air: Air disaring menggunakan kain)
data1 %>% group_by(DC237c) %>% tally()

## 28.) DC237d (Pengolahann air: Air difilter)
data1 %>% group_by(DC237d) %>% tally()

## 29.) DC237e (Pengolahann air: Air disinfeksi matahari)
data1 %>% group_by(DC237e) %>% tally()

## 30.) DC237f (Pengolahann air: Air didiamkan/diendapkan)
data1 %>% group_by(DC237f) %>% tally()

## 31.) DC241 (Tempat masak nasi)
data1 %>% group_by(DC241) %>% tally()

## 32.) DC242 (Mempunyai ruangan terpisah sebagai dapur)
data1 %>% group_by(DC242) %>% tally()

## 33.) DC244 (Memiliki lahan pertanian)
data1 %>% group_by(DC244) %>% tally()

## 34.) DC246 (Memiliki ternak)
data1 %>% group_by(DC246) %>% tally()

## 35.) DC252 (Frekuensi anggota keluarga yang merokok di rumah)
data1 %>% group_by(DC252) %>% tally()

## 36.) DC270a (Indeks kekayaan kota/desa)
data1 %>% group_by(DC270a) %>% tally()

## 37.) DC109 (Tipe fasilitas toilet)
data1 %>% group_by(DC109) %>% tally()

## 38.) DC142a (Luas lantai rumah) = Numerik
data1 %>% group_by(DC142a) %>% tally() %>% print(n=363)

## 39.) DC201 (Kelayakan air)
data1 %>% group_by(DC201) %>% tally()

# Cek missing value
colSums(is.na(data1)) # terlihat bahwa terdapat 250 NA yang berasal dari variabel "didik_ayah"

## Melihat sebaran missing value
md.pattern(data1)
aggr_plot <- aggr(data1, col = c('navyblue', 'red'),
                  numbers = TRUE,
                  sortvars = TRUE,
                  labels = names(data1),
                  cek.axis = 7,
                  gap = 3,
                  ylab = c("Histogram of Missing Data", "Pattern"))

# Cek duplikat data
data3 <- data1[,2:40]
duplicated(data1) 
sum(duplicated(data1))
data1 %>%
  group_by_all() %>%
  filter(n()>1) %>%
  ungroup()

# Cek imbalance data (variabel target)
table(data1$DC201)
prop.table(table(data1$DC201))

# Cek Distribusi dari data numerik (melihat indikasi untuk ditransformasi)
hist(data1$DC216) # menceng kanan
hist(data1$DC220) # normal
hist(data1$DC142a) # menceng kanan

# Cek Outlier pada data numerik

# Cek pola dari variabelnya
## Pada variabel DC237a sampai DC237f
Missingvalue_DC237 <- data.frame (DC237a  = which(is.na(data1$DC237a)),
                                  DC237b = which(is.na(data1$DC237b)),
                                  DC237c = which(is.na(data1$DC237c)),
                                  DC237d = which(is.na(data1$DC237d)),
                                  DC237e = which(is.na(data1$DC237e)),
                                  DC237f = which(is.na(data1$DC237f)))
## Pada variabel DC232 sampai DC232b
Missingvalue_DC232 <- data.frame (DC232  = which(is.na(data1$DC232)),
                                  DC232b = which(is.na(data1$DC232b)))

# Import data (Test)
data2 <- read.csv("test-gamma.csv",
                  sep = ",")
View(data2)
glimpse(data2)

# Cek Kategori per variable (Noise dan Missing Value) = Data Test
## 1.) DC024 (Asal provinsi)
data2 %>% group_by(DC024) %>% tally() %>% print(n=)
unique(data1$DC024) # bisa juga kek gini, tapi kurang lengkap (gak ada total observasi)

## 2.) DC025 (Jenis daerah tempat tinggal)
data2  %>% group_by(DC025) %>% tally()

## 3.) DC205 (Jenis fasilitas toilet)
data2 %>% group_by(DC205) %>% tally()

## 4.) DC206 (Kepemilikan listrik)
data2 %>% group_by(DC206) %>% tally() 

## 5.) DC207 (Kepemilikan radio)
data2 %>% group_by(DC207) %>% tally()

## 6.) DC208 (Kepemilikan televisi)
data2 %>% group_by(DC208) %>% tally()

## 7.) DC209 (Kepemilikan kulkas)
data2 %>% group_by(DC209) %>% tally()

## 8.) DC210 (Kepemilikan sepeda)
data2 %>% group_by(DC210) %>% tally()

## 9.) DC211 (Kepemilikan motor)
data2 %>% group_by(DC211) %>% tally()

## 10.) DC212 (Kepemilikan mobil)
data2 %>% group_by(DC212) %>% tally()

## 11.) DC213 (Bahan lantai utama)
data2 %>% group_by(DC213) %>% tally()

## 12.) DC214 (Bahan dinding utama)
data2 %>% group_by(DC214) %>% tally()

## 13.) DC215 (Bahan atap utama)
data2 %>% group_by(DC215) %>% tally()

## 14.) DC216 (Banyak ruangan untuk tidur) = Numerik
data2 %>% group_by(DC216) %>% tally()

## 15.) DC217 (Struktur hubungan dalam keluarga)
data2 %>% group_by(DC217) %>% tally()

## 16.) DC219 (Jenis kelamin kepala rumah tangga)
data2 %>% group_by(DC219) %>% tally()

## 17.) DC220 (Usia kepala rumah tangga) = Numerik
data2 %>% group_by(DC220) %>% tally() %>% print(n=)

## 18.) DC226 (Jenis bahan bakar memasak)
data2 %>% group_by(DC226) %>% tally()

## 19.) DC230a (Tempat mnencuci tangan)
data2 %>% group_by(DC230a) %>% tally()

## 20.) DC230b (Cuci tangan menggunakan air)
data2 %>% group_by(DC230b) %>% tally()

## 21.) DC232 (Memiliki sabun atau detergen)
data2 %>% group_by(DC232) %>% tally()

## 22.) DC232b (Memiliki abu, lumpur, pasir)
data2 %>% group_by(DC232b) %>% tally()

## 23.) DC235 (Lokasi sumber air)
data2 %>% group_by(DC235) %>% tally()

## 24.) DC237 (Apapun dilakukan untuk membuat air menjadi aman)
data2 %>% group_by(DC237) %>% tally()

## 25.) DC237a (Pengolahann air: Air direbus)
data2 %>% group_by(DC237a) %>% tally()

## 26.) DC237b (Pengolahann air: Air dikasih pemutih/kaporit)
data2 %>% group_by(DC237b) %>% tally()

## 27.) DC237c (Pengolahann air: Air disaring menggunakan kain)
data2 %>% group_by(DC237c) %>% tally()

## 28.) DC237d (Pengolahann air: Air difilter)
data2 %>% group_by(DC237d) %>% tally()

## 29.) DC237e (Pengolahann air: Air disinfeksi matahari)
data2 %>% group_by(DC237e) %>% tally()

## 30.) DC237f (Pengolahann air: Air didiamkan/diendapkan)
data2 %>% group_by(DC237f) %>% tally()

## 31.) DC241 (Tempat masak nasi)
data2 %>% group_by(DC241) %>% tally()

## 32.) DC242 (Mempunyai ruangan terpisah sebagai dapur)
data2 %>% group_by(DC242) %>% tally()

## 33.) DC244 (Memiliki lahan pertanian)
data2 %>% group_by(DC244) %>% tally()

## 34.) DC246 (Memiliki ternak)
data2 %>% group_by(DC246) %>% tally()

## 35.) DC252 (Frekuensi anggota keluarga yang merokok di rumah)
data2 %>% group_by(DC252) %>% tally()

## 36.) DC270a (Indeks kekayaan kota/desa)
data2 %>% group_by(DC270a) %>% tally()

## 37.) DC109 (Tipe fasilitas toilet)
data2 %>% group_by(DC109) %>% tally()

## 38.) DC142a (Luas lantai rumah) = Numerik
data2 %>% group_by(DC142a) %>% tally() %>% print(n=363)
