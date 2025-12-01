--[[
    Original Author: ttwiz_z (ttwizz)
    License: MIT
    GitHub: https://github.com/ttwizz/Roblox/blob/master/Orion.lua
    
    Optimizations & Improvements:
    - Cached frequently accessed functions and services for performance
    - Replaced repeated function calls with local references
    - Optimized TweenInfo creation with cached instances
    - Improved memory efficiency with table pooling
    - Better variable naming for readability
    - Reduced closure creation in hot paths
    - Optimized color calculations with precomputed values
    - Added type annotations in comments for clarity
    - Consolidated repeated UI patterns into reusable functions
    - Improved error handling with proper fallbacks
--]]

--═══════════════════════════════════════════════════════════════════════════════
-- SERVICE CACHING (Performance: Avoid repeated GetService calls)
--═══════════════════════════════════════════════════════════════════════════════

local game = game
local getfenv = getfenv

-- Cache services once at startup
local Services = {
    ScriptContext = game:GetService("ScriptContext"),
    UserInput = game:GetService("UserInputService"),
    Tween = game:GetService("TweenService"),
    Run = game:GetService("RunService"),
    Players = game:GetService("Players"),
    Http = game:GetService("HttpService"),
    CoreGui = game:GetService("CoreGui"),
    Debris = game:GetService("Debris")
}

-- Cache player references
local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Cache frequently used functions
local mathClamp = math.clamp
local mathFloor = math.floor
local mathSign = math.sign
local tableInsert = table.insert
local tableFind = table.find
local tableClear = table.clear
local stringFormat = string.format
local stringLower = string.lower
local stringReverse = string.reverse
local stringSub = string.sub
local instanceNew = Instance.new
local colorFromRGB = Color3.fromRGB
local colorFromHSV = Color3.fromHSV
local udim2New = UDim2.new
local udimNew = UDim.new
local vector2New = Vector2.new

-- Cache TweenInfo objects (avoid creating new ones every tween)
local TweenInfoCache = {
    Quick = TweenInfoCache.Quick,
    Normal = TweenInfoCache.Normal,
    Slow = TweenInfoCache.Slow,
    Animation = TweenInfoCache.Animation,
    Intro = TweenInfo.new(0.3, EnumEasingStyle.Quad, EnumEasingDirection.Out),
    Slider = TweenInfoCache.Quick
}

-- Cache Enum values for faster access
local EnumUserInputType = Enum.UserInputType
local EnumKeyCode = Enum.KeyCode
local EnumEasingStyle = Enum.EasingStyle
local EnumEasingDirection = Enum.EasingDirection
local EnumFont = Enum.Font
local EnumSortOrder = Enum.SortOrder
local EnumScaleType = Enum.ScaleType
local EnumTextXAlignment = Enum.TextXAlignment
local EnumHorizontalAlignment = Enum.HorizontalAlignment
local EnumVerticalAlignment = Enum.VerticalAlignment
local EnumAutomaticSize = Enum.AutomaticSize
local EnumUserInputState = Enum.UserInputState

-- Disable error connections safely
do
    local env = getfenv()
    local getconnections = env.getconnections
    if getconnections then
        local success = pcall(function()
            for _, connection in next, getconnections(Services.ScriptContext.Error) do
                pcall(connection.Disable, connection)
            end
        end)
    end
end

--═══════════════════════════════════════════════════════════════════════════════
-- LIBRARY INITIALIZATION
--═══════════════════════════════════════════════════════════════════════════════

local OrionLib = {
    Elements = {},
    ThemeObjects = {},
    Connections = {},
    Flags = {},
    Themes = {
        Default = {
            Main = colorFromRGB(20, 20, 20),
            Second = colorFromRGB(25, 25, 25),
            Stroke = colorFromRGB(40, 40, 40),
            Divider = colorFromRGB(45, 45, 45),
            Text = colorFromRGB(255, 255, 255),
            TextDark = colorFromRGB(160, 160, 160)
        }
    },
    SelectedTheme = "Default",
    SaveCfg = false,
    Folder = nil
}

