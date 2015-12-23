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

```JSON
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
### 取得資料
Firebase中要取得資料很簡單，只要用`observeEventType`就可以取到了。
```swift
myRootRef.observeEventType(FEventType){ (snapshot: FDataSnapshot!) -> Void in           
}
```

`FEventType`常用的有`.Value`跟`.ChildAdd`型態。

`.Value`是只要任何資料有變動都會通知。

`.ChildAdd`是只有在新增時才會通知。

可以善用這些監聽來做出聊天室的功能。


### Query
在Firebase的Query限制比較多，他只能對一個node做query，而且只能對一層做query。

讓我們看看下面的例子

```JSON
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

假設你現在在users的node上，你可以對這些資料作`queryOrderWithKey`，那這些資料就會被排列好。但是你無法再次對這個query再做一次query，這是他的一個限制。

可

```swift
myRootRef.queryOrderWithKey()
```

不可

```swift
myRootRef.queryOrderWithKey().queryOrderWithChild(friends)
```

### Limit
在Firebase，一個query會將所有的資料都dump出來。所以這邊如果你不想一次讓所有的聊天訊息都被load出來，你可以對他做限制，一次可以只要求一些資料就好。

在此我們先拿到儲存訊息的node。

```swift
myRootRef.childByAppendingPath("messages")
```

接著我們只想要拿到最新的`25`筆資料

```swift
myRootRef.childByAppendingPath("messages").quertLimitToLast(25)
```

即可拿到最新的25筆資料。

### EqualTo
如果你想要指定要拿到的資料，可以使用這個方法拿到想要的資料。但是這邊只能指定`String`, `NSNumber` 或者 `nil`。而我嘗試過的結果，你要指定資料，key下面對應到的就要是value，而不能是一個object。

譬如你只想要拿到某A使用者發出的訊息，先是要query到你要查找的key上，假設我們有一個key會對應到使用者名稱，最後才`queryEqualTo("something")`

```swift
myRootRef.childByAppendingPath("messages").queryOrderByChild("user").queryEqualTo("A")
```

## Query 上的限制
Query有分幾類型 `queryOrder`類，`queryLimit`類，`queryEqualTo`類。

只有`queryOrder`不能一直連續呼叫，Firebase只允許你呼叫一次。

但是`queryLimit`類，`queryEqualTo`類，就沒有關係了，順序上不會互相衝突，也可以連續呼叫。（雖然意義上不大）

### indexOf Improve Performance
`.indexOf`可以限制你在query時候查找的位置，可以不要查找資料量大的地方，可以讓效能變好。
例子：

```JSON
room: {
	user_id_1: 10,
	user_id_2: 98,
	messages: [...一堆資料]
}
```

messages一定很大包，而且會隨著時間推進而變大，所以我們不要每次query都要比較他。於是我們可以在`rules`這邊做：

```JSON
{
    "rules": {
        ".read": true,
        ".write": true,
        "conversations": {
          ".indexOn": ["user_id_1", "user_id_2"]
        }
    }
}
```

就可以只查找user1, user2的資料，速度上會很多。

### 資料結構
#### 優點與缺點
##### 不好
這個方式設計的話你每次都會把messages給讀出來，資料不僅大包還會拖慢效能。
於是用flatten data的想法去設計。
```JSON
{
	conversations: {
		room1: {
			user_1: 1,
			user_2: 2,
			messages: [...]
		},
		room2: {...},
		room3: {...},
		room4: {...},
		.
		.
		.
	}
}
```

##### 好
我們把大包的資料放在另外的node上面，這樣我們每次取conversations時不會把所有的訊息都拿出來了。我們需要訊息時才會依據room名稱去存取。
```JSON
{
	conversations: {
		room1: {
			user_1: 1,
			user_2: 2,
			room_name: "room1"
		},
		room2: {...},
		room3: {...},
		room4: {...},
		.
		.
		.
	},
	rooms: {
		room1: {
			msg1: {},
			msg2: {},
			.
			.
			.
		},
		room2: {...},
		room3: {...},
		room4: {...},
		.
		.
		.
	}
}
```


## 截圖（完成再捕）
