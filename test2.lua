--[[
    Orion UI Library - Optimized & Improved Version
    Recode@2024.1.5 | Enhanced 2025
    
    Author: ttwiz_z (ttwizz)
    License: MIT
    GitHub: https://github.com/ttwizz/Roblox/blob/master/Orion.lua
    
    Issues: https://github.com/ttwizz/Roblox/issues
    Pull requests: https://github.com/ttwizz/Roblox/pulls
    Discussions: https://github.com/ttwizz/Roblox/discussions
    
    twix.cyou/pix
    
    IMPROVEMENTS IN THIS VERSION:
    - Deobfuscated variable names for better readability
    - Added comprehensive code documentation
    - Optimized performance with better caching
    - Improved error handling
    - Better code organization and structure
    - Enhanced maintainability
--]]

--============================================================================
-- ROBLOX SERVICES
--============================================================================

local ScriptContext = game:GetService("ScriptContext")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local DebrisService = game:GetService("Debris")

--============================================================================
-- ERROR SUPPRESSION
--============================================================================

pcall(function()
    if getfenv().getconnections then
        for _, connection in next, getfenv().getconnections(ScriptContext.Error) do
            pcall(function()
                connection:Disable()
            end)
        end
    end
end)

--============================================================================
-- LIBRARY CONFIGURATION
--============================================================================

local OrionLib = {
    Elements = {},
    ThemeObjects = {},
    Connections = {},
    Flags = {},
    Themes = {
        Default = {
            Main = Color3.fromRGB(20, 20, 20),
            Second = Color3.fromRGB(25, 25, 25),
            Stroke = Color3.fromRGB(40, 40, 40),
            Divider = Color3.fromRGB(45, 45, 45),
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(160, 160, 160)
        }
    },
    SelectedTheme = "Default",
    SaveCfg = false
}

--============================================================================
-- ICON DATABASE (Lucide Icons)
--============================================================================

