import pandas as pd
import tushare as ts
import numpy as np
import os
import pandas.io.data
from matplotlib.finance import quotes_historical_yahoo
import datetime

import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

os.getcwd()
os.chdir("/home/liuqun/Dropbox/Rworkspace/projects/stock")
address = "http://quotes.money.163.com/service/chddata.html"
field = "&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP"
start = '19910102'
end = '20150911'
path = os.getcwd()+'/data/'
for i in range(2185,len(codelist)):
    if codelist[i][0] == '6': 
      url = address + "?code=0" + codelist[i] + "&start=" + start + "&end=" + end + field
    else:
      url = address + "?code=1" + codelist[i] + "&start=" + start + "&end=" + end + field
    destfile = path + codelist[i] + ".csv"
    cs = pd.read_csv(url)
    cs = cs.drop(cs.columns[2],axis = 1)
    cs.columns = ['date','code','close','high','low','open','yesterclose','change','percent','hands','volume','value','total','circus']
    cs = cs.set_index('date')
    cs.to_csv(destfile)

start = datetime.datetime(1991, 1, 1)
end = datetime.datetime(2015, 9, 11)
f = pd.io.data.DataReader("600519.SS", 'yahoo', start, end)

g = pd.io.data.DataReader("000001", 'google', start, end)
x = quotes_historical_yahoo('000001.SZ',(2001,1,1),(2015,9,11))
path1 = os.getcwd()+'/data1/'
if not os.path.exists(path1):
    os.makedirs(path1)
stocklist = ts.get_stock_basics()
codelist = stocklist.index.values
codelist.sort()
for i in range(len(codelist)):
    file = path1 + codelist[i]+ ".csv"
    stk = ts.get_hist_data(codelist[i])
    stk.to_csv(file)

i = 1

for i in range(len(codelist)):
    file = path +"h"+ codelist[i]+ ".csv"
    stk = ts.get_h_data(codelist[i], start = '2012-10-01', retry_count = 5)
    stk.to_csv(file)
x = codelist[1]
x1 = "./data/"+x+".csv"
x = ts.get_hist_data('002337')
x1 = ts.get_h_data('002337', start = '2012-09-10')
x3 = ts.get_h_data('002337', start = '2012-09-10',autype = None)
x4 = ts.get_h_data('002337', start = '2012-09-10',autype = 'qfq')

x2 = x[::-1]
today = ts.get_today_all()
today = today.set_index('code')
today.sort_index(inplace = True)
today = today.convert_objects(convert_numeric = True)
x = today.code
files = os.listdir(path)
files.sort()
high5 = pd.DataFrame()
for i in range(len(files)):
    file = path+files[i]
    shareall = pd.read_csv(file,index_col = 0,na_values = "None")
    shareall = shareall[::-1]
    shareall['percent'] = shareall['percent'].fillna(0)
    shareall["interm"] = 1/(1+shareall.percent*0.01)
    x = np.cumprod(shareall.interm).tolist()
    x.insert(0,1)
    shareall["strd"] = x[:len(shareall.index)]
    shareall["fivechg"] = 0
    shareall["tenchg"] = 0
    for i in range(shareall.shape[0]-5):
        shareall.iloc[i,15] = (shareall.iloc[i,14] - shareall.iloc[i+5,14])/shareall.iloc[i+5,14]
    for i in range(shareall.shape[0]-10):
        shareall.iloc[i,16] = (shareall.iloc[i,14] - shareall.iloc[i+10,14])/shareall.iloc[i+10,14]
    high = shareall.loc[shareall['fivechg'] > 0.15]
    high5 = high5.append(high)    
    shareall.to_csv(file)
shshareall.index = pd.to_datetime(shareall.index)
high5
shareall.dtypes
shareall.iloc[:10,1:13] = shareall.iloc[:,1:13].astype(float)
for i in range(1,len(files)):
    shareall = 
