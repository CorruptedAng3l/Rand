# Cache

## cache.invalidate

```lua
<nil> cache.invalidate(<Instance> object)
```

Deletes `object` from the Instance cache. Effectively invalidates `object` as a reference to the underlying Instance.

***

## cache.iscached

```lua
<boolean> cache.iscached(<Instance> object)
```

Checks whether `object` exists in the Instance cache.

***

## cache.replace

```lua
<nil> cache.replace(<Instance> object, <Instance> newobject)
```

Replaces `object` in the Instance cache with `newObject`.

***

## cloneref

```lua
<Instance> cloneref(<Instance> object)
```

Returns a copy of the Instance reference to `object`. This is useful for managing an Instance without directly referencing it.

***

## compareinstances

```lua
<boolean> compareinstances(<Instance> a, <Instance> b)
```

Returns whether objects `a` and `b` both reference the same Instance.

***

# Closures

## checkcaller

```lua
<boolean> checkcaller()
```

Returns whether the function currently running was called by the executor.

This is useful for metamethod hooks that behave differently when called by the game.

***

## clonefunction

```lua
<function> clonefunction(<function> func)
```

Generates a new closure based on the bytecode of function `func`.

```lua
local function foo()
    print("Hello, world!")
end

local bar = clonefunction(foo)

foo() --> Hello, world!
bar() --> Hello, world!
print(foo == bar) --> false
```

***

## getcallingscript

```lua
<BaseScript> getcallingscript()
```

Returns the script responsible for the currently running function.

***

## hookfunction

```lua
<function> hookfunction(<function> func, <function> hook)
```

Replaces `func` with `hook` internally, where `hook` will be invoked in place of `func` when called.&#x20;

Returns a new function that can be used to access the original definition of `func`.