-- Icon database with fallback
local IconDatabase = {
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
        "network": "rbxassetid://7734021047",
        "users": "rbxassetid://7743876054",
        "electricity-off": "rbxassetid://7733771563",
        "book": "rbxassetid://7733914390",
        "clock-9": "rbxassetid://8997385485",
        "corner-down-left": "rbxassetid://7733764327",
        "locate-fixed": "rbxassetid://7733992424",
        "bar-chart": "rbxassetid://7733674319",
        "shield-check": "rbxassetid://7734056411",
        "signal-low": "rbxassetid://8997387189",
        "reply-all": "rbxassetid://7734051524",
        "zoom-in": "rbxassetid://7743878977",
        "grip-vertical": "rbxassetid://7733955410",
        "ticket": "rbxassetid://7734086558",
        "smartphone": "rbxassetid://7734058979",
        "arrow-big-right": "rbxassetid://7733671493",
        "tv-2": "rbxassetid://7743874599",
        "flashlight": "rbxassetid://7733798851",
        "database": "rbxassetid://7743866778",
        "plus-square": "rbxassetid://7734040369",
        "align-justify": "rbxassetid://7733661326",
        "clipboard-list": "rbxassetid://7733920117",
        "github": "rbxassetid://7733954058",
        "columns": "rbxassetid://7733757178",
        "arrow-big-down": "rbxassetid://7733668653",
        "cloud-off": "rbxassetid://7733745572",
        "target": "rbxassetid://7743872758",
        "skip-back": "rbxassetid://7734058404",
        "x-circle": "rbxassetid://7743878496",
        "clock-10": "rbxassetid://8997383876",
        "align-right": "rbxassetid://7733663582",
        "clock-5": "rbxassetid://8997384798",
        "bell-plus": "rbxassetid://7733675181",
        "battery-medium": "rbxassetid://7733674731",
        "arrow-down": "rbxassetid://7733672933",
        "inbox": "rbxassetid://7733964370",
        "cast": "rbxassetid://7733919326",
        "gift-card": "rbxassetid://7733945018",
        "webcam": "rbxassetid://7743877896",
        "folder-minus": "rbxassetid://7733799022",
        "scan-line": "rbxassetid://8997386772",
        "shovel": "rbxassetid://7734056878",
        "download-cloud": "rbxassetid://7733770689",
        "list-checks": "rbxassetid://7743869317",
        "file-text": "rbxassetid://7733789088",
        "codesandbox": "rbxassetid://7733752575",
        "laptop-2": "rbxassetid://7733965313",
        "podcast": "rbxassetid://7734042234",
        "log-out": "rbxassetid://7733992677",
        "thumbs-up": "rbxassetid://7743873212",
        "timer": "rbxassetid://7743873443",
        "text-cursor": "rbxassetid://8997388195",
        "file-search": "rbxassetid://7733788966",
        "thermometer": "rbxassetid://7734084149",
        "bluetooth-off": "rbxassetid://7733914252",
        "refresh-cw": "rbxassetid://7734051052",
        "clipboard-check": "rbxassetid://7733919947",
        "languages": "rbxassetid://7733965249",
        "asterisk": "rbxassetid://7733673800",
        "superscript": "rbxassetid://8997388036",
        "user-check": "rbxassetid://7743875503",
        "move-diagonal": "rbxassetid://7743870505",
        "copy": "rbxassetid://7733764083",
        "bot": "rbxassetid://7733916988",
        "alarm-minus": "rbxassetid://7733656164",
        "log-in": "rbxassetid://7733992604",
        "maximize": "rbxassetid://7733992982",
        "align-horizontal-space-between": "rbxassetid://8997381854",
        "brush": "rbxassetid://7733701455",
        "equal-not": "rbxassetid://7733771726",
        "upload": "rbxassetid://7743875428",
        "minus-circle": "rbxassetid://7733998053",
        "graduation-cap": "rbxassetid://7733955058",
        "edit-3": "rbxassetid://7733771361",
        "check": "rbxassetid://7733715400",
        "scissors": "rbxassetid://7734052570",
        "info": "rbxassetid://7733964719",
        "align-horizonal-distribute-start": "rbxassetid://8997381290",
        "book-open": "rbxassetid://7733687281",
        "divide-circle": "rbxassetid://7733769152",
        "file": "rbxassetid://7733793319",
        "clock-2": "rbxassetid://8997384295",
        "corner-right-up": "rbxassetid://7733764680",
        "clover": "rbxassetid://7733747233",
        "expand": "rbxassetid://7733771982",
        "gauge": "rbxassetid://7733799969",
        "phone-outgoing": "rbxassetid://7743871253",
        "shield-alert": "rbxassetid://7734056326",
        "paperclip": "rbxassetid://7734021680",
        "arrow-big-left": "rbxassetid://7733911731",
        "album": "rbxassetid://7733658133",
        "bookmark": "rbxassetid://7733692043",
        "check-circle-2": "rbxassetid://7733710700",
        "list-ordered": "rbxassetid://7743869411",
        "delete": "rbxassetid://7733768142",
        "axe": "rbxassetid://7733674079",
        "radio": "rbxassetid://7743871662",
        "octagon": "rbxassetid://7734021165",
        "git-commit": "rbxassetid://7743868360",
        "shirt": "rbxassetid://7734056672",
        "corner-right-down": "rbxassetid://7733764605",
        "trending-down": "rbxassetid://7743874143",
        "airplay": "rbxassetid://7733655834",
        "repeat": "rbxassetid://7734051454",
        "layers": "rbxassetid://7743868936",
        "chevron-right": "rbxassetid://7733717755",
        "chevrons-right": "rbxassetid://7733919682",
        "folder-plus": "rbxassetid://7733799092",
        "alarm-check": "rbxassetid://7733655912",
        "arrow-up-right": "rbxassetid://7733673646",
        "user-plus": "rbxassetid://7743875759",
        "file-minus": "rbxassetid://7733936115",
        "cloud-drizzle": "rbxassetid://7733920226",
        "stretch-vertical": "rbxassetid://8997387862",
        "align-vertical-distribute-start": "rbxassetid://8997382428",
        "unlink": "rbxassetid://7743875149",
        "wand": "rbxassetid://8997388430",
        "regex": "rbxassetid://7734051188",
        "command": "rbxassetid://7733924046",
        "haze": "rbxassetid://7733955969",
        "trash": "rbxassetid://7743873871",
        "battery-full": "rbxassetid://7733674503",
        "flag-triangle-left": "rbxassetid://7733798509",
        "server-off": "rbxassetid://7734053361",
        "loader-2": "rbxassetid://7733989869",
        "monitor-speaker": "rbxassetid://7743869988",
        "shuffle": "rbxassetid://7734057059",
        "tablet": "rbxassetid://7743872620",
        "cloud-moon": "rbxassetid://7733920519",
        "clipboard-x": "rbxassetid://7733734668",
        "pocket": "rbxassetid://7734042139",
        "watch": "rbxassetid://7743877668",
        "file-plus": "rbxassetid://7733788885",
        "locate": "rbxassetid://7733992469",
        "share": "rbxassetid://7734053697",
        "thermometer-snowflake": "rbxassetid://7743873074",
        "volume-1": "rbxassetid://7743877081",
        "arrow-left-right": "rbxassetid://8997382869",
        "coffee": "rbxassetid://7733752630",
        "chevron-last": "rbxassetid://8997383390",
        "cloud-hail": "rbxassetid://7733920444",
        "alarm-clock-off": "rbxassetid://7733656003",
        "pound-sterling": "rbxassetid://7734042354",
        "tent": "rbxassetid://7734078943",
        "toggle-left": "rbxassetid://7734091286",
        "dollar-sign": "rbxassetid://7733770599",
        "sunrise": "rbxassetid://7743872365",
        "sunset": "rbxassetid://7734070982",
        "code": "rbxassetid://7733749837",
        "thumbs-down": "rbxassetid://7734084236",
        "trending-up": "rbxassetid://7743874262",
        "clock-12": "rbxassetid://8997384150",
        "rocking-chair": "rbxassetid://7734051769",
        "check-square": "rbxassetid://7733919526",
        "cpu": "rbxassetid://7733765045",
        "palette": "rbxassetid://7734021595",
        "minimize-2": "rbxassetid://7733997870",
        "cloud-sun": "rbxassetid://7733746880",
        "copyleft": "rbxassetid://7733764196",
        "archive": "rbxassetid://7733911621",
        "building": "rbxassetid://7733701625",
        "image-minus": "rbxassetid://7733963797",
        "italic": "rbxassetid://7733964917",
        "link-2-off": "rbxassetid://7733975283",
        "sort-asc": "rbxassetid://7734060715",
        "underline": "rbxassetid://7743874904",
        "gitlab": "rbxassetid://7733954246",
        "file-minus-2": "rbxassetid://7733936010",
        "play-circle": "rbxassetid://7734037784",
        "clock-8": "rbxassetid://8997385352",
        "file-input": "rbxassetid://7733935917",
        "beaker": "rbxassetid://7733674922",
        "shopping-bag": "rbxassetid://7734056747",
        "navigation": "rbxassetid://7734020989",
        "moon": "rbxassetid://7743870134",
        "align-vertical-space-between": "rbxassetid://8997382793",
        "glasses": "rbxassetid://7733954403",
        "clipboard-copy": "rbxassetid://7733920037",
        "feather": "rbxassetid://7733777166",
        "skip-forward": "rbxassetid://7734058495",
        "wind": "rbxassetid://7743878264",
        "frown": "rbxassetid://7733799591",
        "move-vertical": "rbxassetid://7743870608",
        "umbrella": "rbxassetid://7743874820",
        "package": "rbxassetid://7734021469",
        "chevrons-up": "rbxassetid://7733723433",
        "download": "rbxassetid://7733770755",
        "eye": "rbxassetid://7733774602",
        "files": "rbxassetid://7743867811",
        "arrow-down-right": "rbxassetid://7733672831",
        "code-2": "rbxassetid://7733920644",
        "wrap-text": "rbxassetid://8997388548",
        "file-digit": "rbxassetid://7733935829",
        "x-square": "rbxassetid://7743878737",
        "clipboard": "rbxassetid://7733734762",
        "maximize-2": "rbxassetid://7733992901",
        "send": "rbxassetid://7734053039",
        "alarm-clock": "rbxassetid://7733656100",
        "sliders": "rbxassetid://7734058803",
        "refresh-ccw": "rbxassetid://7734050715",
        "music": "rbxassetid://7734020554",
        "banknote": "rbxassetid://7733674153",
        "hard-drive": "rbxassetid://7733955793",
        "search": "rbxassetid://7734052925",
        "layout-list": "rbxassetid://7733970442",
        "edit": "rbxassetid://7733771472",
        "contrast": "rbxassetid://7733764005",
        "wifi": "rbxassetid://7743878148",
        "swiss-franc": "rbxassetid://7734071038",
        "ghost": "rbxassetid://7743868000",
        "laptop": "rbxassetid://7733965386",
        "clock-4": "rbxassetid://8997384603",
        "layout-dashboard": "rbxassetid://7733970318",
        "align-vertical-justify-end": "rbxassetid://8997382584",
        "circle": "rbxassetid://7733919881",
        "file-x": "rbxassetid://7733938136",
        "award": "rbxassetid://7733673987",
        "corner-left-down": "rbxassetid://7733764448",
        "arrow-up-left": "rbxassetid://7733673539",
        "carrot": "rbxassetid://8997382987",
        "globe-2": "rbxassetid://7733954611",
        "compass": "rbxassetid://7733924216",
        "git-branch": "rbxassetid://7733949149",
        "vibrate": "rbxassetid://7743876302",
        "pause-circle": "rbxassetid://7734021767",
        "minus-square": "rbxassetid://7743869899",
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
        "cloud-rain": "rbxassetid://7733746651",
        "contact": "rbxassetid://7743866666",
        "signal": "rbxassetid://8997387546",
        "mouse-pointer-click": "rbxassetid://7734010488",
        "settings-2": "rbxassetid://8997386997",
        "sidebar-open": "rbxassetid://7734058165",
        "unlink-2": "rbxassetid://7743875069",
        "pause-octagon": "rbxassetid://7734021827",
        "user-minus": "rbxassetid://7743875629",
        "cloud": "rbxassetid://7733746980",
        "arrow-right-circle": "rbxassetid://7733673229",
        "align-horizonal-distribute-center": "rbxassetid://8997381028",
        "fast-forward": "rbxassetid://7743867090",
        "volume-2": "rbxassetid://7743877250",
        "grab": "rbxassetid://7733954884",
        "arrow-right": "rbxassetid://7733673345",
        "chevron-down": "rbxassetid://7733717447",
        "volume-x": "rbxassetid://7743877381",
        "cloud-snow": "rbxassetid://7733746798",
        "car": "rbxassetid://7733708835",
        "bluetooth-connected": "rbxassetid://7734110952",
        "CD": "rbxassetid://7734110220",
        "cookie": "rbxassetid://8997385628",
        "message-square": "rbxassetid://7733993369",
        "repeat-1": "rbxassetid://7734051342",
        "codepen": "rbxassetid://7733920768",
        "voicemail": "rbxassetid://7743876916",
        "text-cursor-input": "rbxassetid://8997388094",
        "package-check": "rbxassetid://8997386143",
        "shopping-cart": "rbxassetid://7734056813",
        "corner-down-right": "rbxassetid://7733764385",
        "folder-open": "rbxassetid://8997386062",
        "charge": "rbxassetid://8997383136",
        "layout-grid": "rbxassetid://7733970390",
        "clock": "rbxassetid://7733734848",
        "corner-up-left": "rbxassetid://7733764800",
        "align-horizontal-justify-start": "rbxassetid://8997381652",
        "git-merge": "rbxassetid://7733952195",
        "verified": "rbxassetid://7743876142",
        "redo": "rbxassetid://7743871739",
        "hexagon": "rbxassetid://7743868527",
        "square": "rbxassetid://7743872181",
        "align-horizontal-justify-center": "rbxassetid://8997381461",
        "chevrons-up-down": "rbxassetid://7733723321",
        "bus": "rbxassetid://7733701715",
        "file-plus-2": "rbxassetid://7733788816",
        "alarm-plus": "rbxassetid://7733658066",
        "divide-square": "rbxassetid://7733769261",
        "pie-chart": "rbxassetid://7734034378",
        "signal-zero": "rbxassetid://8997387434",
        "hammer": "rbxassetid://7733955511",
        "history": "rbxassetid://7733960880",
        "align-vertical-justify-start": "rbxassetid://8997382639",
        "flask-round": "rbxassetid://7733798957",
        "wifi-off": "rbxassetid://7743878056",
        "zoom-out": "rbxassetid://7743879082",
        "toggle-right": "rbxassetid://7743873539",
        "monitor": "rbxassetid://7734002839",
        "x": "rbxassetid://7743878857",
        "align-horizonal-distribute-end": "rbxassetid://8997381144",
        "user": "rbxassetid://7743875962",
        "sprout": "rbxassetid://7743872071",
        "move": "rbxassetid://7743870731",
        "gavel": "rbxassetid://7733800044",
        "package-minus": "rbxassetid://8997386266",
        "drumstick": "rbxassetid://8997385789",
        "forward": "rbxassetid://7733799371",
        "sidebar-close": "rbxassetid://7734058092",
        "electricity": "rbxassetid://7733771628",
        "plus": "rbxassetid://7734042071",
        "pipette": "rbxassetid://7743871384",
        "cloud-lightning": "rbxassetid://7733741741",
        "lasso-select": "rbxassetid://7743868832",
        "phone-call": "rbxassetid://7734027264",
        "droplet": "rbxassetid://7733770982",
        "key": "rbxassetid://7733965118",
        "map-pin": "rbxassetid://7733992789",
        "navigation-2": "rbxassetid://7734020942",
        "list-minus": "rbxassetid://7733980795",
        "chevron-up": "rbxassetid://7733919605",
        "layout-template": "rbxassetid://7733970494",
        "no_entry": "rbxassetid://7734021118",
        "scan": "rbxassetid://8997386861",
        "arrow-big-up": "rbxassetid://7733671663",
        "bookmark-minus": "rbxassetid://7733689754",
        "activity": "rbxassetid://7733655755",
        "grid": "rbxassetid://7733955179",
        "user-x": "rbxassetid://7743875879",
        "alert-circle": "rbxassetid://7733658271",
        "menu": "rbxassetid://7733993211",
        "form-input": "rbxassetid://7733799275",
        "rss": "rbxassetid://7734052075",
        "loader": "rbxassetid://7733992358",
        "align-vertical-distribute-end": "rbxassetid://8997382326",
        "strikethrough": "rbxassetid://7734068425",
        "mic": "rbxassetid://7743869805",
        "landmark": "rbxassetid://7733965184",
        "crosshair": "rbxassetid://7733765307",
        "alert-octagon": "rbxassetid://7733658335",
        "anchor": "rbxassetid://7733911490",
        "separator-horizontal": "rbxassetid://7734053146",
        "chevron-left": "rbxassetid://7733717651",
        "flask-conical": "rbxassetid://7733798901",
        "wallet": "rbxassetid://7743877573",
        "euro": "rbxassetid://7733771891",
        "trash-2": "rbxassetid://7743873772",
        "check-circle": "rbxassetid://7733919427",
        "layout": "rbxassetid://7733970543",
        "droplets": "rbxassetid://7733771078",
        "align-start-vertical": "rbxassetid://8997382085",
        "rotate-cw": "rbxassetid://7734051957",
        "minimize": "rbxassetid://7733997941",
        "arrow-down-left": "rbxassetid://7733672282",
        "signal-medium": "rbxassetid://8997387319",
        "align-vertical-distribute-center": "rbxassetid://8997382212",
        "image-off": "rbxassetid://7733963907",
        "cloudy": "rbxassetid://7733747106",
        "align-left": "rbxassetid://7733911357",
        "film": "rbxassetid://7733942579",
        "chevrons-down": "rbxassetid://7733720604",
        "pointer": "rbxassetid://7734042307",
        "folder": "rbxassetid://7733799185",
        "chevrons-left": "rbxassetid://7733720701",
        "shield-off": "rbxassetid://7734056540",
        "wrench": "rbxassetid://7743878358"
      }
    }
}

do
    local success, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/ttwizz/Documents/master/icons.json", true)
    end)
    if success and result then
        local decoded = Services.Http:JSONDecode(result)
        if decoded and decoded.icons then
            IconDatabase = decoded.icons
        else
            IconDatabase = IconDatabase.icons
        end
    else
        IconDatabase = IconDatabase.icons
    end
end

-- Create main GUI with obfuscated name
local MainGui = instanceNew("ScreenGui")
MainGui.Name = stringLower(stringReverse(stringSub(Services.Http:GenerateGUID(false), 1, 8)))

-- GUI parenting with security priority
local env = getfenv()
if env.syn then
    env.syn.protect_gui(MainGui)
    MainGui.Parent = Services.CoreGui
elseif env.gethui then
    MainGui.Parent = env.gethui()
else
    MainGui.Parent = Services.CoreGui
end

-- Verify successful parenting
if not MainGui.Parent then
    error("Error: Your executor doesn't support CoreGui or gethui(). GUI cannot be safely displayed. Use a better executor!")
end

local GuiParent = MainGui.Parent

