# 這是一個心血來潮的模糊聊天
## 使用套件
1. JSQ Message View Controller
2. Firebase SDK

## 待補完
1. JSQ view 在 iOS 9上有很多問題，有些是因為splitVIew造成的autolayout問題
2. firebase上的切割room，跟建立一個表可以查
3. 其實沒啥問題，但是要做驗證機制

## Firebase 
會使用Firebase也是因為之前使用過，速度上滿快的，而且不太需要擔心各種架設後端的問題，可能還會扯到資料庫跟socket的部份。
### Firebase setup
一開始當然要先建立連線啦！

```swift
var myRootRef = Firebase(url: "https://dinosaur-facts.firebaseio.com/").
```

以上就可以對你的Firebase做連線了！

Firebase是依據網址來區分朝狀區塊

如果你再網址後面加上`dinosaurs`，如：

```
https://dinosaur-facts.firebaseio.com/dinosaurs
```

就可以抓到一堆 `dinosaurs` 了！變成在 `dinosaurs` 的node上面。於是你會抓到一堆恐龍。

### 瞭解資料型態
在`Firebase`中，你只可以傳進 `String`, `Int`, `Array`, `Dictionary`四種型態（iOS中的限制），而他會幫你自動轉成JSON type.

讓我們看看下面的例子

```
{
  "users": {
    "mchen": {
      "friends": { "brinchen": true },
      "name": "Mary Chen",
      // our child node appears in the existing JSON tree
      "widgets": { "one": true, "three": true }
    },
    "brinchen": { ... },
    "hmadi": { ... }
  }
}
```

這是在Firebase之中，資料的樣子，就像是JSON

但是在iOS之中無法直接以Array的型態取值，必須以enumrate的方式取，就是`for..in`的方式取。
假設你取到的是一包陣列，那就必須要這樣子來取得每一筆資料的值

```swift
for s in snapshot.children {
	// do something...
}
```
### 傳送資料
要上傳一筆資料的話要先確定你的資料符合上面四種型態

```swift
let value = ["foo": "bar", "foo_arr": [1,2,3,4], "num": 1]
myRootRef.setValue(value)
```

### 隨機產生childId
這個很簡單，跟著我做就好，他會自動產生id

```swift
myRootRef.childByAutoId().setValue(value)
```

### Query

### Limit

### EqualTo

### indexOf Improve Performance

### 資料結構
優點與缺點




## 截圖（完成再捕）
