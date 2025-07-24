#import "@preview/touying:0.6.1": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codelst:2.0.2": sourcecode
// #import "theme.typ": *
#import themes.university: *

#let fonts = ("libertinus serif", "LXGW WenKai TC")
#if not "x-preview" in sys.inputs {
  fonts = (
    (name: "Twemoji Mozilla", covers: regex("[^0-9a-zA-Z]")),
    ..fonts
  )
}

#set text(font: fonts)
#show: university-theme.with(
  aspect-ratio: "16-9",
  align: horizon,
  config-info(
    title: [Godot: Part I],
    subtitle: [the absolute basics],
    author: [CSIE Challenge 2025],
    date: datetime.today(),
  ),
)

// #show heading.where(level: 1): set heading(numbering: numbly())
#let exlink = (..args) => {
  show link: body => box(text(blue, [
    #set raw(lang: none)
    #body
    #box(place(bottom + left, dy: -.2em,
      box(image("img/link-external-svgrepo-com.svg", width: .6em), stroke: 0pt + black)
    ))
    #h(.6em)
  ]), stroke: (bottom: 1pt + blue), outset: (bottom: .2em))
  link(..args)
}
#set quote(block: true)
#set raw(lang: "gd", syntaxes: "GDScript.sublime-syntax")


#title-slide()

---

#exlink("https://docs.godotengine.org/en/stable/index.html")[Godot 官方文件]

---

== Outline

#context {
  let headings = query(heading.where(level: 1))
  enum(
    ..headings.map((elem) => {
      link(elem.location(), [#elem.body])
    }),
    tight: false,
  )
}

---

= Environment Setup

---

== Godot Engine/Editor

#exlink("https://godotengine.org/")[Godot 官網]

- Linux
  - 下載 #emoji.arrow.r 解壓縮 #emoji.arrow.r executable

- Windows/MacOS
  - #text(font: "noto sans cjk tc")[¯\\\_(ツ)\_/¯]

---

== 在 VS code 寫 GDscript（僅供參考）

內建編輯器不難用，但是如果你堅持的話你可以 #exlink("https://medium.com/@eduardo.juliaojr_1012/setting-up-environment-godot-with-vscode-a6c6e718b5ae")[這樣]

#image("img/vscode-extensions.png", height: 40%)

破病還蠻多的，使用體驗可能跟內建編輯器沒有差非常多

---

==

#image("img/godot-editor-default.png")

---

= The Godot Engine

---

== 遊戲引擎

遊戲是一個每 $1\/"FPS"$ 秒跑一次的迴圈

- 處理輸入
  #only("2")[
    - 攔截#underline[鍵盤、滑鼠事件]，#underline[叫醒對的遊戲物件]做出反應
  ]
- 更新遊戲物件
  #only("2")[
    - 更新#underline[物件狀態]（大小位置、顯示材質、動畫）
    - #underline[物件之間相互溝通]、交互作用
  ]
- 渲染畫面
  #only("2")[
    - 計算物件位置
    - 顯示物件
  ]

---

// scoreboard.py：\~150 行

// #box(
//   height: 80%,
//   columns(3)[
//     #set align(center)
//     #image("img/challenge2024-1.png")
//     #image("img/challenge2024-2.png")
//     #image("img/challenge2024-3.png")
//   ]
// )

---

遊戲引擎的工作：

- 處理跟遊戲邏輯無關的工作
  - 渲染

- 讓你自己寫遊戲邏輯
  - 腳本或模組

- 提供一套工具讓你處理常見的任務
  - 輸入處理
  - 物件之間的溝通機制

---

== Godot

#exlink("https://docs.godotengine.org/en/stable/getting_started/introduction/key_concepts_overview.html")[Overview of Godot's key concepts]

- Node：單一個遊戲物件，可以是一張圖片、一個碰撞箱

- Scene：一棵 Node 組成的樹，可以代表一個角色、一個場景

- Signal：node 之間溝通的管道

- Script：黏在一個 node 上，讓 node 有額外的行為

---

== Nodes & Scenes

#grid(columns: (1fr, 3fr), rows: (1fr), gutter: 1em)[
  #image("img/scene-example-2.png")
][
  #image("img/scene-example-1.png")
]

---

#grid(columns: (1fr, 3fr), rows: (1fr), gutter: 1em)[
  #image("img/scene-example-4.png")
][
  #image("img/scene-example-3.png")
]

---

#exlink("https://docs.godotengine.org/en/stable/classes/index.html")[各種 Node 列表]

Node 有八百萬種，像是

- Sprite2D：一張 2D 圖片或材質
- RigidBody2D：處理 2D 物理 #exlink("https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html")[Physics introduction]
- Button：按鈕
- Timer：計時器

---

#image("img/godot-node-selection.png")

---

== Signal

signal 是一種事件收發的機制，隨便一個人發信號，預先指定的一些函數就會被叫醒