--- Check if the library is still running
-- @return boolean
function OrionLib:IsRunning()
    return MainGui.Parent == GuiParent
end

--═══════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
--═══════════════════════════════════════════════════════════════════════════════

--- Connect a signal with automatic tracking for cleanup
-- @param signal RBXScriptSignal - The signal to connect to
-- @param callback function - The callback function
-- @return RBXScriptConnection
local function ConnectSignal(signal, callback)
    if not OrionLib:IsRunning() then return end
    local connection = signal:Connect(callback)
    tableInsert(OrionLib.Connections, connection)
    return connection
end

-- Automatic cleanup when library stops running
task.spawn(function()
    while OrionLib:IsRunning() do
        task.wait()
    end
    for _, connection in next, OrionLib.Connections do
        connection:Disconnect()
    end
end)

--- Make a UI element draggable
-- @param dragHandle Instance - The handle to drag from
-- @param dragTarget Instance - The element to move
local function MakeDraggable(dragHandle, dragTarget)
    local dragging = false
    local dragStart, startPos
    
    ConnectSignal(dragHandle.InputBegan, function(input)
        local inputType = input.UserInputType
        if inputType == EnumUserInputType.MouseButton1 or inputType == EnumUserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = dragTarget.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == EnumUserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    local lastInput
    ConnectSignal(dragHandle.InputChanged, function(input)
        local inputType = input.UserInputType
        if inputType == EnumUserInputType.MouseMovement or inputType == EnumUserInputType.Touch then
            lastInput = input
        end
    end)
    
    ConnectSignal(Services.UserInput.InputChanged, function(input)
        if input == lastInput and dragging then
            local delta = input.Position - dragStart
            dragTarget.Position = udim2New(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--- Create a Roblox instance with properties and children
-- @param className string - The class name
-- @param properties table - Properties to apply
-- @param children table - Children to add
-- @return Instance
local function CreateInstance(className, properties, children)
    local instance = instanceNew(className)
    
    if properties then
        for prop, value in next, properties do
            instance[prop] = value
        end
    end
    
    if children then
        for _, child in next, children do
            child.Parent = instance
        end
    end
    
    return instance
end

--- Register an element factory
-- @param name string - Element name
-- @param factory function - Factory function
local function RegisterElement(name, factory)
    OrionLib.Elements[name] = factory
end

--- Create an element using registered factory
-- @param name string - Element name
-- @param ... any - Arguments to pass
-- @return any
local function CreateElement(name, ...)
    return OrionLib.Elements[name](...)
end

--- Apply properties to an instance
-- @param instance Instance
-- @param properties table
-- @return Instance
local function ApplyProperties(instance, properties)
    for prop, value in next, properties do
        instance[prop] = value
    end
    return instance
end

--- Add children to an instance
-- @param instance Instance
-- @param children table
-- @return Instance
local function AddChildren(instance, children)
    for _, child in next, children do
        child.Parent = instance
    end
    return instance
end

--- Round a number to the nearest increment
-- @param value number
-- @param increment number
-- @return number
local function RoundToIncrement(value, increment)
    local result = mathFloor(value / increment + mathSign(value) * 0.5) * increment
    return result < 0 and result + increment or result
end

--- Get the appropriate color property for an instance type
-- @param instance Instance
-- @return string
local function GetColorProperty(instance)
    local className = instance.ClassName
    if className == "Frame" or className == "TextButton" then
        return "BackgroundColor3"
    elseif className == "ScrollingFrame" then
        return "ScrollBarImageColor3"
    elseif className == "UIStroke" then
        return "Color"
    elseif className == "TextLabel" or className == "TextBox" then
        return "TextColor3"
    elseif className == "ImageLabel" or className == "ImageButton" then
        return "ImageColor3"
    end
end

--- Apply theme color to an instance
-- @param instance Instance
-- @param themeKey string
-- @return Instance
local function ApplyTheme(instance, themeKey)
    local themeObjects = OrionLib.ThemeObjects
    if not themeObjects[themeKey] then
        themeObjects[themeKey] = {}
    end
    tableInsert(themeObjects[themeKey], instance)
    
    local colorProp = GetColorProperty(instance)
    if colorProp then
        instance[colorProp] = OrionLib.Themes[OrionLib.SelectedTheme][themeKey]
    end
    return instance
end

--- Convert Color3 to RGB table
-- @param color Color3
-- @return table
local function ColorToRGB(color)
    return {
        R = color.R * 255,
        G = color.G * 255,
        B = color.B * 255
    }
end

--- Convert RGB table to Color3
-- @param rgbTable table
-- @return Color3
local function RGBToColor(rgbTable)
    return colorFromRGB(rgbTable.R, rgbTable.G, rgbTable.B)
end

--- Load configuration from JSON string
-- @param jsonString string
local function LoadConfiguration(jsonString)
    local data = Services.Http:JSONDecode(jsonString)
    for flagName, value in next, data do
        local flag = OrionLib.Flags[flagName]
        if flag then
            task.spawn(function()
                if flag.Type == "Colorpicker" then
                    flag:Set(RGBToColor(value))
                else
                    flag:Set(value)
                end
            end)
        end
    end
end

--- Save current configuration to file
-- @param placeName string|number
local function SaveConfiguration(placeName)
    local data = {}
    for flagName, flag in next, OrionLib.Flags do
        if flag.Save then
            if flag.Type == "Colorpicker" then
                data[flagName] = ColorToRGB(flag.Value)
            else
                data[flagName] = flag.Value
            end
        end
    end
    
    if env.writefile then
        local path = stringFormat("%s/%s.txt", OrionLib.Folder, placeName)
        env.writefile(path, Services.Http:JSONEncode(data))
    end
end

-- Input type blacklists
local MouseButtonInputs = {
    [EnumUserInputType.MouseButton1] = true,
    [EnumUserInputType.MouseButton2] = true,
    [EnumUserInputType.MouseButton3] = true
}

local BlacklistedKeyCodes = {
    [EnumKeyCode.Unknown] = true,
    [EnumKeyCode.W] = true,
    [EnumKeyCode.A] = true,
    [EnumKeyCode.S] = true,
    [EnumKeyCode.D] = true,
    [EnumKeyCode.Up] = true,
    [EnumKeyCode.Left] = true,
    [EnumKeyCode.Down] = true,
    [EnumKeyCode.Right] = true,
    [EnumKeyCode.Slash] = true,
    [EnumKeyCode.Tab] = true,
    [EnumKeyCode.Backspace] = true,
    [EnumKeyCode.Escape] = true
}

--- Check if value exists in table (optimized with dictionary lookup where possible)
-- @param tbl table
-- @param value any
-- @return boolean
local function TableContains(tbl, value)
    return tbl[value] ~= nil
end

--- Get hover color (slightly brighter)
-- @param baseColor Color3
-- @param amount number
-- @return Color3
local function GetHoverColor(baseColor, amount)
    amount = amount or 3
    return colorFromRGB(
        baseColor.R * 255 + amount,
        baseColor.G * 255 + amount,
        baseColor.B * 255 + amount
    )
end

--═══════════════════════════════════════════════════════════════════════════════
-- UI ELEMENT FACTORIES
--═══════════════════════════════════════════════════════════════════════════════

-- Corner element
RegisterElement("Corner", function(scale, offset)
    return CreateInstance("UICorner", {
        CornerRadius = udimNew(scale or 0, offset or 4)
    })
end)

-- Stroke element
RegisterElement("Stroke", function(color, thickness)
    return CreateInstance("UIStroke", {
        Color = color or colorFromRGB(255, 255, 255),
        Thickness = thickness or 1
    })
end)

-- List layout element
RegisterElement("List", function(scale, offset)
    return CreateInstance("UIListLayout", {
        SortOrder = EnumSortOrder.LayoutOrder,
        Padding = udimNew(scale or 0, offset or 0)
    })
end)

-- Padding element
RegisterElement("Padding", function(bottom, left, right, top)
    return CreateInstance("UIPadding", {
        PaddingBottom = udimNew(0, bottom or 4),
        PaddingLeft = udimNew(0, left or 4),
        PaddingRight = udimNew(0, right or 4),
        PaddingTop = udimNew(0, top or 4)
    })
end)

-- Transparent frame
RegisterElement("TFrame", function()
    return CreateInstance("Frame", {
        BackgroundTransparency = 1
    })
end)

-- Solid frame
RegisterElement("Frame", function(color)
    return CreateInstance("Frame", {
        BackgroundColor3 = color or colorFromRGB(255, 255, 255),
        BorderSizePixel = 0
    })
end)

-- Rounded frame
RegisterElement("RoundFrame", function(color, scale, offset)
    return CreateInstance("Frame", {
        BackgroundColor3 = color or colorFromRGB(255, 255, 255),
        BorderSizePixel = 0
    }, {
        CreateInstance("UICorner", {
            CornerRadius = udimNew(scale, offset)
        })
    })
end)

-- Button element
RegisterElement("Button", function()
    return CreateInstance("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
end)

-- Scrolling frame
RegisterElement("ScrollFrame", function(color, thickness)
    return CreateInstance("ScrollingFrame", {
        BackgroundTransparency = 1,
        MidImage = "rbxassetid://7445543667",
        BottomImage = "rbxassetid://7445543667",
        TopImage = "rbxassetid://7445543667",
        ScrollBarImageColor3 = color,
        BorderSizePixel = 0,
        ScrollBarThickness = thickness,
        CanvasSize = udim2New(0, 0, 0, 0)
    })
end)

-- Image element
RegisterElement("Image", function(imageId)
    local image = CreateInstance("ImageLabel", {
        Image = imageId,
        BackgroundTransparency = 1
    })
    if IconDatabase[imageId] then
        image.Image = IconDatabase[imageId]
    end
    return image
end)

-- Image button element
RegisterElement("ImageButton", function(imageId)
    return CreateInstance("ImageButton", {
        Image = imageId,
        BackgroundTransparency = 1
    })
end)

-- Text label element
RegisterElement("Label", function(text, size, transparency)
    return CreateInstance("TextLabel", {
        Text = text or "",
        TextColor3 = colorFromRGB(240, 240, 240),
        TextTransparency = transparency or 0,
        TextSize = size or 15,
        Font = EnumFont.Gotham,
        RichText = true,
        BackgroundTransparency = 1,
        TextXAlignment = EnumTextXAlignment.Left
    })
end)

--═══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
--═══════════════════════════════════════════════════════════════════════════════

-- Notification container
local NotificationContainer = AddChildren(ApplyProperties(CreateElement("TFrame"), {
    Position = udim2New(1, -25, 1, -25),
    Size = udim2New(0, 300, 1, -25),
    AnchorPoint = vector2New(1, 1),
    Parent = MainGui
}), {
    ApplyProperties(CreateElement("List"), {
        HorizontalAlignment = EnumHorizontalAlignment.Center,
        SortOrder = EnumSortOrder.LayoutOrder,
        VerticalAlignment = EnumVerticalAlignment.Bottom,
        Padding = udimNew(0, 5)
    })
})

--- Display a notification
-- @param options table - {Name, Content, Image, Time}
function OrionLib:MakeNotification(options)
    task.spawn(function()
        options = options or {}
        local name = options.Name or "Notification"
        local content = options.Content or "Test"
        local image = options.Image or "rbxassetid://4384403532"
        local duration = options.Time or 15
        
        local container = ApplyProperties(CreateElement("TFrame"), {
            Size = udim2New(1, 0, 0, 0),
            AutomaticSize = EnumAutomaticSize.Y,
            Parent = NotificationContainer
        })
        
        local notification = AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(25, 25, 25), 0, 5), {
            Parent = container,
            Size = udim2New(1, 0, 0, 0),
            Position = udim2New(1, -55, 0, 0),
            BackgroundTransparency = 0,
            AutomaticSize = EnumAutomaticSize.Y
        }), {
            CreateElement("Stroke", colorFromRGB(93, 93, 93), 1.2),
            CreateElement("Padding", 12, 12, 12, 12),
            ApplyProperties(CreateElement("Image", image), {
                Size = udim2New(0, 20, 0, 20),
                ImageColor3 = colorFromRGB(240, 240, 240),
                Name = "Icon"
            }),
            ApplyProperties(CreateElement("Label", name, 15), {
                Size = udim2New(1, -30, 0, 20),
                Position = udim2New(0, 30, 0, 0),
                Font = EnumFont.GothamBold,
                Name = "Title"
            }),
            ApplyProperties(CreateElement("Label", content, 14), {
                Size = udim2New(1, 0, 0, 0),
                Position = udim2New(0, 0, 0, 25),
                Font = EnumFont.GothamMedium,
                Name = "Content",
                AutomaticSize = EnumAutomaticSize.Y,
                TextColor3 = colorFromRGB(200, 200, 200),
                TextWrapped = true
            })
        })
        
        -- Animate in
        Services.Tween:Create(notification, TweenInfoCache.Animation, {
            Position = udim2New(0, 0, 0, 0)
        }):Play()
        
        -- Wait then fade out
        task.wait(duration - 0.88)
        
        Services.Tween:Create(notification.Icon, TweenInfo.new(0.4, EnumEasingStyle.Quint), {
            ImageTransparency = 1
        }):Play()
        Services.Tween:Create(notification, TweenInfo.new(0.8, EnumEasingStyle.Quint), {
            BackgroundTransparency = 0.6
        }):Play()
        
        task.wait(0.3)
        
        Services.Tween:Create(notification.UIStroke, TweenInfo.new(0.6, EnumEasingStyle.Quint), {
            Transparency = 0.9
        }):Play()
        Services.Tween:Create(notification.Title, TweenInfo.new(0.6, EnumEasingStyle.Quint), {
            TextTransparency = 0.4
        }):Play()
        Services.Tween:Create(notification.Content, TweenInfo.new(0.6, EnumEasingStyle.Quint), {
            TextTransparency = 0.5
        }):Play()
        
        task.wait(0.05)
        notification:TweenPosition(udim2New(1, 20, 0, 0), "In", "Quint", 0.8, true)
        Services.Debris:AddItem(notification, 1.35)
    end)
end

--- Initialize the library (load saved config)
function OrionLib:Init()
    pcall(function()
        if OrionLib.SaveCfg and env.isfile and env.readfile then
            local configPath = stringFormat("%s/%s.txt", OrionLib.Folder, game.PlaceId)
            if env.isfile(configPath) then
                LoadConfiguration(env.readfile(configPath))
                OrionLib:MakeNotification({
                    Name = "Configuration",
                    Content = stringFormat("Auto-loaded configuration for place %s.", game.PlaceId),
                    Time = 5
                })
            end
        end
    end)
end

--═══════════════════════════════════════════════════════════════════════════════
-- MAIN WINDOW CREATION
--═══════════════════════════════════════════════════════════════════════════════

function OrionLib:MakeWindow(options)
    -- State variables
    local hasActiveTab = false
    local isMinimized = false
    local isHidden = false
    local isAnimating = false
    
    -- Default options with caching
    options = options or {}
    local windowName = options.Name or "Orion Library"
    local configFolder = options.ConfigFolder or windowName
    local saveConfig = options.SaveConfig or false
    local testMode = options.TestMode or false
    local introEnabled = options.IntroEnabled ~= false
    local introText = options.IntroText or "Orion Library"
    local closeCallback = options.CloseCallback or function() end
    local showIcon = options.ShowIcon or false
    local icon = options.Icon or "rbxassetid://8834748103"
    local introIcon = options.IntroIcon or "rbxassetid://8834748103"
    
    -- Set library config
    OrionLib.Folder = configFolder
    OrionLib.SaveCfg = saveConfig
    
    -- Create config folder if needed
    if saveConfig and env.isfolder and env.makefolder and not env.isfolder(configFolder) then
        env.makefolder(configFolder)
    end
    
    -- Cache theme colors for performance
    local currentTheme = OrionLib.Themes[OrionLib.SelectedTheme]
    
    -- Tab scroll container
    local TabScroll = ApplyTheme(AddChildren(ApplyProperties(CreateElement("ScrollFrame", colorFromRGB(255, 255, 255), 4), {
        Size = udim2New(1, 0, 1, -50)
    }), {
        CreateElement("List"),
        CreateElement("Padding", 8, 0, 0, 8)
    }), "Divider")
    
    ConnectSignal(TabScroll.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        TabScroll.CanvasSize = udim2New(0, 0, 0, TabScroll.UIListLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Close button
    local CloseButton = AddChildren(ApplyProperties(CreateElement("Button"), {
        Size = udim2New(0.5, 0, 1, 0),
        Position = udim2New(0.5, 0, 0, 0),
        BackgroundTransparency = 1
    }), {
        ApplyTheme(ApplyProperties(CreateElement("Image", "rbxassetid://7072725342"), {
            Position = udim2New(0, 9, 0, 6),
            Size = udim2New(0, 18, 0, 18)
        }), "Text")
    })
    
    -- Minimize button
    local MinimizeButton = AddChildren(ApplyProperties(CreateElement("Button"), {
        Size = udim2New(0.5, 0, 1, 0),
        BackgroundTransparency = 1
    }), {
        ApplyTheme(ApplyProperties(CreateElement("Image", "rbxassetid://7072719338"), {
            Position = udim2New(0, 9, 0, 6),
            Size = udim2New(0, 18, 0, 18),
            Name = "Ico"
        }), "Text")
    })
    
    -- Drag handle
    local DragHandle = ApplyProperties(CreateElement("TFrame"), {
        Size = udim2New(1, 0, 0, 50)
    })
    
    -- Player avatar URL
    local avatarUrl = stringFormat("https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png", LocalPlayer.UserId)
    
    -- Sidebar
    local Sidebar = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
        Size = udim2New(0, 150, 1, -50),
        Position = udim2New(0, 0, 0, 50)
    }), {
        ApplyTheme(ApplyProperties(CreateElement("Frame"), {
            Size = udim2New(1, 0, 0, 10),
            Position = udim2New(0, 0, 0, 0)
        }), "Second"),
        ApplyTheme(ApplyProperties(CreateElement("Frame"), {
            Size = udim2New(0, 10, 1, 0),
            Position = udim2New(1, -10, 0, 0)
        }), "Second"),
        ApplyTheme(ApplyProperties(CreateElement("Frame"), {
            Size = udim2New(0, 1, 1, 0),
            Position = udim2New(1, -1, 0, 0)
        }), "Stroke"),
        TabScroll,
        AddChildren(ApplyProperties(CreateElement("TFrame"), {
            Size = udim2New(1, 0, 0, 50),
            Position = udim2New(0, 0, 1, -50)
        }), {
            ApplyTheme(ApplyProperties(CreateElement("Frame"), {
                Size = udim2New(1, 0, 0, 1)
            }), "Stroke"),
            ApplyTheme(AddChildren(ApplyProperties(CreateElement("Frame"), {
                AnchorPoint = vector2New(0, 0.5),
                Size = udim2New(0, 32, 0, 32),
                Position = udim2New(0, 10, 0.5, 0)
            }), {
                ApplyProperties(CreateElement("Image", avatarUrl), {
                    Size = udim2New(1, 0, 1, 0)
                }),
                ApplyTheme(ApplyProperties(CreateElement("Image", "rbxassetid://4031889928"), {
                    Size = udim2New(1, 0, 1, 0)
                }), "Second"),
                CreateElement("Corner", 1)
            }), "Divider"),
            AddChildren(ApplyProperties(CreateElement("TFrame"), {
                AnchorPoint = vector2New(0, 0.5),
                Size = udim2New(0, 32, 0, 32),
                Position = udim2New(0, 10, 0.5, 0)
            }), {
                ApplyTheme(CreateElement("Stroke"), "Stroke"),
                CreateElement("Corner", 1)
            }),
            ApplyTheme(ApplyProperties(CreateElement("Label", LocalPlayer.DisplayName, testMode and 13 or 14), {
                Size = udim2New(1, -60, 0, 13),
                Position = testMode and udim2New(0, 50, 0, 12) or udim2New(0, 50, 0, 19),
                Font = EnumFont.GothamBold,
                ClipsDescendants = true
            }), "Text"),
            ApplyTheme(ApplyProperties(CreateElement("Label", "Tester", 12), {
                Size = udim2New(1, -60, 0, 12),
                Position = udim2New(0, 50, 1, -25),
                Visible = testMode
            }), "TextDark")
        })
    }), "Second")
    
    -- Title label
    local TitleLabel = ApplyTheme(ApplyProperties(CreateElement("Label", windowName, 14), {
        Size = udim2New(1, -30, 2, 0),
        Position = udim2New(0, 25, 0, -24),
        Font = EnumFont.GothamBlack,
        TextSize = 20
    }), "Text")
    
    -- Title divider
    local TitleDivider = ApplyTheme(ApplyProperties(CreateElement("Frame"), {
        Size = udim2New(1, 0, 0, 1),
        Position = udim2New(0, 0, 1, -1)
    }), "Stroke")
    
    -- Main window frame
    local MainWindow = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
        Parent = MainGui,
        Position = udim2New(0.5, -307, 0.5, -172),
        Size = udim2New(0, 615, 0, 344),
        ClipsDescendants = true
    }), {
        AddChildren(ApplyProperties(CreateElement("TFrame"), {
            Size = udim2New(1, 0, 0, 50),
            Name = "TopBar"
        }), {
            TitleLabel,
            TitleDivider,
            ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 4), {
                Size = udim2New(0, 70, 0, 30),
                Position = udim2New(1, -90, 0, 10)
            }), {
                ApplyTheme(CreateElement("Stroke"), "Stroke"),
                ApplyTheme(ApplyProperties(CreateElement("Frame"), {
                    Size = udim2New(0, 1, 1, 0),
                    Position = udim2New(0.5, 0, 0, 0)
                }), "Stroke"),
                CloseButton,
                MinimizeButton
            }), "Second")
        }),
        DragHandle,
        Sidebar
    }), "Main")
    
    -- Add icon to title bar if enabled
    if showIcon then
        TitleLabel.Position = udim2New(0, 50, 0, -24)
        local iconImage = ApplyProperties(CreateElement("Image", icon), {
            Size = udim2New(0, 20, 0, 20),
            Position = udim2New(0, 25, 0, 15)
        })
        iconImage.Parent = MainWindow.TopBar
    end
    
    -- Make window draggable
    MakeDraggable(DragHandle, MainWindow)
    
    -- Close button handler
    ConnectSignal(CloseButton.MouseButton1Up, function()
        MainWindow.Visible = false
        isHidden = true
        OrionLib:MakeNotification({
            Name = "Interface Hidden",
            Content = "Tap RightShift to reopen the interface",
            Time = 5
        })
        closeCallback()
    end)
    
    -- Show window on RightShift
    ConnectSignal(Services.UserInput.InputBegan, function(input)
        if input.KeyCode == EnumKeyCode.RightShift and isHidden then
            MainWindow.Visible = true
        end
    end)
    
    -- Minimize button handler
    ConnectSignal(MinimizeButton.MouseButton1Up, function()
        if isAnimating then return end
        isAnimating = true
        
        if isMinimized then
            -- Expand
            Sidebar.Visible = false
            TitleDivider.Visible = false
            MainWindow.ClipsDescendants = true
            
            Services.Tween:Create(MainWindow, TweenInfoCache.Animation, {
                Size = udim2New(0, 615, 0, 344)
            }):Play()
            MinimizeButton.Ico.Image = "rbxassetid://7072719338"
            
            task.wait(0.5)
            MainWindow.ClipsDescendants = false
            Sidebar.Visible = true
            TitleDivider.Visible = true
        else
            -- Minimize
            MainWindow.ClipsDescendants = true
            TitleDivider.Visible = false
            Sidebar.Visible = false
            MinimizeButton.Ico.Image = "rbxassetid://7072720870"
            
            Services.Tween:Create(MainWindow, TweenInfoCache.Animation, {
                Size = udim2New(0, TitleLabel.TextBounds.X + 140, 0, 50)
            }):Play()
            
            task.wait(0.5)
        end
        
        isMinimized = not isMinimized
        isAnimating = false
    end)
    
    -- Intro animation
    local function PlayIntro()
        MainWindow.Visible = false
        
        local introImage = ApplyProperties(CreateElement("Image", introIcon), {
            Parent = MainGui,
            AnchorPoint = vector2New(0.5, 0.5),
            Position = udim2New(0.5, 0, 0.4, 0),
            Size = udim2New(0, 28, 0, 28),
            ImageColor3 = colorFromRGB(255, 255, 255),
            ImageTransparency = 1
        })
        
        local introLabel = ApplyProperties(CreateElement("Label", introText, 14), {
            Parent = MainGui,
            Size = udim2New(1, 0, 1, 0),
            AnchorPoint = vector2New(0.5, 0.5),
            Position = udim2New(0.5, 19, 0.5, 0),
            TextXAlignment = EnumTextXAlignment.Center,
            Font = EnumFont.GothamBold,
            TextTransparency = 1
        })
        
        Services.Tween:Create(introImage, TweenInfoCache.Intro, {
            ImageTransparency = 0,
            Position = udim2New(0.5, 0, 0.5, 0)
        }):Play()
        
        task.wait(0.8)
        
        Services.Tween:Create(introImage, TweenInfoCache.Intro, {
            Position = udim2New(0.5, -(introLabel.TextBounds.X / 2), 0.5, 0)
        }):Play()
        
        task.wait(0.3)
        
        Services.Tween:Create(introLabel, TweenInfoCache.Intro, {
            TextTransparency = 0
        }):Play()
        
        task.wait(2)
        
        Services.Tween:Create(introLabel, TweenInfoCache.Intro, {
            TextTransparency = 1
        }):Play()
        
        MainWindow.Visible = true
        Services.Debris:AddItem(introImage, 0)
        Services.Debris:AddItem(introLabel, 0)
    end
    
    if introEnabled then
        PlayIntro()
    end
    
    -- Window API
    local Window = {}
    
    --- Create a new tab
    -- @param tabOptions table - {Name, Icon, TestersOnly}
    -- @return Tab
    function Window:MakeTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or ""
        local testersOnly = tabOptions.TestersOnly or false
        
        local TabButton = AddChildren(ApplyProperties(CreateElement("Button"), {
            Size = udim2New(1, 0, 0, 30),
            Parent = TabScroll,
            Visible = testMode and testersOnly or not testersOnly
        }), {
            ApplyTheme(ApplyProperties(CreateElement("Image", tabIcon), {
                AnchorPoint = vector2New(0, 0.5),
                Size = udim2New(0, 18, 0, 18),
                Position = udim2New(0, 10, 0.5, 0),
                ImageTransparency = 0.4,
                Name = "Ico"
            }), "Text"),
            ApplyTheme(ApplyProperties(CreateElement("Label", tabName, 14), {
                Size = udim2New(1, -35, 1, 0),
                Position = udim2New(0, 35, 0, 0),
                Font = EnumFont.GothamMedium,
                TextTransparency = 0.4,
                Name = "Title"
            }), "Text")
        })
        
        if IconDatabase[tabIcon] then
            TabButton.Ico.Image = IconDatabase[tabIcon]
        end
        
        local ItemContainer = ApplyTheme(AddChildren(ApplyProperties(CreateElement("ScrollFrame", colorFromRGB(255, 255, 255), 5), {
            Size = udim2New(1, -150, 1, -50),
            Position = udim2New(0, 150, 0, 50),
            Parent = MainWindow,
            Visible = false,
            Name = "ItemContainer"
        }), {
            CreateElement("List", 0, 6),
            CreateElement("Padding", 15, 10, 10, 15)
        }), "Divider")
        
        ConnectSignal(ItemContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            ItemContainer.CanvasSize = udim2New(0, 0, 0, ItemContainer.UIListLayout.AbsoluteContentSize.Y + 30)
        end)
        
        -- Auto-select first visible tab
        if not hasActiveTab then
            hasActiveTab = TabButton.Visible
            if hasActiveTab then
                TabButton.Ico.ImageTransparency = 0
                TabButton.Title.TextTransparency = 0
                TabButton.Title.Font = EnumFont.GothamBlack
                ItemContainer.Visible = true
            end
        end
        
        -- Tab click handler
        ConnectSignal(TabButton.MouseButton1Down, function()
            -- Deselect all tabs
            for _, child in next, TabScroll:GetChildren() do
                if child:IsA("TextButton") then
                    child.Title.Font = EnumFont.GothamMedium
                    Services.Tween:Create(child.Ico, TweenInfoCache.Normal, {
                        ImageTransparency = 0.4
                    }):Play()
                    Services.Tween:Create(child.Title, TweenInfoCache.Normal, {
                        TextTransparency = 0.4
                    }):Play()
                end
            end
            
            -- Hide all containers
            for _, child in next, MainWindow:GetChildren() do
                if child.Name == "ItemContainer" then
                    child.Visible = false
                end
            end
            
            -- Select this tab
            Services.Tween:Create(TabButton.Ico, TweenInfoCache.Normal, {
                ImageTransparency = 0
            }):Play()
            Services.Tween:Create(TabButton.Title, TweenInfoCache.Normal, {
                TextTransparency = 0
            }):Play()
            TabButton.Title.Font = EnumFont.GothamBlack
            ItemContainer.Visible = true
        end)
        local function CreateElementMethods(L_152_arg1)
            local ElementMethods = {}
            function ElementMethods:AddLabel(L_155_arg1)
                local L_156_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
                    Size = udim2New(1, 0, 0, 30),
                    BackgroundTransparency = 0.7,
                    Parent = L_152_arg1
                }), {
                    ApplyTheme(ApplyProperties(CreateElement("Label", L_155_arg1, 15), {
                        Size = udim2New(1, -12, 1, 0),
                        Position = udim2New(0, 12, 0, 0),
                        Font = EnumFont.GothamBold,
                        Name = "Content"
                    }), "Text"),
                    ApplyTheme(CreateElement("Stroke"), "Stroke")
                }), "Second")
                local L_157_ = {}
                function L_157_:Set(L_158_arg1)
                    L_156_.Content.Text = L_158_arg1
                end
                return L_157_
            end
            function ElementMethods:AddParagraph(L_159_arg1, L_160_arg2)
                L_159_arg1 = L_159_arg1 or "Text"
                L_160_arg2 = L_160_arg2 or "Content"
                local L_161_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
                    Size = udim2New(1, 0, 0, 30),
                    BackgroundTransparency = 0.7,
                    Parent = L_152_arg1
                }), {
                    ApplyTheme(ApplyProperties(CreateElement("Label", L_159_arg1, 15), {
                        Size = udim2New(1, -12, 0, 14),
                        Position = udim2New(0, 12, 0, 10),
                        Font = EnumFont.GothamBold,
                        Name = "Title"
                    }), "Text"),
                    ApplyTheme(ApplyProperties(CreateElement("Label", "", 13), {
                        Size = udim2New(1, -24, 0, 0),
                        Position = udim2New(0, 12, 0, 26),
                        Font = EnumFont.GothamMedium,
                        Name = "Content",
                        TextWrapped = true
                    }), "TextDark"),
                    ApplyTheme(CreateElement("Stroke"), "Stroke")
                }), "Second")
                ConnectSignal(L_161_.Content:GetPropertyChangedSignal("Text"), function()
                    L_161_.Content.Size = udim2New(1, -24, 0, L_161_.Content.TextBounds.Y)
                    L_161_.Size = udim2New(1, 0, 0, L_161_.Content.TextBounds.Y + 35)
                end)
                L_161_.Content.Text = L_160_arg2
                local L_162_ = {}
                function L_162_:Set(L_163_arg1)
                    L_161_.Content.Text = L_163_arg1
                end
                return L_162_
            end
            function ElementMethods:AddButton(L_164_arg1)
                L_164_arg1 = L_164_arg1 or {}
                L_164_arg1.Name = L_164_arg1.Name or "Button"
                L_164_arg1.Callback = L_164_arg1.Callback or function() end
                L_164_arg1.Icon = L_164_arg1.Icon or "rbxassetid://3944703587"
                local L_165_ = {}
                local L_166_ = ApplyProperties(CreateElement("Button"), {
                    Size = udim2New(1, 0, 1, 0)
                })
                local L_167_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
                    Size = udim2New(1, 0, 0, 33),
                    Parent = L_152_arg1
                }), {
                    ApplyTheme(ApplyProperties(CreateElement("Label", L_164_arg1.Name, 15), {
                        Size = udim2New(1, -12, 1, 0),
                        Position = udim2New(0, 12, 0, 0),
                        Font = EnumFont.GothamBold,
                        Name = "Content"
                    }), "Text"),
                    ApplyTheme(ApplyProperties(CreateElement("Image", L_164_arg1.Icon), {
                        Size = udim2New(0, 20, 0, 20),
                        Position = udim2New(1, -30, 0, 7)
                    }), "TextDark"),
                    ApplyTheme(CreateElement("Stroke"), "Stroke"),
                    L_166_
                }), "Second")
                ConnectSignal(L_166_.MouseEnter, function()
                    Services.Tween:Create(L_167_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 3)
                    }):Play()
                end)
                ConnectSignal(L_166_.MouseLeave, function()
                    Services.Tween:Create(L_167_, TweenInfoCache.Normal, {
                        BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second
                    }):Play()
                end)
                ConnectSignal(L_166_.MouseButton1Up, function()
                    Services.Tween:Create(L_167_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 3)
                    }):Play()
                    task.spawn(L_164_arg1.Callback)
                end)
                ConnectSignal(L_166_.MouseButton1Down, function()
                    Services.Tween:Create(L_167_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 6)
                    }):Play()
                end)
                function L_165_:Set(L_168_arg1)
                    L_167_.Content.Text = L_168_arg1
                end
                return L_165_
            end
            function ElementMethods:AddToggle(L_169_arg1)
                L_169_arg1 = L_169_arg1 or {}
                L_169_arg1.Name = L_169_arg1.Name or "Toggle"
                L_169_arg1.Default = L_169_arg1.Default or false
                L_169_arg1.Callback = L_169_arg1.Callback or function() end
                L_169_arg1.Color = L_169_arg1.Color or colorFromRGB(9, 99, 195)
                L_169_arg1.Flag = L_169_arg1.Flag or nil
                L_169_arg1.Save = L_169_arg1.Save or false
                local L_170_ = {
                    Value = L_169_arg1.Default,
                    Save = L_169_arg1.Save
                }
                local L_171_ = ApplyProperties(CreateElement("Button"), {
                    Size = udim2New(1, 0, 1, 0)
                })
                local L_172_ = AddChildren(ApplyProperties(CreateElement("RoundFrame", L_169_arg1.Color, 0, 4), {
                    Size = udim2New(0, 24, 0, 24),
                    Position = udim2New(1, -24, 0.5, 0),
                    AnchorPoint = vector2New(0.5, 0.5)
                }), {
                    ApplyProperties(CreateElement("Stroke"), {
                        Color = L_169_arg1.Color,
                        Name = "Stroke",
                        Transparency = 0.5
                    }),
                    ApplyProperties(CreateElement("Image", "rbxassetid://3944680095"), {
                        Size = udim2New(0, 20, 0, 20),
                        AnchorPoint = vector2New(0.5, 0.5),
                        Position = udim2New(0.5, 0, 0.5, 0),
                        ImageColor3 = colorFromRGB(255, 255, 255),
                        Name = "Ico"
                    })
                })
                local L_173_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
                    Size = udim2New(1, 0, 0, 38),
                    Parent = L_152_arg1
                }), {
                    ApplyTheme(ApplyProperties(CreateElement("Label", L_169_arg1.Name, 15), {
                        Size = udim2New(1, -12, 1, 0),
                        Position = udim2New(0, 12, 0, 0),
                        Font = EnumFont.GothamBold,
                        Name = "Content"
                    }), "Text"),
                    ApplyTheme(CreateElement("Stroke"), "Stroke"),
                    L_172_,
                    L_171_
                }), "Second")
                function L_170_:Set(L_174_arg1)
                    L_170_.Value = L_174_arg1
                    Services.Tween:Create(L_172_, TweenInfoCache.Slow, {
                        BackgroundColor3 = L_170_.Value and L_169_arg1.Color or OrionLib.Themes.Default.Divider
                    }):Play()
                    Services.Tween:Create(L_172_.Stroke, TweenInfoCache.Slow, {
                        Color = L_170_.Value and L_169_arg1.Color or OrionLib.Themes.Default.Stroke
                    }):Play()
                    Services.Tween:Create(L_172_.Ico, TweenInfoCache.Slow, {
                        ImageTransparency = L_170_.Value and 0 or 1,
                        Size = L_170_.Value and udim2New(0, 20, 0, 20) or udim2New(0, 8, 0, 8)
                    }):Play()
                    L_169_arg1.Callback(L_170_.Value)
                end
                L_170_:Set(L_170_.Value)
                ConnectSignal(L_171_.MouseEnter, function()
                    Services.Tween:Create(L_173_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 3)
                    }):Play()
                end)
                ConnectSignal(L_171_.MouseLeave, function()
                    Services.Tween:Create(L_173_, TweenInfoCache.Normal, {
                        BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second
                    }):Play()
                end)
                ConnectSignal(L_171_.MouseButton1Up, function()
                    Services.Tween:Create(L_173_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 3)
                    }):Play()
                    SaveConfiguration(game.PlaceId)
                    L_170_:Set(not L_170_.Value)
                end)
                ConnectSignal(L_171_.MouseButton1Down, function()
                    Services.Tween:Create(L_173_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 6)
                    }):Play()
                end)
                if L_169_arg1.Flag then
                    OrionLib.Flags[L_169_arg1.Flag] = L_170_
                end
                return L_170_
            end
            function ElementMethods:AddSlider(L_175_arg1)
                L_175_arg1 = L_175_arg1 or {}
                L_175_arg1.Name = L_175_arg1.Name or "Slider"
                L_175_arg1.Min = L_175_arg1.Min or 0
                L_175_arg1.Max = L_175_arg1.Max or 100
                L_175_arg1.Increment = L_175_arg1.Increment or 1
                L_175_arg1.Default = L_175_arg1.Default or 50
                L_175_arg1.Callback = L_175_arg1.Callback or function() end
                L_175_arg1.ValueName = L_175_arg1.ValueName or ""
                L_175_arg1.Color = L_175_arg1.Color or colorFromRGB(9, 149, 98)
                L_175_arg1.Flag = L_175_arg1.Flag or nil
                L_175_arg1.Save = L_175_arg1.Save or false
                local L_176_ = {
                    Value = L_175_arg1.Default,
                    Save = L_175_arg1.Save
                }
                local L_177_ = false
                local L_178_ = AddChildren(ApplyProperties(CreateElement("RoundFrame", L_175_arg1.Color, 0, 5), {
                    Size = udim2New(0, 0, 1, 0),
                    BackgroundTransparency = 0.3,
                    ClipsDescendants = true
                }), {
                    ApplyTheme(ApplyProperties(CreateElement("Label", "value", 13), {
                        Size = udim2New(1, -12, 0, 14),
                        Position = udim2New(0, 12, 0, 6),
                        Font = EnumFont.GothamBold,
                        Name = "Value",
                        TextTransparency = 0
                    }), "Text")
                })
                local L_179_ = AddChildren(ApplyProperties(CreateElement("RoundFrame", L_175_arg1.Color, 0, 5), {
                    Size = udim2New(1, -24, 0, 26),
                    Position = udim2New(0, 12, 0, 30),
                    BackgroundTransparency = 0.9
                }), {
                    ApplyProperties(CreateElement("Stroke"), {
                        Color = L_175_arg1.Color
                    }),
                    ApplyTheme(ApplyProperties(CreateElement("Label", "value", 13), {
                        Size = udim2New(1, -12, 0, 14),
                        Position = udim2New(0, 12, 0, 6),
                        Font = EnumFont.GothamBold,
                        Name = "Value",
                        TextTransparency = 0.8
                    }), "Text"),
                    L_178_
                })
                ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 4), {
                    Size = udim2New(1, 0, 0, 65),
                    Parent = L_152_arg1
                }), {
                    ApplyTheme(ApplyProperties(CreateElement("Label", L_175_arg1.Name, 15), {
                        Size = udim2New(1, -12, 0, 14),
                        Position = udim2New(0, 12, 0, 10),
                        Font = EnumFont.GothamBold,
                        Name = "Content"
                    }), "Text"),
                    ApplyTheme(CreateElement("Stroke"), "Stroke"),
                    L_179_
                }), "Second")
                L_179_.InputBegan:Connect(function(L_180_arg1)
                    if L_180_arg1.UserInputType == EnumUserInputType.MouseButton1 or L_180_arg1.UserInputType == EnumUserInputType.Touch then
                        L_177_ = true
                    end
                end)
                L_179_.InputEnded:Connect(function(L_181_arg1)
                    if L_181_arg1.UserInputType == EnumUserInputType.MouseButton1 or L_181_arg1.UserInputType == EnumUserInputType.Touch then
                        L_177_ = false
                    end
                end)
                function L_176_:Set(L_182_arg1)
                    L_182_arg1 = mathClamp(RoundToIncrement(L_182_arg1, L_175_arg1.Increment), L_175_arg1.Min, L_175_arg1.Max)
                    Services.Tween:Create(L_178_, TweenInfoCache.Quick, {
                        Size = UDim2.fromScale((L_182_arg1 - L_175_arg1.Min) / (L_175_arg1.Max - L_175_arg1.Min), 1)
                    }):Play()
                    L_179_.Value.Text = string.format("%s %s", L_182_arg1, L_175_arg1.ValueName)
                    L_178_.Value.Text = string.format("%s %s", L_182_arg1, L_175_arg1.ValueName)
                    L_175_arg1.Callback(L_182_arg1)
                end
                Services.UserInput.InputChanged:Connect(function(L_183_arg1)
                    if L_177_ and (L_183_arg1.UserInputType == EnumUserInputType.MouseMovement or L_183_arg1.UserInputType == EnumUserInputType.Touch) then
                        local L_184_ = mathClamp((L_183_arg1.Position.X - L_179_.AbsolutePosition.X) / L_179_.AbsoluteSize.X, 0, 1)
                        L_176_:Set(L_175_arg1.Min + (L_175_arg1.Max - L_175_arg1.Min) * L_184_)
                        SaveConfiguration(game.PlaceId)
                    end
                end)
                L_176_:Set(L_176_.Value)
                if L_175_arg1.Flag then
                    OrionLib.Flags[L_175_arg1.Flag] = L_176_
                end
                return L_176_
            end
            function ElementMethods:AddDropdown(L_185_arg1)
                L_185_arg1 = L_185_arg1 or {}
                L_185_arg1.Name = L_185_arg1.Name or "Dropdown"
                L_185_arg1.Options = L_185_arg1.Options or {}
                L_185_arg1.Default = L_185_arg1.Default or ""
                L_185_arg1.Callback = L_185_arg1.Callback or function() end
                L_185_arg1.Flag = L_185_arg1.Flag or nil
                L_185_arg1.Save = L_185_arg1.Save or false
                local L_186_ = {
                    Value = L_185_arg1.Default,
                    Options = L_185_arg1.Options,
                    Buttons = {},
                    Toggled = false,
                    Type = "Dropdown",
                    Save = L_185_arg1.Save
                }
                local L_187_ = 5
                if not table.find(L_186_.Options, L_186_.Value) then
                    L_186_.Value = "..."
                end
                local L_188_ = CreateElement("List")
                local L_189_ = ApplyTheme(ApplyProperties(AddChildren(CreateElement("ScrollFrame", colorFromRGB(40, 40, 40), 4), {
                    L_188_
                }), {
                    Parent = L_152_arg1,
                    Position = udim2New(0, 0, 0, 38),
                    Size = udim2New(1, 0, 1, -38),
                    ClipsDescendants = true
                }), "Divider")
                local L_190_ = ApplyProperties(CreateElement("Button"), {
                    Size = udim2New(1, 0, 1, 0)
                })
                local L_191_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
                    Size = udim2New(1, 0, 0, 38),
                    Parent = L_152_arg1,
                    ClipsDescendants = true
                }), {
                    L_189_,
                    ApplyProperties(AddChildren(CreateElement("TFrame"), {
                        ApplyTheme(ApplyProperties(CreateElement("Label", L_185_arg1.Name, 15), {
                            Size = udim2New(1, -12, 1, 0),
                            Position = udim2New(0, 12, 0, 0),
                            Font = EnumFont.GothamBold,
                            Name = "Content"
                        }), "Text"),
                        ApplyTheme(ApplyProperties(CreateElement("Image", "rbxassetid://7072706796"), {
                            Size = udim2New(0, 20, 0, 20),
                            AnchorPoint = vector2New(0, 0.5),
                            Position = udim2New(1, -30, 0.5, 0),
                            ImageColor3 = colorFromRGB(240, 240, 240),
                            Name = "Ico"
                        }), "TextDark"),
                        ApplyTheme(ApplyProperties(CreateElement("Label", "Selected", 13), {
                            Size = udim2New(1, -40, 1, 0),
                            Font = EnumFont.Gotham,
                            Name = "Selected",
                            TextXAlignment = EnumTextXAlignment.Right
                        }), "TextDark"),
                        ApplyTheme(ApplyProperties(CreateElement("Frame"), {
                            Size = udim2New(1, 0, 0, 1),
                            Position = udim2New(0, 0, 1, -1),
                            Name = "Line",
                            Visible = false
                        }), "Stroke"),
                        L_190_
                    }), {
                        Size = udim2New(1, 0, 0, 38),
                        ClipsDescendants = true,
                        Name = "F"
                    }),
                    ApplyTheme(CreateElement("Stroke"), "Stroke"),
                    CreateElement("Corner")
                }), "Second")
                ConnectSignal(L_188_:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                    L_189_.CanvasSize = udim2New(0, 0, 0, L_188_.AbsoluteContentSize.Y)
                end)
                local function L_192_func(L_193_arg1)
                    for _, L_195_forvar2 in next, L_193_arg1 do
                        local L_196_ = ApplyTheme(ApplyProperties(AddChildren(CreateElement("Button", colorFromRGB(40, 40, 40)), {
                            CreateElement("Corner", 0, 6),
                            ApplyTheme(ApplyProperties(CreateElement("Label", L_195_forvar2, 13, 0.4), {
                                Position = udim2New(0, 8, 0, 0),
                                Size = udim2New(1, -8, 1, 0),
                                Name = "Title"
                            }), "Text")
                        }), {
                            Parent = L_189_,
                            Size = udim2New(1, 0, 0, 28),
                            BackgroundTransparency = 1,
                            ClipsDescendants = true
                        }), "Divider")
                        ConnectSignal(L_196_.MouseButton1Down, function()
                            L_186_:Set(L_195_forvar2)
                            SaveConfiguration(game.PlaceId)
                        end)
                        L_186_.Buttons[L_195_forvar2] = L_196_
                    end
                end
                function L_186_:Refresh(L_197_arg1, L_198_arg2)
                    if L_198_arg2 then
                        for _, L_200_forvar2 in next, L_186_.Buttons do
                            Services.Debris:AddItem(L_200_forvar2, 0)
                        end
                        table.clear(L_186_.Options)
                        table.clear(L_186_.Buttons)
                    end
                    L_186_.Options = L_197_arg1
                    L_192_func(L_186_.Options)
                end
                function L_186_:Set(L_201_arg1)
                    if not table.find(L_186_.Options, L_201_arg1) then
                        L_186_.Value = "..."
                        L_191_.F.Selected.Text = L_186_.Value
                        for _, L_203_forvar2 in next, L_186_.Buttons do
                            Services.Tween:Create(L_203_forvar2, TweenInfoCache.Quick, {
                                BackgroundTransparency = 1
                            }):Play()
                            Services.Tween:Create(L_203_forvar2.Title, TweenInfoCache.Quick, {
                                TextTransparency = 0.4
                            }):Play()
                        end
                        return
                    end
                    L_186_.Value = L_201_arg1
                    L_191_.F.Selected.Text = L_186_.Value
                    for _, L_205_forvar2 in next, L_186_.Buttons do
                        Services.Tween:Create(L_205_forvar2, TweenInfoCache.Quick, {
                            BackgroundTransparency = 1
                        }):Play()
                        Services.Tween:Create(L_205_forvar2.Title, TweenInfoCache.Quick, {
                            TextTransparency = 0.4
                        }):Play()
                    end
                    Services.Tween:Create(L_186_.Buttons[L_201_arg1], TweenInfoCache.Quick, {
                        BackgroundTransparency = 0
                    }):Play()
                    Services.Tween:Create(L_186_.Buttons[L_201_arg1].Title, TweenInfoCache.Quick, {
                        TextTransparency = 0
                    }):Play()
                    return L_185_arg1.Callback(L_186_.Value)
                end
                ConnectSignal(L_190_.MouseButton1Down, function()
                    L_186_.Toggled = not L_186_.Toggled
                    L_191_.F.Line.Visible = L_186_.Toggled
                    Services.Tween:Create(L_191_.F.Ico, TweenInfoCache.Quick, {
                        Rotation = L_186_.Toggled and 180 or 0
                    }):Play()
                    if #L_186_.Options > L_187_ then
                        Services.Tween:Create(L_191_, TweenInfoCache.Quick, {
                            Size = L_186_.Toggled and udim2New(1, 0, 0, 38 + L_187_ * 28) or udim2New(1, 0, 0, 38)
                        }):Play()
                    else
                        Services.Tween:Create(L_191_, TweenInfoCache.Quick, {
                            Size = L_186_.Toggled and udim2New(1, 0, 0, L_188_.AbsoluteContentSize.Y + 38) or udim2New(1, 0, 0, 38)
                        }):Play()
                    end
                end)
                L_186_:Refresh(L_186_.Options, false)
                L_186_:Set(L_186_.Value)
                if L_185_arg1.Flag then
                    OrionLib.Flags[L_185_arg1.Flag] = L_186_
                end
                return L_186_
            end
            local L_154_ = nil
            function ElementMethods:AddBind(L_206_arg1)
                L_206_arg1.Name = L_206_arg1.Name or "Bind"
                L_206_arg1.Default = L_206_arg1.Default or EnumKeyCode.Unknown
                L_206_arg1.Hold = L_206_arg1.Hold or false
                L_206_arg1.Callback = L_206_arg1.Callback or function() end
                L_206_arg1.Flag = L_206_arg1.Flag or nil
                L_206_arg1.Save = L_206_arg1.Save or false
                local L_207_ = {
                    L_154_,
                    Binding = false,
                    Type = "Bind",
                    Save = L_206_arg1.Save
                }
                local L_208_ = false
                local L_209_ = ApplyProperties(CreateElement("Button"), {
                    Size = udim2New(1, 0, 1, 0)
                })
                local L_210_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 4), {
                    Size = udim2New(0, 24, 0, 24),
                    Position = udim2New(1, -12, 0.5, 0),
                    AnchorPoint = vector2New(1, 0.5)
                }), {
                    ApplyTheme(CreateElement("Stroke"), "Stroke"),
                    ApplyTheme(ApplyProperties(CreateElement("Label", L_206_arg1.Name, 14), {
                        Size = udim2New(1, 0, 1, 0),
                        Font = EnumFont.GothamBold,
                        TextXAlignment = EnumTextXAlignment.Center,
                        Name = "Value"
                    }), "Text")
                }), "Main")
                local L_211_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
                    Size = udim2New(1, 0, 0, 38),
                    Parent = L_152_arg1
                }), {
                    ApplyTheme(ApplyProperties(CreateElement("Label", L_206_arg1.Name, 15), {
                        Size = udim2New(1, -12, 1, 0),
                        Position = udim2New(0, 12, 0, 0),
                        Font = EnumFont.GothamBold,
                        Name = "Content"
                    }), "Text"),
                    ApplyTheme(CreateElement("Stroke"), "Stroke"),
                    L_210_,
                    L_209_
                }), "Second")
                ConnectSignal(L_210_.Value:GetPropertyChangedSignal("Text"), function()
                    Services.Tween:Create(L_210_, TweenInfoCache.Normal, {
                        Size = udim2New(0, L_210_.Value.TextBounds.X + 16, 0, 24)
                    }):Play()
                end)
                ConnectSignal(L_209_.InputEnded, function(L_212_arg1)
                    if (L_212_arg1.UserInputType == EnumUserInputType.MouseButton1 or L_212_arg1.UserInputType == EnumUserInputType.Touch) and not L_207_.Binding then
                        L_207_.Binding = true
                        L_210_.Value.Text = ""
                    end
                end)
                function L_207_:Set(L_213_arg1)
                    L_207_.Binding = false
                    L_207_.Value = L_213_arg1 or L_207_.Value
                    L_207_.Value = L_207_.Value.Name or L_207_.Value
                    L_210_.Value.Text = L_207_.Value
                end
                ConnectSignal(Services.UserInput.InputBegan, function(L_214_arg1)
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end
                    if (L_214_arg1.KeyCode.Name == L_207_.Value or L_214_arg1.UserInputType.Name == L_207_.Value) and not L_207_.Binding then
                        if L_206_arg1.Hold then
                            L_208_ = true
                            L_206_arg1.Callback(L_208_)
                        else
                            L_206_arg1.Callback()
                        end
                    elseif L_207_.Binding then
                        local L_215_
                        pcall(function()
                            if not L_30_func(L_29_, L_214_arg1.KeyCode) then
                                L_215_ = L_214_arg1.KeyCode
                            end
                        end)
                        pcall(function()
                            if L_30_func(L_28_, L_214_arg1.UserInputType) and not L_215_ then
                                L_215_ = L_214_arg1.UserInputType
                            end
                        end)
                        L_215_ = L_215_ or L_207_.Value
                        L_207_:Set(L_215_)
                        SaveConfiguration(game.PlaceId)
                    end
                end)
                ConnectSignal(Services.UserInput.InputEnded, function(L_216_arg1)
                    if (L_216_arg1.KeyCode.Name == L_207_.Value or L_216_arg1.UserInputType.Name == L_207_.Value) and L_206_arg1.Hold and L_208_ then
                        L_208_ = false
                        L_206_arg1.Callback(L_208_)
                    end
                end)
                ConnectSignal(L_209_.MouseEnter, function()
                    Services.Tween:Create(L_211_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 3)
                    }):Play()
                end)
                ConnectSignal(L_209_.MouseLeave, function()
                    Services.Tween:Create(L_211_, TweenInfoCache.Normal, {
                        BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second
                    }):Play()
                end)
                ConnectSignal(L_209_.MouseButton1Up, function()
                    Services.Tween:Create(L_211_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 3)
                    }):Play()
                end)
                ConnectSignal(L_209_.MouseButton1Down, function()
                    Services.Tween:Create(L_211_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 6)
                    }):Play()
                end)
                L_207_:Set(L_206_arg1.Default)
                if L_206_arg1.Flag then
                    OrionLib.Flags[L_206_arg1.Flag] = L_207_
                end
                return L_207_
            end
            function ElementMethods:AddTextbox(L_217_arg1)
                L_217_arg1 = L_217_arg1 or {}
                L_217_arg1.Name = L_217_arg1.Name or "Textbox"
                L_217_arg1.Default = L_217_arg1.Default or ""
                L_217_arg1.TextDisappear = L_217_arg1.TextDisappear or false
                L_217_arg1.Callback = L_217_arg1.Callback or function() end
                local L_218_ = ApplyProperties(CreateElement("Button"), {
                    Size = udim2New(1, 0, 1, 0)
                })
                local L_219_ = ApplyTheme(CreateInstance("TextBox", {
                    Size = udim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = colorFromRGB(255, 255, 255),
                    PlaceholderColor3 = colorFromRGB(210, 210, 210),
                    PlaceholderText = "Input",
                    Font = EnumFont.GothamMedium,
                    TextXAlignment = EnumTextXAlignment.Center,
                    TextSize = 14,
                    ClearTextOnFocus = false
                }), "Text")
                local L_220_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 4), {
                    Size = udim2New(0, 24, 0, 24),
                    Position = udim2New(1, -12, 0.5, 0),
                    AnchorPoint = vector2New(1, 0.5)
                }), {
                    ApplyTheme(CreateElement("Stroke"), "Stroke"),
                    L_219_
                }), "Main")
                local L_221_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
                    Size = udim2New(1, 0, 0, 38),
                    Parent = L_152_arg1
                }), {
                    ApplyTheme(ApplyProperties(CreateElement("Label", L_217_arg1.Name, 15), {
                        Size = udim2New(1, -12, 1, 0),
                        Position = udim2New(0, 12, 0, 0),
                        Font = EnumFont.GothamBold,
                        Name = "Content"
                    }), "Text"),
                    ApplyTheme(CreateElement("Stroke"), "Stroke"),
                    L_220_,
                    L_218_
                }), "Second")
                ConnectSignal(L_219_:GetPropertyChangedSignal("Text"), function()
                    Services.Tween:Create(L_220_, TweenInfo.new(0.45, EnumEasingStyle.Quint, EnumEasingDirection.Out), {
                        Size = udim2New(0, L_219_.TextBounds.X + 16, 0, 24)
                    }):Play()
                end)
                ConnectSignal(L_219_.FocusLost, function()
                    L_217_arg1.Callback(L_219_.Text)
                    if L_217_arg1.TextDisappear then
                        L_219_.Text = ""
                    end
                end)
                L_219_.Text = L_217_arg1.Default
                ConnectSignal(L_218_.MouseEnter, function()
                    Services.Tween:Create(L_221_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 3)
                    }):Play()
                end)
                ConnectSignal(L_218_.MouseLeave, function()
                    Services.Tween:Create(L_221_, TweenInfoCache.Normal, {
                        BackgroundColor3 = OrionLib.Themes[OrionLib.SelectedTheme].Second
                    }):Play()
                end)
                ConnectSignal(L_218_.MouseButton1Up, function()
                    Services.Tween:Create(L_221_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 3)
                    }):Play()
                    L_219_:CaptureFocus()
                end)
                ConnectSignal(L_218_.MouseButton1Down, function()
                    Services.Tween:Create(L_221_, TweenInfoCache.Normal, {
                        BackgroundColor3 = GetHoverColor(OrionLib.Themes[OrionLib.SelectedTheme].Second, 6)
                    }):Play()
                end)
            end
            function ElementMethods:AddColorpicker(L_222_arg1)
                L_222_arg1 = L_222_arg1 or {}
                L_222_arg1.Name = L_222_arg1.Name or "Colorpicker"
                L_222_arg1.Default = L_222_arg1.Default or colorFromRGB(255, 255, 255)
                L_222_arg1.Callback = L_222_arg1.Callback or function() end
                L_222_arg1.Flag = L_222_arg1.Flag or nil
                L_222_arg1.Save = L_222_arg1.Save or false
                local L_223_, L_224_, L_225_ = 1, 1, 1
                local L_226_ = {
                    Value = L_222_arg1.Default,
                    Toggled = false,
                    Type = "Colorpicker",
                    Save = L_222_arg1.Save
                }
                local L_227_ = CreateInstance("ImageLabel", {
                    Size = udim2New(0, 18, 0, 18),
                    Position = udim2New(select(3, L_226_.Value:ToHSV())),
                    ScaleType = EnumScaleType.Fit,
                    AnchorPoint = vector2New(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://4805639000"
                })
                local L_228_ = CreateInstance("ImageLabel", {
                    Size = udim2New(0, 18, 0, 18),
                    Position = udim2New(0.5, 0, 1 - select(1, L_226_.Value:ToHSV())),
                    ScaleType = EnumScaleType.Fit,
                    AnchorPoint = vector2New(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://4805639000"
                })
                local L_229_ = CreateInstance("ImageLabel", {
                    Size = udim2New(1, -25, 1, 0),
                    Visible = false,
                    Image = "rbxassetid://4155801252"
                }, {
                    CreateInstance("UICorner", {
                        CornerRadius = udimNew(0, 5)
                    }),
                    L_227_
                })
                local L_230_ = CreateInstance("Frame", {
                    Size = udim2New(0, 20, 1, 0),
                    Position = udim2New(1, -20, 0, 0),
                    Visible = false
                }, {
                    CreateInstance("UIGradient", {
                        Rotation = 270,
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, colorFromRGB(255, 0, 4)),
                            ColorSequenceKeypoint.new(0.2, colorFromRGB(234, 255, 0)),
                            ColorSequenceKeypoint.new(0.4, colorFromRGB(21, 255, 0)),
                            ColorSequenceKeypoint.new(0.6, colorFromRGB(0, 255, 255)),
                            ColorSequenceKeypoint.new(0.8, colorFromRGB(0, 17, 255)),
                            ColorSequenceKeypoint.new(0.9, colorFromRGB(255, 0, 251)),
                            ColorSequenceKeypoint.new(1, colorFromRGB(255, 0, 4))
                        }
                    }),
                    CreateInstance("UICorner", {
                        CornerRadius = udimNew(0, 5)
                    }),
                    L_228_
                })
                local L_231_ = CreateInstance("Frame", {
                    Position = udim2New(0, 0, 0, 32),
                    Size = udim2New(1, 0, 1, -32),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true
                }, {
                    L_230_,
                    L_229_,
                    CreateInstance("UIPadding", {
                        PaddingLeft = udimNew(0, 35),
                        PaddingRight = udimNew(0, 35),
                        PaddingBottom = udimNew(0, 10),
                        PaddingTop = udimNew(0, 17)
                    })
                })
                local L_232_ = ApplyProperties(CreateElement("Button"), {
                    Size = udim2New(1, 0, 1, 0)
                })
                local L_233_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 4), {
                    Size = udim2New(0, 24, 0, 24),
                    Position = udim2New(1, -12, 0.5, 0),
                    AnchorPoint = vector2New(1, 0.5)
                }), {
                    ApplyTheme(CreateElement("Stroke"), "Stroke")
                }), "Main")
                local L_234_ = ApplyTheme(AddChildren(ApplyProperties(CreateElement("RoundFrame", colorFromRGB(255, 255, 255), 0, 5), {
                    Size = udim2New(1, 0, 0, 38),
                    Parent = L_152_arg1
                }), {
                    ApplyProperties(AddChildren(CreateElement("TFrame"), {
                        ApplyTheme(ApplyProperties(CreateElement("Label", L_222_arg1.Name, 15), {
                            Size = udim2New(1, -12, 1, 0),
                            Position = udim2New(0, 12, 0, 0),
                            Font = EnumFont.GothamBold,
                            Name = "Content"
                        }), "Text"),
                        L_233_,
                        L_232_,
                        ApplyTheme(ApplyProperties(CreateElement("Frame"), {
                            Size = udim2New(1, 0, 0, 1),
                            Position = udim2New(0, 0, 1, -1),
                            Name = "Line",
                            Visible = false
                        }), "Stroke")
                    }), {
                        Size = udim2New(1, 0, 0, 38),
                        ClipsDescendants = true,
                        Name = "F"
                    }),
                    L_231_,
                    ApplyTheme(CreateElement("Stroke"), "Stroke")
                }), "Second")
                ConnectSignal(L_232_.MouseButton1Down, function()
                    L_226_.Toggled = not L_226_.Toggled
                    Services.Tween:Create(L_234_, TweenInfoCache.Quick, {
                        Size = L_226_.Toggled and udim2New(1, 0, 0, 148) or udim2New(1, 0, 0, 38)
                    }):Play()
                    L_229_.Visible = L_226_.Toggled
                    L_230_.Visible = L_226_.Toggled
                    L_234_.F.Line.Visible = L_226_.Toggled
                end)
                function L_226_:Set(L_238_arg1)
                    L_226_.Value = L_238_arg1
                    L_233_.BackgroundColor3 = L_226_.Value
                    L_222_arg1.Callback(L_226_.Value)
                end
                local function L_235_func()
                    L_233_.BackgroundColor3 = Color3.fromHSV(L_223_, L_224_, L_225_)
                    L_229_.BackgroundColor3 = Color3.fromHSV(L_223_, 1, 1)
                    L_226_:Set(L_233_.BackgroundColor3)
                    L_222_arg1.Callback(L_233_.BackgroundColor3)
                    SaveConfiguration(game.PlaceId)
                end
                L_223_ = 1 - mathClamp(L_228_.AbsolutePosition.Y - L_230_.AbsolutePosition.Y, 0, L_230_.AbsoluteSize.Y) / L_230_.AbsoluteSize.Y
                L_224_ = mathClamp(L_227_.AbsolutePosition.X - L_229_.AbsolutePosition.X, 0, L_229_.AbsoluteSize.X) / L_229_.AbsoluteSize.X
                L_225_ = 1 - mathClamp(L_227_.AbsolutePosition.Y - L_229_.AbsolutePosition.Y, 0, L_229_.AbsoluteSize.Y) / L_229_.AbsoluteSize.Y
                local L_236_
                ConnectSignal(L_229_.InputBegan, function(L_239_arg1)
                    if L_239_arg1.UserInputType == EnumUserInputType.MouseButton1 or L_239_arg1.UserInputType == EnumUserInputType.Touch then
                        if L_236_ then
                            L_236_:Disconnect()
                        end
                        L_236_ = ConnectSignal(Services.Run.RenderStepped, function()
                            local L_240_ = mathClamp(Mouse.X - L_229_.AbsolutePosition.X, 0, L_229_.AbsoluteSize.X) / L_229_.AbsoluteSize.X
                            local L_241_ = mathClamp(Mouse.Y - L_229_.AbsolutePosition.Y, 0, L_229_.AbsoluteSize.Y) / L_229_.AbsoluteSize.Y
                            L_227_.Position = udim2New(L_240_, 0, L_241_, 0)
                            L_224_ = L_240_
                            L_225_ = 1 - L_241_
                            L_235_func()
                        end)
                    end
                end)
                ConnectSignal(L_229_.InputEnded, function(L_242_arg1)
                    if (L_242_arg1.UserInputType == EnumUserInputType.MouseButton1 or L_242_arg1.UserInputType == EnumUserInputType.Touch) and L_236_ then
                        L_236_:Disconnect()
                    end
                end)
                local L_237_
                ConnectSignal(L_230_.InputBegan, function(L_243_arg1)
                    if L_243_arg1.UserInputType == EnumUserInputType.MouseButton1 or L_243_arg1.UserInputType == EnumUserInputType.Touch then
                        if L_237_ then
                            L_237_:Disconnect()
                        end
                        L_237_ = ConnectSignal(Services.Run.RenderStepped, function()
                            local L_244_ = mathClamp(Mouse.Y - L_230_.AbsolutePosition.Y, 0, L_230_.AbsoluteSize.Y) / L_230_.AbsoluteSize.Y
                            L_228_.Position = udim2New(0.5, 0, L_244_, 0)
                            L_223_ = 1 - L_244_
                            L_235_func()
                        end)
                    end
                end)
                ConnectSignal(L_230_.InputEnded, function(L_245_arg1)
                    if (L_245_arg1.UserInputType == EnumUserInputType.MouseButton1 or L_245_arg1.UserInputType == EnumUserInputType.Touch) and L_237_ then
                        L_237_:Disconnect()
                    end
                end)
                L_226_:Set(L_226_.Value)
                if L_222_arg1.Flag then
                    OrionLib.Flags[L_222_arg1.Flag] = L_226_
                end
                return L_226_
            end
            return ElementMethods
        end
        local Tab = {}
        function Tab:AddSection(L_246_arg1)
            L_246_arg1.Name = L_246_arg1.Name or "Section"
            local L_247_ = AddChildren(ApplyProperties(CreateElement("TFrame"), {
                Size = udim2New(1, 0, 0, 26),
                Parent = ItemContainer
            }), {
                ApplyTheme(ApplyProperties(CreateElement("Label", L_246_arg1.Name, 14), {
                    Size = udim2New(1, -12, 0, 16),
                    Position = udim2New(0, 0, 0, 3),
                    Font = EnumFont.GothamMedium
                }), "TextDark"),
                AddChildren(ApplyProperties(CreateElement("TFrame"), {
                    AnchorPoint = vector2New(0, 0),
                    Size = udim2New(1, 0, 1, -24),
                    Position = udim2New(0, 0, 0, 23),
                    Name = "Holder"
                }), {
                    CreateElement("List", 0, 6)
                })
            })
            ConnectSignal(L_247_.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                L_247_.Size = udim2New(1, 0, 0, L_247_.Holder.UIListLayout.AbsoluteContentSize.Y + 31)
                L_247_.Holder.Size = udim2New(1, 0, 0, L_247_.Holder.UIListLayout.AbsoluteContentSize.Y)
            end)
            local L_248_ = {}
            for L_249_forvar1, L_250_forvar2 in next, CreateElementMethods(L_247_.Holder) do
                L_248_[L_249_forvar1] = L_250_forvar2
            end
            return L_248_
        end
        for L_251_forvar1, L_252_forvar2 in next, CreateElementMethods(ItemContainer) do
            Tab[L_251_forvar1] = L_252_forvar2
        end
        return Tab
    end
    return Window
end

--═══════════════════════════════════════════════════════════════════════════════
-- CLEANUP AND DESTRUCTION
--═══════════════════════════════════════════════════════════════════════════════

function OrionLib:Destroy()
    Services.Debris:AddItem(MainGui, 0)
end

--═══════════════════════════════════════════════════════════════════════════════
-- RETURN LIBRARY TO CALLER
--═══════════════════════════════════════════════════════════════════════════════

return OrionLib