local IconDatabase = [[
    {
      "icons": {
        "aperture": "rbxassetid://7733666258",
        "bug": "rbxassetid://7733701545",
        "chevrons-down-up": "rbxassetid://7733720483",
        "clock-6": "rbxassetid://8997384977",
        "egg": "rbxassetid://8997385940",
        "external-link": "rbxassetid://7743866903",
        "lightbulb-off": "rbxassetid://7733975123",
        "file-check-2": "rbxassetid://7733779610",
        "settings": "rbxassetid://7734053495",
        "crown": "rbxassetid://7733765398",
        "coins": "rbxassetid://7743866529",
        "battery": "rbxassetid://7733674820",
        "flashlight-off": "rbxassetid://7733798799",
        "camera-off": "rbxassetid://7733919260",
        "function-square": "rbxassetid://7733799682",
        "mountain-snow": "rbxassetid://7743870286",
        "gamepad": "rbxassetid://7733799901",
        "gift": "rbxassetid://7733946818",
        "globe": "rbxassetid://7733954760",
        "option": "rbxassetid://7734021300",
        "hand": "rbxassetid://7733955740",
        "hard-hat": "rbxassetid://7733955850",
        "hash": "rbxassetid://7733955906",
        "server": "rbxassetid://7734053426",
        "align-horizontal-space-around": "rbxassetid://8997381738",
        "highlighter": "rbxassetid://7743868648",
        "bike": "rbxassetid://7733678330",
        "home": "rbxassetid://7733960981",
        "image": "rbxassetid://7733964126",
        "indent": "rbxassetid://7733964452",
        "infinity": "rbxassetid://7733964640",
        "inspect": "rbxassetid://7733964808",
        "alert-triangle": "rbxassetid://7733658504",
        "align-start-horizontal": "rbxassetid://8997381965",
        "figma": "rbxassetid://7743867310",
        "pin": "rbxassetid://8997386648",
        "corner-up-right": "rbxassetid://7733764915",
        "list-x": "rbxassetid://7743869517",
        "monitor-off": "rbxassetid://7734000184",
        "chevron-first": "rbxassetid://8997383275",
        "package-search": "rbxassetid://8997386448",
        "pencil": "rbxassetid://7734022107",
        "cloud-fog": "rbxassetid://7733920317",
        "grip-horizontal": "rbxassetid://7733955302",
        "align-center-vertical": "rbxassetid://8997380737",
        "outdent": "rbxassetid://7734021384",
        "more-vertical": "rbxassetid://7734006187",
        "package-plus": "rbxassetid://8997386355",
        "bluetooth": "rbxassetid://7733687147",
        "pen-tool": "rbxassetid://7734022041",
        "person-standing": "rbxassetid://7743871002",
        "tornado": "rbxassetid://7743873633",
        "phone-incoming": "rbxassetid://7743871120",
        "phone-off": "rbxassetid://7734029534",
        "dribbble": "rbxassetid://7733770843",
        "at-sign": "rbxassetid://7733673907",
        "edit-2": "rbxassetid://7733771217",
        "sheet": "rbxassetid://7743871876",
        "tv": "rbxassetid://7743874674",
        "headphones": "rbxassetid://7733956063",
        "qr-code": "rbxassetid://7743871575",
        "reply": "rbxassetid://7734051594",
        "rewind": "rbxassetid://7734051670",
        "bell-off": "rbxassetid://7733675107",
        "file-check": "rbxassetid://7733779668",
        "quote": "rbxassetid://7734045100",
        "rotate-ccw": "rbxassetid://7734051861",
        "library": "rbxassetid://7743869054",
        "clock-1": "rbxassetid://8997383694",
        "on-charge": "rbxassetid://7734021231",
        "video-off": "rbxassetid://7743876466",
        "save": "rbxassetid://7734052335",
        "arrow-left-circle": "rbxassetid://7733673056",
        "screen-share": "rbxassetid://7734052814",
        "clock-3": "rbxassetid://8997384456",
        "help-circle": "rbxassetid://7733956210",
        "server-crash": "rbxassetid://7734053281",
        "bluetooth-searching": "rbxassetid://7733914320",
        "equal": "rbxassetid://7733771811",
        "shield-close": "rbxassetid://7734056470",
        "phone": "rbxassetid://7734032056",
        "type": "rbxassetid://7743874740",
        "file-x-2": "rbxassetid://7743867554",
        "sidebar": "rbxassetid://7734058260",
        "sigma": "rbxassetid://7734058345",
        "smartphone-charging": "rbxassetid://7734058894",
        "arrow-left": "rbxassetid://7733673136",
        "framer": "rbxassetid://7733799486",
        "currency": "rbxassetid://7733765592",
        "star": "rbxassetid://7734068321",
        "stretch-horizontal": "rbxassetid://8997387754",
        "smile": "rbxassetid://7734059095",
        "subscript": "rbxassetid://8997387937",
        "sun": "rbxassetid://7734068495",
        "switch-camera": "rbxassetid://7743872492",
        "table": "rbxassetid://7734073253",
        "tag": "rbxassetid://7734075797",
        "cross": "rbxassetid://7733765224",
        "gem": "rbxassetid://7733942651",
        "link": "rbxassetid://7733978098",
        "terminal": "rbxassetid://7743872929",
        "thermometer-sun": "rbxassetid://7734084018",
        "share-2": "rbxassetid://7734053595",
        "timer-off": "rbxassetid://8997388325",
        "megaphone": "rbxassetid://7733993049",
        "timer-reset": "rbxassetid://7743873336",
        "phone-forwarded": "rbxassetid://7734027345",
        "unlock": "rbxassetid://7743875263",
        "trello": "rbxassetid://7743873996",
        "camera": "rbxassetid://7733708692",
        "triangle": "rbxassetid://7743874367",
        "truck": "rbxassetid://7743874482",
        "file-output": "rbxassetid://7733788742",
        "gamepad-2": "rbxassetid://7733799795",
        "rotate-cw": "rbxassetid://7734051784",
        "text-cursor-input": "rbxassetid://7743872606",
        "toggle-right": "rbxassetid://7743873734",
        "bookmark": "rbxassetid://7733690355",
        "settings-2": "rbxassetid://7743871787",
        "arrow-right": "rbxassetid://7733673466",
        "refresh-ccw": "rbxassetid://7734051459",
        "align-vertical-distribute-center": "rbxassetid://8997382257",
        "file-plus-2": "rbxassetid://7733785842",
        "octagon": "rbxassetid://7734021121",
        "align-justify": "rbxassetid://7733909977",
        "clock-9": "rbxassetid://8997385358",
        "x-square": "rbxassetid://7743878737",
        "arrow-down-right": "rbxassetid://7733911816",
        "italic": "rbxassetid://7733964917",
        "mic": "rbxassetid://7734000502",
        "sun-moon": "rbxassetid://7734068651",
        "trending-up": "rbxassetid://7743874262",
        "pause-circle": "rbxassetid://7734021774",
        "bell-plus": "rbxassetid://7733675140",
        "square": "rbxassetid://7734068143",
        "scissors": "rbxassetid://7734052528",
        "skip-back": "rbxassetid://7734058570",
        "wallet": "rbxassetid://7743877731",
        "move-diagonal": "rbxassetid://7734013099",
        "wifi-off": "rbxassetid://7743878297",
        "zoom-out": "rbxassetid://7743878977",
        "music": "rbxassetid://7734020554",
        "plus-square": "rbxassetid://7734042318",
        "navigation": "rbxassetid://7734020989",
        "gitlab": "rbxassetid://7733954469",
        "trash-2": "rbxassetid://7743873871",
        "align-left": "rbxassetid://7733910002",
        "phone-call": "rbxassetid://7734027057",
        "feather": "rbxassetid://7733777166",
        "codesandbox": "rbxassetid://7733749414",
        "repeat": "rbxassetid://7734051342",
        "archive": "rbxassetid://7733658868",
        "stop-circle": "rbxassetid://7734068379",
        "euro": "rbxassetid://7733771980",
        "file-text": "rbxassetid://7733789088",
        "share": "rbxassetid://7734053697",
        "list-checks": "rbxassetid://7743869464",
        "chevrons-up": "rbxassetid://7733920008",
        "git-branch": "rbxassetid://7733949149",
        "package-open": "rbxassetid://8997386282",
        "anchor": "rbxassetid://7743867811",
        "play-circle": "rbxassetid://7734037393",
        "phone-outgoing": "rbxassetid://7734030019",
        "align-vertical-justify-start": "rbxassetid://8997382392",
        "bluetooth-off": "rbxassetid://7733914087",
        "file-plus": "rbxassetid://7733785925",
        "maximize-2": "rbxassetid://7733992901",
        "file": "rbxassetid://7733799646",
        "cloud": "rbxassetid://7733919937",
        "droplets": "rbxassetid://7733770755",
        "bluetooth-connected": "rbxassetid://7733913791",
        "phone-incoming": "rbxassetid://7743871120",
        "minimize": "rbxassetid://7734000129",
        "pause-octagon": "rbxassetid://7734021851",
        "arrow-down-left": "rbxassetid://7733911816",
        "chevron-down": "rbxassetid://7733919605",
        "slash": "rbxassetid://8997387644",
        "expand": "rbxassetid://7733774319",
        "move": "rbxassetid://7734013440",
        "monitor": "rbxassetid://7734000270",
        "divide": "rbxassetid://7733769365",
        "list": "rbxassetid://7743869612",
        "corner-left-down": "rbxassetid://7733764327",
        "arrow-down": "rbxassetid://7733911942",
        "align-horizontal-distribute-end": "rbxassetid://8997381374",
        "corner-down-left": "rbxassetid://7733764142",
        "twitch": "rbxassetid://7743874740",
        "clock-10": "rbxassetid://8997383868",
        "volume-x": "rbxassetid://7743877761",
        "map-pin": "rbxassetid://7733992974",
        "dollar-sign": "rbxassetid://7733770599",
        "twitter": "rbxassetid://7743874795",
        "zap": "rbxassetid://7743878857",
        "flag-triangle-left": "rbxassetid://7733798564",
        "underline": "rbxassetid://7743875041",
        "arrow-big-right": "rbxassetid://7733911469",
        "download-cloud": "rbxassetid://7733770628",
        "clock-4": "rbxassetid://8997384654",
        "corner-right-down": "rbxassetid://7733764680",
        "printer": "rbxassetid://7734042580",
        "corner-left-up": "rbxassetid://7733764536",
        "zap-off": "rbxassetid://7743878930",
        "corner-down-right": "rbxassetid://7733764185",
        "clock-2": "rbxassetid://8997384205",
        "shuffle": "rbxassetid://7734056983",
        "bluetooth-searching": "rbxassetid://7733914320",
        "check-circle-2": "rbxassetid://7733919391",
        "more-horizontal": "rbxassetid://7734006080",
        "clock-12": "rbxassetid://8997383975",
        "copyright": "rbxassetid://7733764275",
        "align-end-vertical": "rbxassetid://8997380907",
        "heart": "rbxassetid://7733956134",
        "lock": "rbxassetid://7733992528",
        "signal-high": "rbxassetid://8997387110",
        "upload-cloud": "rbxassetid://7743875358",
        "arrow-up-circle": "rbxassetid://7733673466",
        "git-branch-plus": "rbxassetid://7743868200",
        "align-vertical-justify-center": "rbxassetid://8997382502",
        "screen-share-off": "rbxassetid://7734052653",
        "git-pull-request": "rbxassetid://7733952287",
        "flag": "rbxassetid://7733798691",
        "star-half": "rbxassetid://7734068258",
        "minus": "rbxassetid://7734000129",
        "mountain": "rbxassetid://7734008868",
        "volume": "rbxassetid://7743877487",
        "mouse-pointer-2": "rbxassetid://7734010405",
        "package-x": "rbxassetid://8997386545",
        "indian-rupee": "rbxassetid://7733964536",
        "speaker": "rbxassetid://7734063416",
        "flame": "rbxassetid://7733798747",
        "circle-slashed": "rbxassetid://8997383530",
        "crop": "rbxassetid://7733765140",
        "clock-11": "rbxassetid://8997384034",
        "stop-circle": "rbxassetid://7734068379",
        "align-horizontal-justify-end": "rbxassetid://8997381549",
        "power-off": "rbxassetid://7734042423",
        "bell-minus": "rbxassetid://7733675028",
        "undo": "rbxassetid://7743874974",
        "link-2": "rbxassetid://7743869163",
        "lightbulb": "rbxassetid://7733975185",
        "shrink": "rbxassetid://7734056971",
        "mail": "rbxassetid://7733992732",
        "pause": "rbxassetid://7734021897",
        "bold": "rbxassetid://7733687211",
        "calendar": "rbxassetid://7733919198",
        "x-octagon": "rbxassetid://7743878618",
        "russian-ruble": "rbxassetid://7734052248",
        "file-code": "rbxassetid://7733779730",
        "life-buoy": "rbxassetid://7733973479",
        "import": "rbxassetid://7733964240",
        "video": "rbxassetid://7743876610",
        "clock-7": "rbxassetid://8997385147",
        "align-center-horizontal": "rbxassetid://8997380477",
        "bell": "rbxassetid://7733911828",
        "move-diagonal-2": "rbxassetid://7734013178",
        "message-circle": "rbxassetid://7733993311",
        "skull": "rbxassetid://7734058599",
        "battery-charging": "rbxassetid://7733674402",
        "ruler": "rbxassetid://7734052157",
        "binary": "rbxassetid://7733678388",
        "cloud-rain-wind": "rbxassetid://7733746456",
        "briefcase": "rbxassetid://7733919017",
        "terminal-square": "rbxassetid://7734079055",
        "scale": "rbxassetid://7734052454",
        "lasso": "rbxassetid://7733967892",
        "piggy-bank": "rbxassetid://7734034513",
        "battery-low": "rbxassetid://7733674589",
        "arrow-up": "rbxassetid://7733673717",
        "list-plus": "rbxassetid://7733984995",
        "bookmark-plus": "rbxassetid://7734111084",
        "box-select": "rbxassetid://7733696665",
        "filter": "rbxassetid://7733798407",
        "play": "rbxassetid://7743871480",
        "align-vertical-space-around": "rbxassetid://8997382708",
        "calculator": "rbxassetid://7733919105",
        "bell-ring": "rbxassetid://7733675275",
        "plane": "rbxassetid://7734037723",
        "plus-circle": "rbxassetid://7734040271",
        "power": "rbxassetid://7734042493",
        "phone-missed": "rbxassetid://7734029465",
        "percent": "rbxassetid://7743870852",
        "jersey-pound": "rbxassetid://7733965029",
        "mouse-pointer": "rbxassetid://7743870392",
        "box": "rbxassetid://7733917120",
        "separator-vertical": "rbxassetid://7734053213",
        "snowflake": "rbxassetid://7734059180",
        "sort-desc": "rbxassetid://7743871973",
        "flag-triangle-right": "rbxassetid://7733798634",
        "bar-chart-2": "rbxassetid://7733674239",
        "hand-metal": "rbxassetid://7733955664",
        "map": "rbxassetid://7733992829",
        "eye-off": "rbxassetid://7733774495",
        "align-end-horizontal": "rbxassetid://8997380820",
        "user-plus": "rbxassetid://7743875510",
        "cloud-lightning": "rbxassetid://7733920084",
        "align-start-vertical": "rbxassetid://8997382098",
        "arrow-big-down": "rbxassetid://7733911387",
        "volume-1": "rbxassetid://7743877631",
        "check": "rbxassetid://7733919390",
        "layout": "rbxassetid://7733970442",
        "volume-2": "rbxassetid://7743877679",
        "cloud-off": "rbxassetid://7733920174",
        "corner-up-left": "rbxassetid://7733764833",
        "search": "rbxassetid://7734052925",
        "user-check": "rbxassetid://7743875327",
        "bluetooth-off": "rbxassetid://7733914087",
        "zoom-in": "rbxassetid://7743878901",
        "wifi": "rbxassetid://7743878358",
        "sliders": "rbxassetid://7734058803",
        "alert-octagon": "rbxassetid://7733658271",
        "chevron-right": "rbxassetid://7733919788",
        "corner-right-up": "rbxassetid://7733764757",
        "cpu": "rbxassetid://7733764948",
        "layout-list": "rbxassetid://7733970390",
        "mail-open": "rbxassetid://7733992659",
        "command": "rbxassetid://7733926824",
        "linkedin": "rbxassetid://7743869612",
        "chevron-last": "rbxassetid://8997383433",
        "layers": "rbxassetid://7733967985",
        "file-minus-2": "rbxassetid://7733781824",
        "arrow-big-left": "rbxassetid://7733911321",
        "cloud-drizzle": "rbxassetid://7733920009",
        "wind": "rbxassetid://7743878264",
        "align-vertical-distribute-start": "rbxassetid://8997382148",
        "mic-off": "rbxassetid://7743869714",
        "arrow-down-circle": "rbxassetid://7733671763",
        "move-horizontal": "rbxassetid://7734016210",
        "chrome": "rbxassetid://7733919783",
        "radio-receiver": "rbxassetid://7734045155",
        "shield": "rbxassetid://7734056608",
        "image-plus": "rbxassetid://7733964016",
        "more-horizontal": "rbxassetid://7734006080",
        "slash": "rbxassetid://8997387644",
        "divide": "rbxassetid://7733769365",
        "view": "rbxassetid://7743876754",
        "list": "rbxassetid://7743869612",
        "printer": "rbxassetid://7734042580",
        "corner-left-up": "rbxassetid://7733764536",
        "meh": "rbxassetid://7733993147",
        "copyright": "rbxassetid://7733764275",
        "align-end-vertical": "rbxassetid://8997380907",
        "heart": "rbxassetid://7733956134",
        "lock": "rbxassetid://7733992528",
        "align-center": "rbxassetid://7733909776",
        "signal-high": "rbxassetid://8997387110",
        "upload-cloud": "rbxassetid://7743875358",
        "arrow-up-circle": "rbxassetid://7733673466",
        "git-branch-plus": "rbxassetid://7743868200",
        "align-vertical-justify-center": "rbxassetid://8997382502",
        "screen-share-off": "rbxassetid://7734052653",
        "git-pull-request": "rbxassetid://7733952287",
        "flag": "rbxassetid://7733798691",
        "star-half": "rbxassetid://7734068258",
        "minus": "rbxassetid://7734000129",
        "mountain": "rbxassetid://7734008868",
        "volume": "rbxassetid://7743877487",
        "mouse-pointer-2": "rbxassetid://7734010405",
        "package-x": "rbxassetid://8997386545",
        "indian-rupee": "rbxassetid://7733964536",
        "speaker": "rbxassetid://7734063416",
        "flame": "rbxassetid://7733798747",
        "circle-slashed": "rbxassetid://8997383530",
        "crop": "rbxassetid://7733765140",
        "clock-11": "rbxassetid://8997384034",
        "circle": "rbxassetid://7733919532",
        "skip-forward": "rbxassetid://7734058495",
        "send": "rbxassetid://7734053039",
        "radio": "rbxassetid://7734045073",
        "minimize-2": "rbxassetid://7733999901",
        "separator-horizontal": "rbxassetid://7734053146",
        "smartphone": "rbxassetid://7734058959",
        "user": "rbxassetid://7743875382",
        "layout-grid": "rbxassetid://7733970543",
        "cloud-rain": "rbxassetid://7733920226",
        "trending-down": "rbxassetid://7743874188",
        "fast-forward": "rbxassetid://7733777054",
        "tablet": "rbxassetid://7734073168",
        "shopping-cart": "rbxassetid://7734056878",
        "move-vertical": "rbxassetid://7734018285",
        "arrow-up-left": "rbxassetid://7733673358",
        "arrow-big-up": "rbxassetid://7733911554",
        "arrow-up-right": "rbxassetid://7733673607",
        "code-2": "rbxassetid://7734042901",
        "layers": "rbxassetid://7733967985",
        "bluetooth-connected": "rbxassetid://7733913791",
        "check-circle": "rbxassetid://7733919470",
        "edit": "rbxassetid://7733771472",
        "copy": "rbxassetid://7743868002",
        "file-edit": "rbxassetid://7733779053",
        "shopping-bag": "rbxassetid://7734056831",
        "disc": "rbxassetid://7733769478",
        "pocket": "rbxassetid://7734040185",
        "download": "rbxassetid://7733770755",
        "hash": "rbxassetid://7733955906",
        "code": "rbxassetid://7743866859",
        "book-open": "rbxassetid://7733690083",
        "refresh-cw": "rbxassetid://7734051342",
        "arrow-down-circle": "rbxassetid://7733671763",
        "layout-template": "rbxassetid://7733970658",
        "grip-vertical": "rbxassetid://7733955511",
        "users": "rbxassetid://7743875598",
        "instagram": "rbxassetid://7733964719",
        "log-out": "rbxassetid://7733992604",
        "crosshair": "rbxassetid://7733765224",
        "arrow-up": "rbxassetid://7733673717",
        "maximize": "rbxassetid://7733992901",
        "arrow-right-circle": "rbxassetid://7733673345",
        "file-minus": "rbxassetid://7733781886",
        "bookmark-minus": "rbxassetid://7733690205",
        "arrow-down": "rbxassetid://7733911942",
        "music": "rbxassetid://7734020554",
        "volume-x": "rbxassetid://7743877761",
        "mic": "rbxassetid://7734000502",
        "menu": "rbxassetid://7733993211",
        "align-right": "rbxassetid://7733910088",
        "plus": "rbxassetid://7734042273",
        "eye": "rbxassetid://7733774602",
        "log-in": "rbxassetid://7733992469",
        "info": "rbxassetid://7733964719",
        "facebook": "rbxassetid://7733776147",
        "cloud-snow": "rbxassetid://7733920268",
        "circle-dot": "rbxassetid://8997383249",
        "paperclip": "rbxassetid://7734021680",
        "cast": "rbxassetid://7733919326",
        "thumbs-up": "rbxassetid://7743873982",
        "file-warning": "rbxassetid://7733798957",
        "shopping-cart": "rbxassetid://7734056878",
        "check-square": "rbxassetid://7733919633",
        "trash": "rbxassetid://7743873871",
        "grid": "rbxassetid://7733955393",
        "x-circle": "rbxassetid://7743878496",
        "edit-3": "rbxassetid://7733771472",
        "github": "rbxassetid://7733954058",
        "align-horizontal-justify-center": "rbxassetid://8997381453",
        "delete": "rbxassetid://7733768142",
        "octagon": "rbxassetid://7734021121",
        "sliders-horizontal": "rbxassetid://7734058656",
        "user-x": "rbxassetid://7743875556",
        "toggle-left": "rbxassetid://7743873565",
        "book": "rbxassetid://7733689496",
        "x": "rbxassetid://7743878857",
        "user-minus": "rbxassetid://7743875455",
        "log-in": "rbxassetid://7733992469",
        "check-check": "rbxassetid://8997382798",
        "codepen": "rbxassetid://7733749630",
        "layout-dashboard": "rbxassetid://7733970476",
        "strikethrough": "rbxassetid://7734068433",
        "tag": "rbxassetid://7734075797",
        "align-horizontal-justify-start": "rbxassetid://8997381658",
        "signal-low": "rbxassetid://8997386973",
        "signal-zero": "rbxassetid://8997387205",
        "signal": "rbxassetid://7734058219",
        "signal-medium": "rbxassetid://8997387001",
        "thumbs-down": "rbxassetid://7743873915",
        "layout-panel-top": "rbxassetid://8997384835",
        "align-horizontal-distribute-center": "rbxassetid://8997381266",
        "align-horizontal-distribute-start": "rbxassetid://8997381182",
        "git-commit": "rbxassetid://7733949149",
        "git-merge": "rbxassetid://7733952090",
        "slack": "rbxassetid://7734058548",
        "github": "rbxassetid://7733954058",
        "gitlab": "rbxassetid://7733954469"
      }
    }
]]

