# note_Docker
Take notes of Docker on hand stuffs


# Reference
* [Lin Nick‎ 發文到 Python Taiwan]()  
```
一個關於在 Docker 裡面執行的問題

locale.setlocale(locale.LC_ALL, 'en_us')

在 mac 電腦上面跑 locale.currency 顯示貨幣金額 會正常運作
可是放在 Docker 去跑的時候, 會發生 Currency formatting is not possible using the 'C' locale.

試過了網路很多文章的解法,  都還是一樣有問題
測試專案裡面有包含試過方法

附上測試專案
https://github.com/nick6969/currency-question

謝謝
------------------
從 locale 關鍵字猜測，應該是編碼語系檔的問題。

docker image 以輕量快速為前提，
預設會移除許多不必要的內建功能、指令與設定檔來達到輕量化，
因此你需要自行在 alpine image 裡面安裝 locale or locale-gen 指令並產生你所需要的語系檔。

例如以 alpine image + locale-gen 為方向
可以查到類似這樣的參考：

https://gist.github.com/alextanhongpin/aa55c082a47b9a1b0060a12d85ae7923
```
```
篤誠 從 locale 關鍵字猜測，應該是編碼語系檔的問題。

docker image 以輕量快速為前提，
預設會移除許多不必要的內建功能、指令與設定檔來達到輕量化，
因此你需要自行在 alpine image 裡面安裝 locale or locale-gen 指令並產生你所需要的語系檔。

例如以 alpine image + locale-gen 為方向
可以查到類似這樣的參考：
https://gist.github.com/alextanhongpin/aa55c082a47b9a1b0060a12d85ae7923?fbclid=IwAR056spg_XZDQ8H7mQbR2VLzfTZADPByPz_hvlCHV1l5Pd0R6kGDW-aD_N0
```


* []()  
![alt tag]()

# h1 size

## h2 size

### h3 size

#### h4 size

##### h5 size

*strong*strong  
**strong**strong  

> quote  
> quote

- [ ] checklist1
- [x] checklist2

* 1
* 2
* 3

- 1
- 2
- 3