If `func` is a Luau function (`islclosure(func) --> true`), the upvalue count of `hook` must be less than or equal to that of `func`. [Lua visibility rules](http://www.lua.org/manual/5.1/manual.html#2.6)

```lua
local function foo()
    print("Hello, world!")
end

local fooRef = hookfunction(foo, function(...)
    print("Hooked!")
end)

foo() --> Hooked!
fooRef() --> Hello, world!
```

***

## iscclosure

```lua
<boolean> iscclosure(<function> func)
```

Returns whether or not `func` is a closure whose source is written in C.

***

## islclosure

```lua
<boolean> islclosure(<function> func)
```

Returns whether or not `func` is a closure whose source is written in Luau.

***

## isexecutorclosure

```lua
<boolean> isexecutorclosure(<function> func)
```

Returns whether or not `func` was created by the executor.

***

## loadstring

```lua
<function?, string?> loadstring(<string> source, <string?> chunkname)
```

Generates a chunk from the given source code. The environment of the returned function is the global environment.

If there are no compilation errors, the chunk is returned by itself; otherwise, it returns `nil` plus the error message.

`chunkname` is used as the chunk name for error messages and debug information.

***

## newcclosure

```lua
<function> newcclosure(<function> func)
```

Returns a C closure that wraps `func`. The result is functionally identical to `func`, but identifies as a C closure.

```lua
local foo = function() return true end
local bar = newcclosure(foo)

print(bar()) --> true
```

***

# Console

## rconsoleclear

```lua
<nil> rconsoleclear()
```

Clears the output of the console window.

***

## rconsolecreate

```lua
<nil> rconsolecreate()
```

~~Opens the console window. Text previously output to the console will not be cleared.~~

⚠️  This function is disabled.

***

## rconsoledestroy

```lua
<nil> rconsoledestroy()
```

Clears the output of the console window.

***

## rconsoleinput

```lua
<string> rconsoleinput()
```

~~Waits for the user to input text into the console window. Returns the result.~~

⚠️  This function is disabled.

***

## rconsoleprint

```lua
<nil> rconsoleprint(<string> text)
```

Prints `text` to the console window. Does not clear existing text or create a new line.

***

## rconsolewarn

```lua
<nil> rconsolewarn(<string> text)
```

Prints `text` as a warning to the console window. Does not clear existing text or create a new line.

***

## rconsoleerror

```lua
<nil> rconsoleerror(<string> text)
```

Prints `text` as an error to the console window. Does not clear existing text or create a new line.

***

## rconsolesettitle

```lua
<nil> rconsolesettitle(<string> title)
```

~~Sets the title of the console window to `title`.~~

⚠️  This function is disabled.

***

# Crypt

## crypt.base64encode

```lua
<string> crypt.base64encode(<string> data)
```

Encodes a string of bytes into Base64.

***

## crypt.base64decode

```lua
<string> crypt.base64decode(<string> data)
```

Decodes a Base64 string to a string of bytes.

***

## crypt.encrypt

```lua
<string, string> crypt.encrypt(<string> data, <string> key, <string?> iv, <string?> mode)
```

Encrypts an unencoded string using AES encryption. Returns the base64 encoded and encrypted string, and the IV.

If an AES IV is not provided, a random one will be generated for you, and returned as a 2nd base64 encoded string.

The cipher modes are 'CBC', 'ECB', 'CTR', 'CFB', 'OFB', and 'GCM'. The default is 'CBC'.

***

## crypt.decrypt

```lua
<string> crypt.encrypt(<string> data, <string> key, <string> iv, <string> mode)
```

Decrypts the base64 encoded and encrypted content. Returns the raw string.

The cipher modes are 'CBC', 'ECB', 'CTR', 'CFB', 'OFB', and 'GCM'.

***

## crypt.generatebytes

```lua
<string> crypt.generatebytes(<number> size)
```

Generates a random sequence of bytes of the given size. Returns the sequence as a base64 encoded string.

***

## crypt.generatekey

```lua
<string> crypt.generatekey()
```

Generates a base64 encoded 256-bit key. The result can be used as the second parameter for the `crypt.encrypt` and `crypt.decrypt` functions.

***

## crypt.hash

```lua
<string> crypt.hash(<string> data, <string> algo)
```

Returns the result of hashing the data using the given algorithm.

Some algorithms include 'sha1', 'sha384', 'sha512', 'md5', 'sha256', 'sha3-224', 'sha3-256', and 'sha3-512'.

***
# Debug

## debug.isvalidlevel

```lua
<boolean> debug.isvalidlevel(<number> level)
```

Returns whether `level` is a valid level or not.

***

## debug.getregistry

```lua
<table<function | thread>> debug.getregistry()
```

Returns the lua registry.

***

## debug.getconstant

```lua
<any> debug.getconstant(<function | number> func, <number> index)
```

Returns the constant at `index` in the constant table of the function or level `func`. Throws an error if the constant does not exist.

***

## debug.getconstants

```lua
<table<any>> debug.getconstants(<function | number> func)
```

Returns the constant table of the function or level `func`.

***

## debug.getinfo

```lua
<DebugInfo> debug.getinfo(<function | number> func)
```

Returns debugger information about a function or stack level.

#### DebugInfo

| Field         | Type     | Description                                                                        |
| ------------- | -------- | ---------------------------------------------------------------------------------- |
| `source`      | string   | The name of the chunk that created the function.                                   |
| `short_src`   | string   | A "printable" version of `source` to be used in error messages.                    |
| `func`        | function | The function itself.                                                               |
| `what`        | string   | The string "Lua" if the function is a Luau function, or "C" if it is a C function. |
| `currentline` | number   | The current line where the given function is executing.                            |
| `name`        | string   | The name of the function.                                                          |
| `nups`        | number   | The number of upvalues in the function.                                            |
| `numparams`   | number   | The number of parameters in the function.                                          |
| `is_vararg`   | number   | Whether the function has a variadic argument.                                      |

***

## debug.getproto

```lua
<function | table<function>> debug.getproto(<function | number> func, <number> index, <boolean?> active)
```

Returns the proto at `index` in the function or level `func` if `active` is false.

If `active` is true, then every active function of the proto is returned.

***

## debug.getprotos

```lua
<table<function>> debug.getprotos(<function | number> func)
```

Returns a list of protos of the function or level `func`.

***

## debug.getstack

```lua
<any | table<any>> debug.getstack(<function | number> func, <number?> index)
```

Returns the value at `index` in the stack frame `level`. Throws an error if no value could be found.

If `index` is not specified, then the entire stack frame is returned.

***

## debug.getupvalue

```lua
<any> debug.getupvalue(<function | number> func, <number> index)
```

Returns the upvalue at `index` in the function or level `func`. Throws an error if the upvalue does not exist.

An upvalue is a local variable used by an inner function, and is also called an *external local variable*.

Read more on [Lua visibility rules](http://www.lua.org/manual/5.1/manual.html#2.6).

***

## debug.getupvalues

```lua
<table<any>> debug.getupvalues(<function | number> func)
```

Returns a list of upvalues of the function or level `func`.

***

## debug.setconstant

```lua
<nil> debug.setconstant(<function | number> func, <number> index, <any> value)
```

Sets the constant at `index` in the function or level `func` to `value`.

***

## debug.setstack

```lua
<nil> debug.setstack(<function | number> func, <number> index, <any> value)
```

Sets the register at `index` in the stack frame `level` to `value`.

***

## debug.setupvalue

```lua
<nil> debug.setupvalue(<function | number> func, <number> index, <any> value)
```

Sets the upvalue at `index` in the function or level `func` to `value`.

***

# Drawing

## Drawing.new

```lua
<DrawingObject> Drawing.new(<string> type)
```

Create a new drawing object of the specified type.

<details>

<summary>Objects</summary>

## DrawingObject

### BaseDrawingObject

| Property     | Type     |
| ------------ | -------- |
| Visible      | boolean  |
| ZIndex       | number   |
| Transparency | number   |
| Color        | Color3   |
| Destroy      | function |

### Line

| Property  | Type    |
| --------- | ------- |
| From      | Vector2 |
| To        | Vector2 |
| Thickness | number  |

### Text

| Property     | Type    |
| ------------ | ------- |
| Text         | string  |
| TextBounds   | Vector2 |
| Font         | number  |
| Size         | number  |
| Position     | Vector2 |
| Center       | boolean |
| Outline      | boolean |
| OutlineColor | Color3  |

### Image

| Property | Type    |
| -------- | ------- |
| Data     | string  |
| Size     | Vector2 |
| Position | Vector2 |
| Rounding | number  |

### Circle

| Property  | Type    |
| --------- | ------- |
| NumSides  | number  |
| Radius    | number  |
| Position  | Vector2 |
| Thickness | number  |
| Filled    | boolean |

### Square

| Property  | Type    |
| --------- | ------- |
| Size      | Vector2 |
| Position  | Vector2 |
| Thickness | number  |
| Filled    | boolean |

### Quad

| Property  | Type    |
| --------- | ------- |
| PointA    | Vector2 |
| PointB    | Vector2 |
| PointC    | Vector2 |
| PointD    | Vector2 |
| Thickness | number  |
| Filled    | boolean |

### Triangle

| Property  | Type    |
| --------- | ------- |
| PointA    | Vector2 |
| PointB    | Vector2 |
| PointC    | Vector2 |
| Thickness | number  |
| Filled    | boolean |

</details>

***

## Drawing.Fonts

| Index     | Value |
| --------- | ----- |
| UI        | 0     |
| System    | 1     |
| Plex      | 2     |
| Monospace | 3     |

***

## cleardrawcache

```lua
<nil> cleardrawcache()
```

Destroys every drawing object in the cache. Invalidates references to the drawing objects.

***

## getrenderproperty

```lua
<any> getrenderproperty(<DrawingObject> drawing, <string> property)
```

Gets the value of a property of a drawing. Functionally identical to `drawing[property]`.

***

## isrenderobj

```lua
<boolean> isrenderobj(<any> object)
```

Returns whether the given object is a valid Drawing.

***

## setrenderproperty

```lua
<nil> setrenderproperty(<DrawingObject> drawing, <string> property, <any> value)
```

Sets the value of a property of a drawing. Functionally identical to `drawing[property] = value`.

***

# File System

## readfile

```lua
<string> readfile(<string> path)
```

Returns the contents of the file located at `path`.

***

## listfiles

```lua
<table<string>> listfiles(<string> path)
```

Returns a list of files and folders in the folder located at `path`. The returned list contains whole paths.

***

## writefile

```lua
<nil> writefile(<string> path, <string> data)
```

Writes `data` to the file located at `path` if it is not a folder.

***

## makefolder

```lua
<nil> makefolder(<string> path)
```

Creates a folder at `path` if it does not already exist.

***

## appendfile

```lua
<nil> appendfile(<string> path, <string> data)
```

Appends `data` to the end of the file located at `path`. Creates the file if it does not exist.

***

## isfile

```lua
<boolean> isfile(<string> path)
```

Returns whether or not `path` points to a file.

***

## isfolder

```lua
<boolean> isfolder(<string> path)
```

Returns whether or not `path` points to a folder.

***

## delfile

```lua
<nil> delfile(<string> path)
```

Removes the file located at `path`.

***

## delfolder

```lua
<nil> delfolder(<string> path)
```

Removes the folder located at `path`.

***

## loadfile

```lua
<function?, string?> loadfile(<string> path, <string?> chunkname)
```

Generates a chunk from the file located at `path`. The environment of the returned function is the global environment.

If there are no compilation errors, the chunk is returned by itself; otherwise, it returns `nil` plus the error message.

`chunkname` is used as the chunk name for error messages and debug information.

***

## dofile

```lua
<nil> dofile(<string> path)
```

Attempts to load the file located at `path` and execute it on a new thread.

***

# Input

## isrbxactive

```lua
<boolean> isrbxactive()
```

Returns whether the game's window is in focus. Must be true for other input functions to work.

***

## mouse1click

```lua
<nil> mouse1click()
```

Dispatches a left mouse button click.

***

## mouse1press

```lua
<nil> mouse1press()
```

Dispatches a left mouse button press.

***

## mouse1release

```lua
<nil> mouse1release()
```

Dispatches a left mouse button release.

***

## mouse2click

```lua
<nil> mouse2click()
```

Dispatches a right mouse button click.

***

## mouse2press

```lua
<nil> mouse2press()
```

Dispatches a right mouse button press.

***

## mouse2release

```lua
<nil> mouse2release()
```

Dispatches a right mouse button release.

***

## mousemoveabs

```lua
<nil> mousemoveabs(<number> x, <number> y)
```

Moves the mouse cursor to the specified absolute position.

***

## mousemoverel

```lua
<nil> mousemoverel(<number> x, <number> y)
```

Adjusts the mouse cursor by the specified relative amount.

***

## mousescroll

```lua
<nil> mousescroll(<number> pixels)
```

Dispatches a mouse scroll by the specified number of pixels.

***

# Instance

## fireclickdetector

```lua
<nil> fireclickdetector(<ClickDetector> object, <number?> distance)
```

Dispatches a click or hover event to the given ClickDetector. When absent, `distance` defaults to zero.

```lua
local clickDetector = workspace.Door.Button.ClickDetector
fireclickdetector(clickDetector, 10 + math.random())
```

***

## firetouchinterest

```lua
<nil> firetouchinterest(<Instance> instance, <Instance> touchingPart, <bool> isTouching)
```

Simulates a touch event between two parts.

```lua
local rootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
firetouchinterest(workspace.TouchPart, rootPart, true)
firetouchinterest(workspace.TouchPart, rootPart, false)
```

***

## isnetworkowner

```lua
<bool> isnetworkowner(<Instance> part)
```

Returns `true` if the Part is owned by the player.

***

## getcallbackvalue

```lua
<function?> getcallbackvalue(<Instance> object, <string> property)
```

Returns the function assigned to a callback property of `object`, which cannot be indexed normally.

***

## fireproximityprompt

```lua
<nil> fireproximityprompt(<ProximityPrompt> prompt)
```

Fires the trigger of `prompt`.

***

## getconnections

```lua
<table<ConnectionObject>> getconnections(<RBXScriptSignal> signal)
```

Creates a list of Connection objects for the functions connected to `signal`.

| Field           | Type      | Description                                                                    |
| --------------- | --------- | ------------------------------------------------------------------------------ |
| `Enabled`       | boolean   | Whether the connection can receive events.                                     |
| `ForeignState`  | boolean   | Whether the function was connected by a foreign Luau state (i.e. CoreScripts). |
| `LuaConnection` | boolean   | Whether the connection was created in Luau code.                               |
| `Function`      | function? | The function bound to this connection. Nil when `ForeignState` is true.        |
| `Thread`        | thread?   | The thread that created the connection. Nil when `ForeignState` is true.       |

| Method                | Description                                                                                                                          |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `Fire(...: any): ()`  | Fires this connection with the provided arguments.                                                                                   |
| `Defer(...: any): ()` | [Defers](https://devforum.roblox.com/t/beta-deferred-lua-event-handling/1240569) an event to connection with the provided arguments. |
| `Disconnect(): ()`    | Disconnects the connection.                                                                                                          |
| `Disable(): ()`       | Prevents the connection from firing.                                                                                                 |
| `Enable(): ()`        | Allows the connection to fire if it was previously disabled.                                                                         |

***

## getconnection

```lua
<table<ConnectionObject>> getconnection(<RBXScriptSignal> signal, <number> index)
```

Returns a Connection object for `index` .

***

## firesignal

```lua
<nil> firesignal(<RBXScriptSignal> signal, ...)
```

Fires all Lua connections of `signal` .

***

## getcustomasset

```lua
<string> getcustomasset(<string> path)
```

Returns a `rbxasset://` content id for the asset located at `path`, allowing you to use unmoderated assets. Internally, files are copied to the game's content directory.

***

## gethiddenproperty

```lua
<any, boolean> gethiddenproperty(<Instance> object, <string> property)
```

Returns the value of a hidden property of `object`, which cannot be indexed normally.

If the property is hidden, the second return value will be `true`. Otherwise, it will be `false`.

```lua
local fire = Instance.new("Fire")
print(gethiddenproperty(fire, "size_xml")) --> 5, true
print(gethiddenproperty(fire, "Size")) --> 5, false
```

***

## setsimulationradius

```lua
<nil> setsimulationradius(<number> simulationRadius, <number?> maxSimulationRadius)  
```

Sets the player's simulationRadius. If `maxSimulationRadius` is specified, it will set that as well.

***

## gethui

```lua
<Folder> gethui()
```

Returns a hidden GUI container. Should be used as an alternative to CoreGui and PlayerGui.

GUI objects parented to this container will be protected from common detection methods.

***

## getinstances

```lua
<table<Instance>> getinstances()
```

Returns a list of every Instance referenced on the client.

***

## getnilinstances

```lua
<table<Instance>> getnilinstances()
```

Like `getinstances`, but only includes Instances that are not descendants of a service provider.

***

## isscriptable

```lua
<boolean> isscriptable(<Instance> object, <string> property)
```

Returns whether the given property is scriptable (does not have the `notscriptable` tag).

If `true`, the property is scriptable and can be indexed normally. If `nil`, the property does not exist.

***

## sethiddenproperty

```lua
<boolean> sethiddenproperty(<Instance> object, <string> property, <any> value)
```

Sets the value of a hidden property of `object`, which cannot be set normally. Returns whether the property was hidden.

```lua
local fire = Instance.new("Fire")
print(sethiddenproperty(fire, "Size", 5)) --> false (not hidden)
print(sethiddenproperty(fire, "size_xml", 15)) --> true (hidden)
print(gethiddenproperty(fire, "size_xml")) --> 15, true (hidden)
```

***

## setrbxclipboard

```lua
<boolean> setrbxclipboard(<string> data)
```

Sets the Studio client's clipboard to the given `rbxm` or `rbxmx` model data. This allows data from the game to be copied into a Studio client.

```lua
local data = readfile("model.rbxm")
setrbxclipboard(data) -- Can be pasted into Studio
```

***

## setscriptable

```lua
<boolean> setscriptable(<Instance> object, <string> property, <boolean> value)
```

Set whether the given property is scriptable. Returns whether the property was scriptable prior to changing it.

***

## getrendersteppedlist

```lua
<table> getrendersteppedlist()
```

Returns all callbacks bound with `RunService.BindToRenderStep` .

***

## replicatesignal

```lua
<nil> replicatesignal(<RBXScriptSignal> signal, ...)
```

Replicates `signal` on the server.

&#x20;If `signal` has one or multiple arguments, they must be provided in the call.

```lua
replicatesignal(game.Players.LocalPlayer.Kill) --> Kills you

local sword = game.Players.LocalPlayer.Character.ClassicSword
replicatesignal(sword.Activated) --> Swings the sword
```

***

# Metatable

## getrawmetatable

```lua
<table> getrawmetatable(<table> object)
```

Returns the metatable of `object`, where the `__metatable` field would normally lock the metatable.

***

## hookmetamethod

```lua
<function> hookmetamethod(<table> object, <string> method, <function> hook)
```

Replaces `func` with `hook` internally, where `hook` will be invoked in place of `func` when called.

Returns a new function that can be used to access the original definition of `func`.

***

## getnamecallmethod

```lua
<string> getnamecallmethod()
```

Returns the name of the method that invoked the `__namecall` metamethod.

***

## setnamecallmethod

```lua
<nil> setnamecallmethod(<string> method)
```

Changes the name of the method that invoked `__namecall` metamethod.

***

## isreadonly

```lua
<boolean> isreadonly(<table> object)
```

Returns whether `object` is read-only or not.

***

## setrawmetatable

```lua
<nil> setrawmetatable(<table> object, <table> metatable)
```

Sets the metatable of `object` to `metatable`, where the `__metatable` field would normally lock the metatable.

***

## setreadonly

```lua
<nil> setreadonly(<table> object, <boolean> readonly)
```

Sets whether `object` is read-only or not.

***

## makewriteable

```lua
<nil> makewriteable(<table> object)
```

Unfreezes `object` .

***

## makereadonly

```lua
<nil> makereadonly(<table> object)
```

Freezes `object` , where table.freeze would normally check for \_\_metatable.

***

# Miscellaneous

## identifyexecutor

```lua
<string, string> identifyexecutor()
```

Returns the name and version of Potassium.

***

## lz4compress

```lua
<string> lz4compress(<string> data)
```

Compresses `data` using LZ4 compression.

***

## lz4decompress

```lua
<string> lz4compress(<string> data, <number> size)
```

Decompresses `data` using LZ4 compression, with the decompressed size specified by `size`.

***

## messagebox

```lua
<number> messagebox(<string> text, <string> caption, <number> flags)
```

Creates a message box with the specified text, caption, and flags. Yields until the message box is closed, and returns the user input code.

***

***

## queue\_on\_teleport

```lua
<nil> queue_on_teleport(<string> code)
```

Queues the specified script to be executed after the player teleports to a different place.

***

## request

```lua
<HttpResponse> request(<HttpRequest> options)
```

Sends an HTTP request using the specified options. Yields until the request is complete, and returns the response.

| Field   | Type    | Description              |
| ------- | ------- | ------------------------ |
| Url     | string  | The URL for the request. |
| Method  | string  | The HTTP method to use.  |
| Body    | string? | The body of the request. |
| Headers | table?  | A table of headers.      |
| Cookies | table?  | A table of cookies.      |

***

## getinternalparent

```lua
<Instance> getinternalparent(<Instance> instance)
```

Returns the internal parent field of the `instance`.

***

## getfflag

```lua
<any> getfflag(<string> fflag)
```

Returns the value of `fflag`

***

## setfflag

```lua
<nil> setfflag(<string> fflag, <any> value)
```

Sets the value of `fflag` to `value`

***

## setinternalparent

<pre class="language-lua"><code class="lang-lua"><strong>&#x3C;nil> setinternalparent(&#x3C;Instance> instance, &#x3C;Instance> newparent)
</strong></code></pre>

Sets the internal parent field of `instance` to `newparent`

***

## setclipboard

```lua
<nil> setclipboard(<string> text)
```

Copies `text` to the clipboard.

***

## setfpscap

```lua
<nil> setfpscap(<number> fps)
```

Sets the in-game FPS cap to `fps`. If `fps` is 0, the FPS cap is disabled.

***

# Scripts

## getgc

```lua
<table<function | userdata | table>> getgc(<boolean?> includetables)
```

Returns a list of objects in the Luau garbage collector.

If `includeTables` is false, tables will not be included in the list.

***

## getgenv

```lua
<table<[string]: any>> getgenv()
```

Returns the custom global environment of the executor.

***

## gettenv

```lua
<table<[string]: any> gettenv(<thread> thread)
```

Returns the environment of `thread`.

***

## getreg

```lua
<table<function | thread>> getreg()
```

Returns the lua registry.

***

## getloadedmodules

```lua
<table<ModuleScript>> getloadedmodules()
```

Returns a list of ModuleScripts that have been loaded.

***

## getrenv

```lua
<table<[string]: any>> getrenv()
```

Returns the global environment of the game client. It can be used to access the global functions that LocalScripts and ModuleScripts use.

***

## getrunningscripts

```lua
<table<LocalScript | ModuleScript>> getrunningscripts()
```

Returns a list of scripts that are currently running.

***

## getscriptbytecode

```lua
<string> getscriptbytecode(<LocalScript | ModuleScript> script)
```

Returns the raw Luau bytecode of the given script.

***

## getscriptclosure

```lua
<function> getscriptclosure(<LocalScript | ModuleScript> script)
```

Generates a new closure using the bytecode of `script`.

***

## getscripthash

```lua
<string> getscripthash(<LocalScript | ModuleScript> script)
```

Returns a SHA384 hash of the script's bytecode.

***

## getscripts

```lua
<table<LocalScript | ModuleScript>> getscripts()
```

Returns a list of every script in the game.

***

## getsenv

```lua
<table<[string]: any>> getsenv(<LocalScript | ModuleScript> script)
```

Returns the global environment of the given script. It can be used to access variables and functions that are not defined as local.

***

## getthreadidentity

```lua
<number> getthreadidentity()
```

Returns the identity of the current thread.

***

## setthreadidentity

```lua
<nil> setthreadidentity(<number> identity)
```

Sets the current thread identity.

***

# Web Sockets

## WebSocket.connect

```lua
<WebSocketConnection> WebSocket.connect(<string> url)
```

Establishes a WebSocket connection to the specified URL.

```lua
local ws = WebSocket.connect("ws://localhost:8080")

ws.OnMessage:Connect(function(message)
	print(message)
end)

ws.OnClose:Connect(function()
	print("Closed")
end)

ws:Send("Hello, World!")
```

***

## WebSocketConnection

```lua
ws = WebSocket.connect(url)
```

### Methods

<table><thead><tr><th>Method</th><th>Description</th></tr></thead><tbody><tr><td><pre class="language-lua"><code class="lang-lua">Send(&#x3C;string> message)
</code></pre></td><td>Sends a message over the WebSocket connection</td></tr><tr><td><pre class="language-lua"><code class="lang-lua">Close()
</code></pre></td><td>Closes the WebSocket connection</td></tr></tbody></table>

### Events

<table><thead><tr><th>Event</th><th>Description</th></tr></thead><tbody><tr><td><pre class="language-lua"><code class="lang-lua">OnMessage(&#x3C;string> message)
</code></pre></td><td>Fired when a message is received over the WebSocket connection</td></tr><tr><td><pre class="language-lua"><code class="lang-lua">OnClose()
</code></pre></td><td>Fired when the WebSocket connection is closed</td></tr></tbody></table>

***

# Actor

## create\_comm\_channel

```lua
<number, BindableEvent> create_comm_channel()
```

Returns the channel and the associated ID.

***

## get\_comm\_channel

```lua
<BindableEvent> get_comm_channel(<number> id)
```

Returns the communication channel if it exists.

***

## run\_on\_actor

```lua
<nil> run_on_actor(<Actor> actor, <string> script, ...)
```

Runs a script on an actor thread.

```lua
run_on_actor(getactors()[1], [[
    print("Hello, world!")
]])
```

***

## getactors

```lua
<table<Actor>> getactors()
```

Returns a table of all actors that exist within the game.

***

## is\_parallel

```lua
<boolean> is_parallel()
```

Returns if the thread is running on an actor.

***

## run\_on\_thread

```lua
<nil> run_on_thread(<thread> thread, <string> script, ...)
```

Runs a script on a specified thread, actor threads only.

```lua
run_on_thread(getactorthreads()[1], [[
    print("Hello, world!")
]])
```

***

## getactorthreads

```lua
<table<thread>> getactorthreads()
```

Returns all threads that belong to actors in a table.

***