- 按鈕被按下去，退出遊戲
- 多人遊戲 client 傳一個請求，傳回覆回去
- 血量歸零，遊戲結束
- ...etc.

跟 #exlink("https://nodejs.org/api/events.html")[Node.js `EventEmitter`] 和 #exlink("https://github.com/seantsao00/Challenge2024/blob/main/event_manager/event_manager.py")[Challenge 2024 `EventManager`] 無限的像

---

signal 也有八百萬種，還可以自訂新的 signal

#image("img/godot-signal-example.png", height: 80%)

---

== Scripting

可以寫一份腳本#box(outset: (bottom: .2em), stroke: (bottom: 1pt + black), [黏在一個 node 上面])，為那個 node 加上額外功能

- 每一幀往哪裡移動一點、往哪個方向轉動一點（#exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html")[Idle and Physics Processing]）
- 接到輸入的時候做點什麼（#exlink("https://docs.godotengine.org/en/stable/classes/class_input.html")[Input Class]）
- 加入或刪除 node/scene（#exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/nodes_and_scene_instances.html")[Nodes and scene instances]、#exlink("https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-queue-free")[`Node.queue_free()`]）
- 對一整群 node 做一件事情（#exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html")[Groups]）

Godot 支援 GDScript 和 C\#，我們今年計畫用 GDScript

---

例：小恐龍遊戲的根節點

#sourcecode[
  ```gd
  func _process(delta: float) -> void:
    if Input.is_action_pressed("ui_cancel"):
      game_exit()
    elif is_waiting && \
        Input.is_action_just_pressed("game_jump"):
      game_start()
      is_waiting = false
    elif is_playing:
      game_update(delta)
  ```
]

---

= GDScript

---

== GDScript

純新手向教學

- #exlink("https://docs.godotengine.org/en/stable/getting_started/introduction/learn_to_code_with_gdscript.html")[Learn to code with GDScript - Godot Docs]
- #exlink("https://gdquest.github.io/learn-gdscript/")[Learn GDScript From Zero]

你各位可能都不需要這個

---

#exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html")[GDScript - Godot Docs]

GDScript 很像 python（#exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#example-of-gdscript")[Example]），把 language reference 看過去你就大概會了

---

隨便瀏覽一下 #exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#keywords")[GDScript keywords] 的話，大部分都跟 python 長很像

- `as`：型別轉換
- `signal`：signal
- `preload`：有一點像 `import`

---

大概跟 python 差不多的部份

- Identifiers
- Operators
- Constants/Enums
- Statements and control flow
- Functions/Callables

---

== Identifiers

就是你想的像 python 那樣

有一些內建的特別的 class method 叫做 `_init`、`_process` 之類的，像是 python `__init__` 的感覺

#quote(attribution: exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#naming-conventions")[GDScript style guide])[Prepend a single underscore (\_) to virtual methods functions the user must override, private functions, and private variables]

---

#image("img/gdscript-naming-convention.png")

---

== Operators

#exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#operators")[GDscript operators]

一大堆，隨便看過去大概知道有什麼就好

絕大部分跟 python 一樣

---

== Constants

你想的那樣

`enum` 基本上就是一次讓你宣告一坨常數

#sourcecode[
  ```gd
  enum {TILE_BRICK, TILE_FLOOR, TILE_SPIKE, TILE_TELEPORT}
  # Is the same as:
  const TILE_BRICK = 0
  const TILE_FLOOR = 1
  const TILE_SPIKE = 2
  const TILE_TELEPORT = 3
  ```
]

---

== Statements and control flow

跟你想的一樣

- `if`、`elif`、`else`
- `while`、`for`、`break`、`continue`

---

長得跟 #raw(lang: "c", "switch") 很像但是數學比較好的 `match` 魔法

#sourcecode[
  ```gd
  match <test value>:
    <pattern(s)>:
      <block>
    <pattern(s)> when <pattern guard>:
      <block>
    <...>
  ```
]

魔法規則太多了所以 #exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#match")[match - Godot Docs]

---

== Functions/Callables

#sourcecode[
  ```gd
  func function_name(arg1: int) -> void:
    pass
  ```
]

大概只是把 python 的 #raw(lang: "py", "def") 換成 `func`

- class method 不用把 self 加進參數 #emoji.face.hearts
- 不需要 #raw(lang: "js", "bind(self)")
- 比較嚴格的 type annotation #emoji.face.hearts
- `static` #emoji.checkmark.box、lambda function #emoji.checkmark.box

---

== GDScript

跟 python 比較不一樣的部份

- Classes
- Types、Variables、Type Specification、Literals
- Exports、Annotations
- Signals、Await

---

== Classes

- 一個檔案自己是一個 class，裡面可以有其他的 class

- `extends` #emoji.checkmark.box、`super` #emoji.checkmark.box
  - 沒有多重繼承
  - 沒有 virtual function/class，也許只能 `assert(false)`