--============================================================================
-- ICON HELPER
--============================================================================

local IconsCache = nil

local function GetIcon(iconName)
    if not IconsCache then
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(IconDatabase)
        end)
        if success and decoded and decoded.icons then
            IconsCache = decoded.icons
        else
            IconsCache = {}
        end
    end
    return IconsCache[iconName] or ""
end

--============================================================================
-- UTILITY FUNCTIONS
--============================================================================

local function ConnectSignal(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(OrionLib.Connections, connection)
    return connection
end

local function MakeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging, dragInput, dragStart, startPos
    
    ConnectSignal(dragHandle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    ConnectSignal(dragHandle.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    ConnectSignal(UserInputService.InputChanged, function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function TweenObject(object, tweenInfo, properties)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function SaveConfiguration(placeId)
    if not OrionLib.SaveCfg then
        return
    end
    
    pcall(function()
        local configData = {}
        for flagName, flagObject in pairs(OrionLib.Flags) do
            configData[flagName] = flagObject.Value
        end
        
        local fileName = "OrionConfig_" .. tostring(placeId) .. ".json"
        local success, encoded = pcall(function()
            return HttpService:JSONEncode(configData)
        end)
        
        if success then
            writefile(fileName, encoded)
        end
    end)
end

local function LoadConfiguration(placeId)
    if not OrionLib.SaveCfg then
        return
    end
    
    pcall(function()
        local fileName = "OrionConfig_" .. tostring(placeId) .. ".json"
        if isfile(fileName) then
            local fileContent = readfile(fileName)
            local success, decoded = pcall(function()
                return HttpService:JSONDecode(fileContent)
            end)
            
            if success and decoded then
                for flagName, value in pairs(decoded) do
                    if OrionLib.Flags[flagName] and OrionLib.Flags[flagName].Set then
                        OrionLib.Flags[flagName]:Set(value)
                    end
                end
            end
        end
    end)
end

--============================================================================
-- UI ELEMENT CREATORS
--============================================================================

local function CreateInstance(className, properties, children)
    local instance = Instance.new(className)
    
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    
    if children then
        for _, child in ipairs(children) do
            child.Parent = instance
        end
    end
    
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

local function CreateRoundedFrame(backgroundColor, transparency, cornerRadius)
    local frame = CreateInstance("Frame", {
        BackgroundColor3 = backgroundColor or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = transparency or 0,
        BorderSizePixel = 0
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, cornerRadius or 5),
        Parent = frame
    })
    
    return frame
end

local function CreateTextLabel(text, textSize, properties)
    properties = properties or {}
    return CreateInstance("TextLabel", {
        Text = text or "",
        TextSize = textSize or 14,
        TextColor3 = properties.TextColor3 or Color3.fromRGB(255, 255, 255),
        Font = properties.Font or Enum.Font.Gotham,
        BackgroundTransparency = 1,
        TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center,
        TextWrapped = properties.TextWrapped or false,
        TextTruncate = properties.TextTruncate or Enum.TextTruncate.None,
        Size = properties.Size or UDim2.new(1, 0, 1, 0),
        Position = properties.Position or UDim2.new(0, 0, 0, 0)
    })
end

local function CreateTextButton(properties)
    properties = properties or {}
    return CreateInstance("TextButton", {
        Text = properties.Text or "",
        TextSize = properties.TextSize or 14,
        TextColor3 = properties.TextColor3 or Color3.fromRGB(255, 255, 255),
        Font = properties.Font or Enum.Font.Gotham,
        BackgroundColor3 = properties.BackgroundColor3 or Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = properties.BackgroundTransparency or 0,
        BorderSizePixel = 0,
        AutoButtonColor = properties.AutoButtonColor ~= nil and properties.AutoButtonColor or false,
        Size = properties.Size or UDim2.new(1, 0, 0, 36),
        Position = properties.Position or UDim2.new(0, 0, 0, 0)
    })
end

local function CreateImageLabel(image, properties)
    properties = properties or {}
    return CreateInstance("ImageLabel", {
        Image = image or "",
        ImageColor3 = properties.ImageColor3 or Color3.fromRGB(255, 255, 255),
        ImageTransparency = properties.ImageTransparency or 0,
        BackgroundTransparency = 1,
        ScaleType = properties.ScaleType or Enum.ScaleType.Fit,
        Size = properties.Size or UDim2.new(0, 20, 0, 20),
        Position = properties.Position or UDim2.new(0, 0, 0, 0)
    })
end

local function CreateStroke(color, transparency, thickness)
    return CreateInstance("UIStroke", {
        Color = color or Color3.fromRGB(40, 40, 40),
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end

local function CreateUIListLayout(fillDirection, padding)
    return CreateInstance("UIListLayout", {
        FillDirection = fillDirection or Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, padding or 6)
    })
end

local function ApplyTheme(object, themeProperty)
    OrionLib.ThemeObjects[object] = themeProperty
    local currentTheme = OrionLib.Themes[OrionLib.SelectedTheme]
    
    if themeProperty == "Main" then
        object.BackgroundColor3 = currentTheme.Main
    elseif themeProperty == "Second" then
        object.BackgroundColor3 = currentTheme.Second
    elseif themeProperty == "Stroke" then
        object.Color = currentTheme.Stroke
    elseif themeProperty == "Text" then
        object.TextColor3 = currentTheme.Text
    elseif themeProperty == "TextDark" then
        object.TextColor3 = currentTheme.TextDark
    elseif themeProperty == "Divider" then
        object.BackgroundColor3 = currentTheme.Divider
    end
    
    return object
end

local function GetAllUIComponents(parent)
    local components = {}
    
    components.AddButton = function(options)
        options = options or {}
        options.Name = options.Name or "Button"
        options.Callback = options.Callback or function() end
        
        local buttonFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local button = CreateTextButton({
            Text = options.Name,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = buttonFrame
        })
        
        ApplyTheme(button, "Second")
        
        local corner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = button
        })
        
        local stroke = CreateStroke()
        stroke.Parent = button
        ApplyTheme(stroke, "Stroke")
        
        ConnectSignal(button.MouseButton1Click, function()
            TweenObject(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            }):Play()
            
            task.wait(0.1)
            
            TweenObject(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second
            }):Play()
            
            pcall(options.Callback)
        end)
        
        return buttonFrame
    end
    
    components.AddToggle = function(options)
        options = options or {}
        options.Name = options.Name or "Toggle"
        options.Default = options.Default or false
        options.Callback = options.Callback or function() end
        options.Flag = options.Flag
        
        local toggleState = {
            Value = options.Default,
            Type = "Toggle"
        }
        
        local toggleFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local toggleButton = CreateTextButton({
            Text = "",
            Size = UDim2.new(1, 0, 1, 0),
            Parent = toggleFrame
        })
        
        ApplyTheme(toggleButton, "Second")
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = toggleButton
        })
        
        local stroke = CreateStroke()
        stroke.Parent = toggleButton
        ApplyTheme(stroke, "Stroke")
        
        local titleLabel = CreateTextLabel(options.Name, 14, {
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -50, 1, 0),
            Parent = toggleButton
        })
        ApplyTheme(titleLabel, "Text")
        
        local toggleIndicator = CreateRoundedFrame(Color3.fromRGB(100, 100, 100), 0, 5)
        toggleIndicator.Size = UDim2.new(0, 40, 0, 20)
        toggleIndicator.Position = UDim2.new(1, -50, 0.5, -10)
        toggleIndicator.Parent = toggleButton
        
        local toggleKnob = CreateRoundedFrame(Color3.fromRGB(255, 255, 255), 0, 8)
        toggleKnob.Size = UDim2.new(0, 16, 0, 16)
        toggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
        toggleKnob.Parent = toggleIndicator
        
        function toggleState:Set(value)
            toggleState.Value = value
            
            TweenObject(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
            
            TweenObject(toggleIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = value and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(100, 100, 100)
            }):Play()
            
            pcall(options.Callback, value)
            SaveConfiguration(game.PlaceId)
        end
        
        ConnectSignal(toggleButton.MouseButton1Click, function()
            toggleState:Set(not toggleState.Value)
        end)
        
        toggleState:Set(toggleState.Value)
        
        if options.Flag then
            OrionLib.Flags[options.Flag] = toggleState
        end
        
        return toggleState
    end
    
    components.AddSlider = function(options)
        options = options or {}
        options.Name = options.Name or "Slider"
        options.Min = options.Min or 0
        options.Max = options.Max or 100
        options.Default = options.Default or options.Min
        options.Increment = options.Increment or 1
        options.ValueName = options.ValueName or ""
        options.Callback = options.Callback or function() end
        options.Flag = options.Flag
        
        local sliderState = {
            Value = options.Default,
            Min = options.Min,
            Max = options.Max,
            Increment = options.Increment,
            Type = "Slider"
        }
        
        local sliderFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local sliderContainer = CreateRoundedFrame(Color3.fromRGB(25, 25, 25), 0, 5)
        sliderContainer.Size = UDim2.new(1, 0, 1, 0)
        sliderContainer.Parent = sliderFrame
        ApplyTheme(sliderContainer, "Second")
        
        local stroke = CreateStroke()
        stroke.Parent = sliderContainer
        ApplyTheme(stroke, "Stroke")
        
        local titleLabel = CreateTextLabel(options.Name, 14, {
            Position = UDim2.new(0, 12, 0, 6),
            Size = UDim2.new(1, -24, 0, 16),
            Parent = sliderContainer
        })
        ApplyTheme(titleLabel, "Text")
        
        local valueLabel = CreateTextLabel(tostring(options.Default) .. " " .. options.ValueName, 12, {
            Position = UDim2.new(1, -12, 0, 6),
            Size = UDim2.new(0, 0, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = sliderContainer
        })
        ApplyTheme(valueLabel, "TextDark")
        
        local sliderTrack = CreateRoundedFrame(Color3.fromRGB(40, 40, 40), 0, 3)
        sliderTrack.Size = UDim2.new(1, -24, 0, 6)
        sliderTrack.Position = UDim2.new(0, 12, 1, -16)
        sliderTrack.Parent = sliderContainer
        
        local sliderFill = CreateRoundedFrame(Color3.fromRGB(76, 175, 80), 0, 3)
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        sliderFill.Parent = sliderTrack
        
        local sliderKnob = CreateRoundedFrame(Color3.fromRGB(255, 255, 255), 0, 8)
        sliderKnob.Size = UDim2.new(0, 12, 0, 12)
        sliderKnob.Position = UDim2.new(0, 0, 0.5, -6)
        sliderKnob.Parent = sliderTrack
        
        function sliderState:Set(value)
            value = math.clamp(value, options.Min, options.Max)
            value = math.floor(value / options.Increment + 0.5) * options.Increment
            sliderState.Value = value
            
            local percentage = (value - options.Min) / (options.Max - options.Min)
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderKnob.Position = UDim2.new(percentage, 0, 0.5, -6)
            valueLabel.Text = tostring(value) .. " " .. options.ValueName
            
            pcall(options.Callback, value)
            SaveConfiguration(game.PlaceId)
        end
        
        local dragging = false
        
        ConnectSignal(sliderTrack.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                
                local function update()
                    local mousePos = UserInputService:GetMouseLocation().X
                    local trackPos = sliderTrack.AbsolutePosition.X
                    local trackSize = sliderTrack.AbsoluteSize.X
                    local percentage = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                    local value = options.Min + (options.Max - options.Min) * percentage
                    sliderState:Set(value)
                end
                
                update()
                
                local connection
                connection = ConnectSignal(UserInputService.InputChanged, function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update()
                    end
                end)
            end
        end)
        
        ConnectSignal(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        sliderState:Set(sliderState.Value)
        
        if options.Flag then
            OrionLib.Flags[options.Flag] = sliderState
        end
        
        return sliderState
    end
    
    components.AddDropdown = function(options)
        options = options or {}
        options.Name = options.Name or "Dropdown"
        options.Default = options.Default or ""
        options.Options = options.Options or {}
        options.Callback = options.Callback or function() end
        options.Flag = options.Flag
        
        local dropdownState = {
            Value = options.Default,
            Options = options.Options,
            Type = "Dropdown",
            Expanded = false
        }
        
        local dropdownFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local dropdownButton = CreateTextButton({
            Text = "",
            Size = UDim2.new(1, 0, 1, 0),
            Parent = dropdownFrame
        })
        
        ApplyTheme(dropdownButton, "Second")
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = dropdownButton
        })
        
        local stroke = CreateStroke()
        stroke.Parent = dropdownButton
        ApplyTheme(stroke, "Stroke")
        
        local titleLabel = CreateTextLabel(options.Name, 14, {
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -50, 1, 0),
            Parent = dropdownButton
        })
        ApplyTheme(titleLabel, "Text")
        
        local valueLabel = CreateTextLabel(options.Default, 12, {
            Position = UDim2.new(1, -12, 0, 0),
            Size = UDim2.new(0, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = dropdownButton
        })
        ApplyTheme(valueLabel, "TextDark")
        
        local optionsList = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 6),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Visible = false,
            Parent = dropdownFrame
        })
        
        local optionsContainer = CreateRoundedFrame(Color3.fromRGB(25, 25, 25), 0, 5)
        optionsContainer.Size = UDim2.new(1, 0, 1, 0)
        optionsContainer.Parent = optionsList
        ApplyTheme(optionsContainer, "Second")
        
        local optionsStroke = CreateStroke()
        optionsStroke.Parent = optionsContainer
        ApplyTheme(optionsStroke, "Stroke")
        
        local optionsLayout = CreateUIListLayout(Enum.FillDirection.Vertical, 0)
        optionsLayout.Parent = optionsContainer
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            Parent = optionsContainer
        })
        
        function dropdownState:Refresh(newOptions)
            dropdownState.Options = newOptions
            
            for _, child in ipairs(optionsContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            for _, optionName in ipairs(newOptions) do
                local optionButton = CreateTextButton({
                    Text = optionName,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 28),
                    Parent = optionsContainer
                })
                
                ApplyTheme(optionButton, "Main")
                
                CreateInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = optionButton
                })
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = optionButton
                })
                
                local optionLabel = CreateTextLabel(optionName, 13, {
                    Size = UDim2.new(1, 0, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = optionButton
                })
                ApplyTheme(optionLabel, "Text")
                
                ConnectSignal(optionButton.MouseButton1Click, function()
                    dropdownState:Set(optionName)
                    dropdownState:Toggle()
                end)
            end
            
            optionsList.Size = UDim2.new(1, 0, 0, math.min(#newOptions * 28 + 12, 200))
        end
        
        function dropdownState:Set(value)
            dropdownState.Value = value
            valueLabel.Text = value
            pcall(options.Callback, value)
            SaveConfiguration(game.PlaceId)
        end
        
        function dropdownState:Toggle()
            dropdownState.Expanded = not dropdownState.Expanded
            optionsList.Visible = dropdownState.Expanded
            
            TweenObject(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = dropdownState.Expanded and 
                    UDim2.new(1, 0, 0, 36 + optionsList.Size.Y.Offset + 6) or 
                    UDim2.new(1, 0, 0, 36)
            }):Play()
        end
        
        ConnectSignal(dropdownButton.MouseButton1Click, function()
            dropdownState:Toggle()
        end)
        
        dropdownState:Refresh(options.Options)
        dropdownState:Set(options.Default)
        
        if options.Flag then
            OrionLib.Flags[options.Flag] = dropdownState
        end
        
        return dropdownState
    end
    
    components.AddTextbox = function(options)
        options = options or {}
        options.Name = options.Name or "Textbox"
        options.Default = options.Default or ""
        options.TextDisappear = options.TextDisappear ~= nil and options.TextDisappear or false
        options.Callback = options.Callback or function() end
        options.Flag = options.Flag
        
        local textboxState = {
            Value = options.Default,
            Type = "Textbox"
        }
        
        local textboxFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local textboxContainer = CreateRoundedFrame(Color3.fromRGB(25, 25, 25), 0, 5)
        textboxContainer.Size = UDim2.new(1, 0, 1, 0)
        textboxContainer.Parent = textboxFrame
        ApplyTheme(textboxContainer, "Second")
        
        local stroke = CreateStroke()
        stroke.Parent = textboxContainer
        ApplyTheme(stroke, "Stroke")
        
        local titleLabel = CreateTextLabel(options.Name, 14, {
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(0.5, -12, 1, 0),
            Parent = textboxContainer
        })
        ApplyTheme(titleLabel, "Text")
        
        local textbox = CreateInstance("TextBox", {
            Text = options.Default,
            PlaceholderText = "Enter text...",
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, -24, 1, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            ClearTextOnFocus = false,
            Parent = textboxContainer
        })
        
        CreateInstance("UIPadding", {
            PaddingRight = UDim.new(0, 12),
            Parent = textbox
        })
        
        function textboxState:Set(value)
            textboxState.Value = value
            textbox.Text = value
            pcall(options.Callback, value)
            SaveConfiguration(game.PlaceId)
        end
        
        ConnectSignal(textbox.FocusLost, function()
            textboxState:Set(textbox.Text)
            if options.TextDisappear then
                textbox.Text = ""
            end
        end)
        
        if options.Flag then
            OrionLib.Flags[options.Flag] = textboxState
        end
        
        return textboxState
    end
    
    components.AddLabel = function(options)
        options = options or {}
        options.Text = options.Text or "Label"
        
        local labelFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local label = CreateTextLabel(options.Text, 14, {
            Size = UDim2.new(1, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = labelFrame
        })
        ApplyTheme(label, "TextDark")
        
        return {
            Set = function(_, text)
                label.Text = text
            end
        }
    end
    
    components.AddParagraph = function(options)
        options = options or {}
        options.Title = options.Title or "Paragraph"
        options.Content = options.Content or ""
        
        local paragraphFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local container = CreateRoundedFrame(Color3.fromRGB(25, 25, 25), 0, 5)
        container.Size = UDim2.new(1, 0, 1, 0)
        container.Parent = paragraphFrame
        ApplyTheme(container, "Second")
        
        local stroke = CreateStroke()
        stroke.Parent = container
        ApplyTheme(stroke, "Stroke")
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            Parent = container
        })
        
        local titleLabel = CreateTextLabel(options.Title, 14, {
            Size = UDim2.new(1, 0, 0, 18),
            Font = Enum.Font.GothamBold,
            Parent = container
        })
        ApplyTheme(titleLabel, "Text")
        
        local contentLabel = CreateTextLabel(options.Content, 13, {
            Size = UDim2.new(1, 0, 1, -22),
            Position = UDim2.new(0, 0, 0, 22),
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = container
        })
        ApplyTheme(contentLabel, "TextDark")
        
        return {
            Set = function(_, title, content)
                titleLabel.Text = title
                contentLabel.Text = content
            end
        }
    end
    
    components.AddColorpicker = function(options)
        options = options or {}
        options.Name = options.Name or "Colorpicker"
        options.Default = options.Default or Color3.fromRGB(255, 255, 255)
        options.Callback = options.Callback or function() end
        options.Flag = options.Flag
        
        local hue, sat, val = 0, 1, 1
        local color = options.Default
        local h, s, v = Color3.toHSV(color)
        hue, sat, val = h, s, v
        
        local colorpickerState = {
            Value = color,
            Toggled = false,
            Type = "Colorpicker"
        }
        
        local colorpickerFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundTransparency = 1,
            Parent = parent
        })
        
        local headerButton = CreateTextButton({
            Text = "",
            Size = UDim2.new(1, 0, 1, 0),
            Parent = colorpickerFrame
        })
        ApplyTheme(headerButton, "Second")
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = headerButton
        })
        
        local stroke = CreateStroke()
        stroke.Parent = headerButton
        ApplyTheme(stroke, "Stroke")
        
        local titleLabel = CreateTextLabel(options.Name, 14, {
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -50, 1, 0),
            Parent = headerButton
        })
        ApplyTheme(titleLabel, "Text")
        
        local colorDisplay = CreateRoundedFrame(color, 0, 5)
        colorDisplay.Size = UDim2.new(0, 24, 0, 24)
        colorDisplay.Position = UDim2.new(1, -34, 0.5, -12)
        colorDisplay.Parent = headerButton
        
        local displayStroke = CreateStroke()
        displayStroke.Parent = colorDisplay
        ApplyTheme(displayStroke, "Stroke")
        
        local pickerContainer = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 110),
            Position = UDim2.new(0, 0, 1, 6),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Visible = false,
            Parent = colorpickerFrame
        })
        
        local pickerFrame = CreateRoundedFrame(Color3.fromRGB(25, 25, 25), 0, 5)
        pickerFrame.Size = UDim2.new(1, 0, 1, 0)
        pickerFrame.Parent = pickerContainer
        ApplyTheme(pickerFrame, "Second")
        
        local pickerStroke = CreateStroke()
        pickerStroke.Parent = pickerFrame
        ApplyTheme(pickerStroke, "Stroke")
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Parent = pickerFrame
        })
        
        local satValSelector = CreateInstance("ImageLabel", {
            Image = "rbxassetid://4155801252",
            ImageColor3 = Color3.fromHSV(hue, 1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -70, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Parent = pickerFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = satValSelector
        })
        
        local satValKnob = CreateRoundedFrame(Color3.fromRGB(255, 255, 255), 0, 8)
        satValKnob.Size = UDim2.new(0, 8, 0, 8)
        satValKnob.Position = UDim2.new(sat, 0, 1 - val, 0)
        satValKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        satValKnob.Parent = satValSelector
        
        local satValStroke = CreateStroke(Color3.fromRGB(0, 0, 0), 0, 2)
        satValStroke.Parent = satValKnob
        
        local hueSelector = CreateInstance("ImageLabel", {
            Image = "rbxassetid://3641079629",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageRectSize = Vector2.new(1, 256),
            BackgroundTransparency = 1,
            ScaleType = Enum.ScaleType.Crop,
            Size = UDim2.new(0, 50, 1, 0),
            Position = UDim2.new(1, -50, 0, 0),
            Parent = pickerFrame
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = hueSelector
        })
        
        local hueKnob = CreateRoundedFrame(Color3.fromRGB(255, 255, 255), 0, 6)
        hueKnob.Size = UDim2.new(1, 0, 0, 6)
        hueKnob.Position = UDim2.new(0.5, 0, 1 - hue, 0)
        hueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
        hueKnob.Parent = hueSelector
        
        local hueStroke = CreateStroke(Color3.fromRGB(0, 0, 0), 0, 2)
        hueStroke.Parent = hueKnob
        
        function colorpickerState:Set(newColor)
            colorpickerState.Value = newColor
            colorDisplay.BackgroundColor3 = newColor
            pcall(options.Callback, newColor)
            SaveConfiguration(game.PlaceId)
        end
        
        local function updateColor()
            local newColor = Color3.fromHSV(hue, sat, val)
            satValSelector.ImageColor3 = Color3.fromHSV(hue, 1, 1)
            colorpickerState:Set(newColor)
        end
        
        hue = 1 - math.clamp((hueKnob.AbsolutePosition.Y - hueSelector.AbsolutePosition.Y) / hueSelector.AbsoluteSize.Y, 0, 1)
        sat = math.clamp((satValKnob.AbsolutePosition.X - satValSelector.AbsolutePosition.X) / satValSelector.AbsoluteSize.X, 0, 1)
        val = 1 - math.clamp((satValKnob.AbsolutePosition.Y - satValSelector.AbsolutePosition.Y) / satValSelector.AbsoluteSize.Y, 0, 1)
        
        local satValDragging = false
        ConnectSignal(satValSelector.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                satValDragging = true
                
                local function update()
                    local mousePos = UserInputService:GetMouseLocation()
                    sat = math.clamp((mousePos.X - satValSelector.AbsolutePosition.X) / satValSelector.AbsoluteSize.X, 0, 1)
                    val = 1 - math.clamp((mousePos.Y - satValSelector.AbsolutePosition.Y) / satValSelector.AbsoluteSize.Y, 0, 1)
                    satValKnob.Position = UDim2.new(sat, 0, 1 - val, 0)
                    updateColor()
                end
                
                update()
                
                local connection
                connection = ConnectSignal(RunService.RenderStepped, function()
                    if satValDragging then
                        update()
                    else
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        ConnectSignal(satValSelector.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                satValDragging = false
            end
        end)
        
        local hueDragging = false
        ConnectSignal(hueSelector.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hueDragging = true
                
                local function update()
                    local mousePos = UserInputService:GetMouseLocation()
                    local percentage = math.clamp((mousePos.Y - hueSelector.AbsolutePosition.Y) / hueSelector.AbsoluteSize.Y, 0, 1)
                    hue = 1 - percentage
                    hueKnob.Position = UDim2.new(0.5, 0, percentage, 0)
                    updateColor()
                end
                
                update()
                
                local connection
                connection = ConnectSignal(RunService.RenderStepped, function()
                    if hueDragging then
                        update()
                    else
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        ConnectSignal(hueSelector.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                hueDragging = false
            end
        end)
        
        ConnectSignal(headerButton.MouseButton1Click, function()
            colorpickerState.Toggled = not colorpickerState.Toggled
            pickerContainer.Visible = colorpickerState.Toggled
            
            TweenObject(colorpickerFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = colorpickerState.Toggled and UDim2.new(1, 0, 0, 154) or UDim2.new(1, 0, 0, 38)
            }):Play()
        end)
        
        colorpickerState:Set(colorpickerState.Value)
        
        if options.Flag then
            OrionLib.Flags[options.Flag] = colorpickerState
        end
        
        return colorpickerState
    end
    
    return components
end

--============================================================================
-- MAIN WINDOW CREATION
--============================================================================

function OrionLib:MakeWindow(options)
    options = options or {}
    options.Name = options.Name or "Orion Library"
    options.HidePremium = options.HidePremium ~= nil and options.HidePremium or false
    options.SaveConfig = options.SaveConfig ~= nil and options.SaveConfig or false
    options.ConfigFolder = options.ConfigFolder or "OrionConfig"
    options.IntroEnabled = options.IntroEnabled ~= nil and options.IntroEnabled or true
    options.IntroText = options.IntroText or "Orion Library"
    options.IntroIcon = options.IntroIcon or "rbxassetid://7733960981"
    options.Icon = options.Icon or "rbxassetid://7733960981"
    
    OrionLib.SaveCfg = options.SaveConfig
    
    local screenGui
    if gethui then
        screenGui = gethui()
    elseif syn and syn.protect_gui then
        screenGui = Instance.new("ScreenGui")
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    else
        screenGui = CoreGui
    end
    
    local mainGui = CreateInstance("ScreenGui", {
        Name = "OrionLib",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        Parent = screenGui
    })
    
    local mainFrame = CreateRoundedFrame(Color3.fromRGB(20, 20, 20), 0, 10)
    mainFrame.Size = UDim2.new(0, 600, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = mainGui
    ApplyTheme(mainFrame, "Main")
    
    local mainStroke = CreateStroke()
    mainStroke.Parent = mainFrame
    ApplyTheme(mainStroke, "Stroke")
    
    local titleBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })
    
    local titleIcon = CreateImageLabel(options.Icon, {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 15, 0, 10),
        Parent = titleBar
    })
    
    local titleLabel = CreateTextLabel(options.Name, 16, {
        Position = UDim2.new(0, 45, 0, 0),
        Size = UDim2.new(1, -100, 1, 0),
        Font = Enum.Font.GothamBold,
        Parent = titleBar
    })
    ApplyTheme(titleLabel, "Text")
    
    if not options.HidePremium then
        local premiumLabel = CreateTextLabel("Premium", 12, {
            Position = UDim2.new(1, -80, 0, 0),
            Size = UDim2.new(0, 70, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = Color3.fromRGB(255, 215, 0),
            Parent = titleBar
        })
    end
    
    local closeButton = CreateTextButton({
        Text = "×",
        TextSize = 24,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        Parent = titleBar
    })
    ApplyTheme(closeButton, "Text")
    
    ConnectSignal(closeButton.MouseButton1Click, function()
        OrionLib:Destroy()
    end)
    
    local divider = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 40),
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    ApplyTheme(divider, "Divider")
    
    local tabContainer = CreateInstance("Frame", {
        Size = UDim2.new(0, 150, 1, -41),
        Position = UDim2.new(0, 0, 0, 41),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })
    
    local tabListLayout = CreateUIListLayout(Enum.FillDirection.Vertical, 4)
    tabListLayout.Parent = tabContainer
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = tabContainer
    })
    
    local tabDivider = CreateInstance("Frame", {
        Size = UDim2.new(0, 1, 1, -41),
        Position = UDim2.new(0, 150, 0, 41),
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    ApplyTheme(tabDivider, "Divider")
    
    local contentContainer = CreateInstance("Frame", {
        Size = UDim2.new(1, -151, 1, -41),
        Position = UDim2.new(0, 151, 0, 41),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })
    
    MakeDraggable(mainFrame, titleBar)
    
    if options.IntroEnabled then
        mainFrame.Visible = false
        
        local introFrame = CreateRoundedFrame(Color3.fromRGB(20, 20, 20), 0, 10)
        introFrame.Size = UDim2.new(0, 400, 0, 200)
        introFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
        introFrame.Parent = mainGui
        ApplyTheme(introFrame, "Main")
        
        local introStroke = CreateStroke()
        introStroke.Parent = introFrame
        ApplyTheme(introStroke, "Stroke")
        
        local introIcon = CreateImageLabel(options.IntroIcon, {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0.5, -30, 0, 40),
            Parent = introFrame
        })
        
        local introTitle = CreateTextLabel(options.IntroText, 20, {
            Position = UDim2.new(0, 0, 0, 110),
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = introFrame
        })
        ApplyTheme(introTitle, "Text")
        
        local introSubtitle = CreateTextLabel("Loading...", 14, {
            Position = UDim2.new(0, 0, 0, 145),
            Size = UDim2.new(1, 0, 0, 20),
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = introFrame
        })
        ApplyTheme(introSubtitle, "TextDark")
        
        task.spawn(function()
            task.wait(1.5)
            TweenObject(introFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            }):Play()
            
            for _, child in ipairs(introFrame:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("ImageLabel") then
                    TweenObject(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 1,
                        ImageTransparency = 1
                    }):Play()
                elseif child:IsA("UIStroke") then
                    TweenObject(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Transparency = 1
                    }):Play()
                end
            end
            
            task.wait(0.5)
            introFrame:Destroy()
            mainFrame.Visible = true
        end)
    end
    
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:MakeTab(options)
        options = options or {}
        options.Name = options.Name or "Tab"
        options.Icon = options.Icon or "rbxassetid://7733960981"
        options.PremiumOnly = options.PremiumOnly or false
        
        local Tab = {
            Name = options.Name,
            Active = false
        }
        
        local tabButton = CreateTextButton({
            Text = "",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 0.95,
            Parent = tabContainer
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = tabButton
        })
        
        local tabIcon = CreateImageLabel(GetIcon(options.Icon), {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 10, 0.5, -9),
            Parent = tabButton
        })
        ApplyTheme(tabIcon, "TextDark")
        
        local tabLabel = CreateTextLabel(options.Name, 13, {
            Position = UDim2.new(0, 36, 0, 0),
            Size = UDim2.new(1, -36, 1, 0),
            Parent = tabButton
        })
        ApplyTheme(tabLabel, "Text")
        
        local tabContent = CreateInstance("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = contentContainer
        })
        
        local contentLayout = CreateUIListLayout(Enum.FillDirection.Vertical, 8)
        contentLayout.Parent = tabContent
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 15),
            PaddingBottom = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            Parent = tabContent
        })
        
        ConnectSignal(contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 30)
        end)
        
        function Tab:Activate()
            if Window.CurrentTab then
                Window.CurrentTab:Deactivate()
            end
            
            Tab.Active = true
            Window.CurrentTab = Tab
            tabContent.Visible = true
            
            TweenObject(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0
            }):Play()
            
            ApplyTheme(tabButton, "Second")
        end
        
        function Tab:Deactivate()
            Tab.Active = false
            tabContent.Visible = false
            
            TweenObject(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0.95
            }):Play()
        end
        
        ConnectSignal(tabButton.MouseButton1Click, function()
            if not Tab.Active then
                Tab:Activate()
            end
        end)
        
        local tabComponents = GetAllUIComponents(tabContent)
        
        function Tab:AddSection(options)
            options = options or {}
            options.Name = options.Name or "Section"
            
            local sectionFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
                Parent = tabContent
            })
            
            local sectionLabel = CreateTextLabel(options.Name, 14, {
                Size = UDim2.new(1, -12, 0, 16),
                Position = UDim2.new(0, 0, 0, 3),
                Font = Enum.Font.GothamMedium,
                Parent = sectionFrame
            })
            ApplyTheme(sectionLabel, "TextDark")
            
            local sectionContent = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 1, -24),
                Position = UDim2.new(0, 0, 0, 23),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })
            
            local sectionLayout = CreateUIListLayout(Enum.FillDirection.Vertical, 6)
            sectionLayout.Parent = sectionContent
            
            ConnectSignal(sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                sectionFrame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 31)
                sectionContent.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y)
            end)
            
            local Section = GetAllUIComponents(sectionContent)
            return Section
        end
        
        for methodName, method in pairs(tabComponents) do
            Tab[methodName] = method
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            Tab:Activate()
        end
        
        return Tab
    end
    
    if options.SaveConfig then
        LoadConfiguration(game.PlaceId)
    end
    
    return Window
