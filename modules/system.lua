local hotkey = require "hs.hotkey"
local lock_screen_key = "L"

hotkey.bind(hyper, lock_screen_key, function()
  hs.caffeinate.lockScreen()
  -- hs.caffeinate.startScreensaver()
end)

-- mute on sleep
function muteOnWake(eventType)
  if (eventType == hs.caffeinate.watcher.systemDidWake) then
    local output = hs.audiodevice.defaultOutputDevice()
    output:setMuted(true)
  end
end
caffeinateWatcher = hs.caffeinate.watcher.new(muteOnWake)
caffeinateWatcher:start()