- `ClassName.new()`（$approx$ `new ClassName()`）

---

#exlink("https://docs.godotengine.org/en/stable/classes/class_object.html")[Object Class - Godot Docs]

- `_init()`（$approx$ `__init__(self)`）
- `free()`

---

#exlink("https://docs.godotengine.org/en/stable/classes/class_node.html")[Node Class - Godot Docs]

- 初始化
  - `_enter_tree()`
  - `_ready()`
- game loop
  - `_process()`
  - `_physical_process()`
- 輸入處理
  - `_input()`
  - `_unhandled_input()`
- `queue_free()`

---

#exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#initialization-order")[Initialization Order]

+ `null` or default value
+ member variables _without_ `@ready`
+ `_init()`
+ exported values
+ \* `_enter_tree()`
+ \* member variables _with_ `@ready`
+ \* `_ready()`

---

== Variables、Type Specification

大概跟 python 很像

#sourcecode[
  ```gd
  var a                               # variant
  var b = 48763                       # variant
  var my_vector2: Vector2             # Vector2
  var my_node: Node = Sprite2D.new()  # Node
  var another_vector2 := Vector2()    # Vector2 (inferred)
  ```
]

---

瑣碎的細節

- casting（`as`）：subclass 轉 parent class、或是有好好定義的 conversion、或是吃 error
- `static` #emoji.checkmark.box、#exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#properties-setters-and-getters")[getters/setters] #emoji.checkmark.box

---

#quote(attribution: exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#variables")[Variables - Godot Docs])[
  Variables can optionally have a type specification. When a type is specified, the variable will be forced to have always that same type, and trying to assign an incompatible value will raise an error.
]

#emoji.face.hearts #emoji.heart.blue

---

TLDR：python 的 type annotation 是在搞笑，但是 GDScript 的不是

- 有指定型別的話，你可以確定他一定是那個型別
- assign 垃圾給有指定型別的變數會噴 runtime error 但是#text(red)[執行前不會有警告]
- 同理你有 #exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#typed-arrays")[Typed array] 可以用，不過只能是一維的
- 但是 #exlink("https://github.com/godotengine/godot-proposals/issues/8137")[GDScript 沒有 union 之類的酷炫型別]

---

== Types

一些比較有趣的內建型別

- Array、Dictionary、Callable：跟 python 差不多概念

- Variant：可以裝任意型別的變數

- #exlink("https://docs.godotengine.org/en/stable/classes/class_nodepath.html")[NodePath] -- 在 node tree 上的路徑
  - 不過靠 `$Node/Path` 就可以解決很多問題 \ #exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#literals")[GDScript literals] #exlink("https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-get-node")[`Node.get_node`]

- Color、vector[23][i]、Transform[23]D

- #exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#packed-arrays")[各種 Packed array]

- Signal：signal

---

- Pass by value/reference #emoji.skull
  - 大概跟 python 一樣
  - String、vector 之類的是 pass by value
  - Object、array、dictionary 之類的是 pass by reference
  - 不是內建的東西都算 Object

- `None` #emoji.arrow.r `null`、`True`/`False` #emoji.arrow.r `true`/`false`（我們需要秦始皇）

---

== Exports、Annotations

export 讓你的 class member 可以從右邊那欄編輯，並且跟 scene 一起存檔

有一大堆選項可以讓你的編輯區看起來很好看 #exlink("https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html")[GDScript exported properties - Godot Docs]

---

#exlink("https://docs.godotengine.org/en/stable/classes/class_%40gdscript.html#annotations")[Annotation 列表]

- 看起來像給你的 property 或 method 一些 decorator（但不是）
- 不可以自訂，#text(red, weight: "bold")[GDScript 沒有 decorator]（#exlink("https://github.com/godotengine/godot-proposals/issues/1316")[ref 1] #exlink("https://github.com/godotengine/godot/pull/102516")[ref 2]）

---

== Signals

#exlink("https://docs.godotengine.org/en/stable/classes/class_signal.html")[Signal Class - Godot Docs]

signal 自己是一個 type，可以宣告成一個 class member，也可以當變數傳來傳去

- `signal_name.connect(callable)`
- `signal_name.emit(args)`

使用例：記分板和角色都是某個根節點的小孩，角色碰到某個道具要更新記分板？

---

== Await、Coroutine

- `await signal_name`：暫停執行，直到某個 signal 被觸發
- `await function_call(args)`：暫停執行，直到某個函數結束

有 await 的函數自動變 coroutine，要呼叫他就要 await 或是把回傳值丟掉

#sourcecode[
  ```gd
  var v1 = await some_coroutine()  # ok
  var v2 = some_coroutine()  # no
  some_coroutine()  # ok
  ```
]

---

看起來很像 python 或 javascript 的 `async/await`，但相當不一樣

- 一次只能 await 一件事
- 不能趁你 await 的時候先做別的事情等等再等他

---

= Live Demo / Code Review?