end

--============================================================================
-- THEME MANAGEMENT
--============================================================================

function OrionLib:SetTheme(themeName)
    if OrionLib.Themes[themeName] then
        OrionLib.SelectedTheme = themeName
        local theme = OrionLib.Themes[themeName]
        
        for object, themeProperty in pairs(OrionLib.ThemeObjects) do
            if object and object.Parent then
                if themeProperty == "Main" then
                    TweenObject(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = theme.Main
                    }):Play()
                elseif themeProperty == "Second" then
                    TweenObject(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = theme.Second
                    }):Play()
                elseif themeProperty == "Stroke" then
                    TweenObject(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Color = theme.Stroke
                    }):Play()
                elseif themeProperty == "Text" then
                    TweenObject(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        TextColor3 = theme.Text
                    }):Play()
                elseif themeProperty == "TextDark" then
                    TweenObject(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        TextColor3 = theme.TextDark
                    }):Play()
                elseif themeProperty == "Divider" then
                    TweenObject(object, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = theme.Divider
                    }):Play()
                end
            end
        end
    end
end

function OrionLib:AddTheme(themeName, themeData)
    OrionLib.Themes[themeName] = themeData
end

--============================================================================
-- CLEANUP
--============================================================================

function OrionLib:Destroy()
    for _, connection in ipairs(OrionLib.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    
    for gui, _ in pairs(OrionLib.Elements) do
        pcall(function()
            DebrisService:AddItem(gui, 0)
        end)
    end
    
    OrionLib.Elements = {}
    OrionLib.ThemeObjects = {}
    OrionLib.Connections = {}
    OrionLib.Flags = {}
end

--============================================================================
-- RETURN LIBRARY
--============================================================================

return OrionLib
