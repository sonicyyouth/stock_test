setwd("~/Dropbox/Rworkspace/projects/stock")
library(quantmod)
sse<-getSymbols("000003.sz",from = "2010-01-01",to = Sys.Date(),src = "yahoo")
sse1<-getSymbols(".ss",from = "2010-01-01",to = Sys.Date(),src = "yahoo")
sz = read.csv("szstock.csv",sep = ";")
x = read.table("shenstock.txt",sep = "\t",colClasses = "character")
rownames(x) = x[,1]
x = data.frame(x,code = paste(x[,1],".sz",sep = ""))
szname = x
save(szname,file = "szname.rda")
plant = xpathSApply(htmlParse("ssstock.html"), "//td", xmlValue)
long = plant[nchar(plant) >30]
long = long[!duplicated(long)]
long = long[-20]
x1 = sapply(long,function(x)strsplit(x,"[0-9]+"))
x1 = lapply(x1,function(x)x[-1])
x2 = sapply(long,function(x)strsplit(x,"[\u4e00-\u9fa5]+"))
all(sapply(x1,length) == sapply(x2,length))
ssname = data.frame(name = unlist(x1),numb = unlist(x2),code = paste(unlist(x2),".ss",sep = ""))
rownames(ssname) = ssname[,2]

url = "http://stock.sina.com.cn/stock/quote/sha0.html"
url = paste("http://stock.finance.qq.com/hqing/hqst/paiminglist1.htm?page=",seq(1,19),sep = "")
url = paste("http://table.finance.yahoo.com/table.csv?s=",stockname[,3],sep = "")
url = "http://quotes.money.163.com/service/chddata.html?code=0603688&start=20000409&end=20150325&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP"
destfile = paste("stock",stockname[,3],".csv",sep = "")
for(i in 1:nrow(stockname)){
  download.file(url, destfile[10], quiet = TRUE)
}
library(XML)
ssname = unlist(lapply(seq(17),function(x){
  plain.text <- xpathSApply(htmlParse(url[x]), "//a", xmlValue)
}))
ssname = unlist(ssname)
ss = ssname[grep("60",ssname)]
doc = htmlTreeParse(url[1])
plain.text <- xpathSApply(doc, "//a", xmlValue)[9:107]
# root = xmlRoot(doc)
# child = xmlChildren(root)
# child1 = xmlChildren(child[[2]])[[1]][[12]][[1]]
# child2 = xmlChildren(xmlChildren(child1)[[5]])[[2]]
x = as.character(x[1,])
x[1]
x1 = strsplit(x,"\\(")
x2 = do.call(rbind,x1)
x2[,2] = sub("\\)","",x2[,2])
stocklist = x2
save(stocklist,file = "stocklist.rda")
x2 = x2[order(x2[,2]),]
length(grep("^6",x2[,2]))
length(grep("^3",x2[,2]))
length(grep("^0",x2[,2]))
stockname[grep("^6",stockname[,2]),3] = paste(stockname[grep("^6",stockname[,2]),2],".ss",sep = "")
stockname[grep("^3",stockname[,2]),3] = paste(stockname[grep("^3",stockname[,2]),2],".sz",sep = "")


stockname[grep("^0",stockname[,2]),3] = paste(stockname[grep("^6",stockname[,2]),2],".sz",sep = "")

stocklist = data.frame(stocklist,code = x2[,2])
stocklist = stocklist[order(stocklist[,2]),]
sname = as.list(stocklist[,3])
for(i in 1:nrow(stockname)){
  getSymbols(stockname[,3],src = "yahoo")
}
data = lapply(stockname[1:1000,3],function(x)getSymbols(x,src = "yahoo"))

address <- "http://quotes.money.163.com/service/chddata.html"
field <- "&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP"
path <- getwd()
year <- substr(Sys.time(), 1, 4)
month <- substr(Sys.time(), 6, 7)
day <- substr(Sys.time(), 9, 10)
end <- paste(year, month, day, sep = "")
name <- paste("0", name, sep = "")
if (as.numeric(name) > 600000) {
  url <- paste(address, "?code=0", name, "&start=", start, "&end=", end, field, sep = "")
} else {
  url <- paste(address, "?code=1", name, "&start=", start, "&end=", end, field, sep = "")
}
destfile <- paste(path, name, ".csv", sep = "")
download.file(url, destfile, quiet = TRUE)
sourceCpp("~/Dropbox/Rworkspace/rcpp/daysrate.cpp")
for(i in dir()){
#   x = read.csv(file = i,head = T,fileEncoding = "GBK")
#   colnames(x) = c("date","code","name","close","high","low","open","beforeclose","change","percent","hands","volume","value","total","circul")
#   #x$code = gsub("\\'","",x$code)
  x = read.csv(file = i,head = T)
  x$date = as.Date(x$date)
  x = x[order(x$date),]
  x$daysrate = round(daysrate(x$volume,x$percent,5),5)
  #x[x$percent == "None",10:11] = 0
  write.csv(x,file = i,fileEncoding = "utf-8")
}
x = read.csv(file = "./data/000001.csv",head = T)


d15 = x[x$daysrate > 0.15 & x$date > "2014-03-01",]
if (ncol(d15)>=1)sigsate = d15$date[datediff(d15$date) >5]
#day15 = lapply(stock,x[x$daysrate > 0.15,])
day15 = vector("list",length(stock))
for (i in 1:length(stock)) day15[[i]] = stockx[[i]][stockx[[i]]$daysrate > 0.15,]
for (i in 1:length(stock)) stock[[i]]$date = as.Date(stock[[i]]$date)
d15len = unlist(lapply(day15,nrow))
day15 = day15[which(d15len > 0)]
sdaysx = lapply(day15,function(x)signdays(x$X))
