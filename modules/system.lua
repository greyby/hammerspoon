local hotkey = require "hs.hotkey"
local lock_screen_key = "`"

hotkey.bind(hyper, lock_screen_key, function()
  os.execute("/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend")
end)