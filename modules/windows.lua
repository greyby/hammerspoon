-- window management
local application = require "hs.application"
local hotkey = require "hs.hotkey"
local window = require "hs.window"
local layout = require "hs.layout"
local grid = require "hs.grid"
local hints = require "hs.hints"
local screen = require "hs.screen"

-- default 0.2
window.animationDuration = 0

-- Set screen watcher, in case you connect a new monitor, or unplug a monitor
screens = {}
screenArr = {}
local screenwatcher = screen.watcher.new(function()
  screens = screen.allScreens()
end)
screenwatcher:start()

-- left half
hotkey.bind(hyper, "Left", function()
  if window.focusedWindow() then
    window.focusedWindow():moveToUnit(layout.left50)
  else
    alert.show("No active window")
  end
end)

-- right half
hotkey.bind(hyper, "Right", function()
  window.focusedWindow():moveToUnit(layout.right50)
end)

-- left half
hotkey.bind(hyper, "Up", function()
  window.focusedWindow():moveToUnit'[0,0,100,50]'
end)

-- left half
hotkey.bind(hyper, "Down", function()
  window.focusedWindow():moveToUnit'[0,50,100,100]'
end)

-- maximize window
hotkey.bind(hyper, 'tab', function() toggle_fullscreen() end)
-- Defines for window maximize toggler
local frameCache = {}
-- Toggle a window between its normal size, and being maximized
function toggle_fullscreen()
    local win = window.focusedWindow()
    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end

-- Displays a keyboard hint for switching focus to each window
hotkey.bind(hyperShift, '/', function()
    hints.windowHints()
    -- Display current application window
    -- hints.windowHints(hs.window.focusedWindow():application():allWindows())
end)

hotkey.bind({"cmd", "alt"}, "H", function()
  window.switcher.nextWindow()
end)


hotkey.bind(hyper, "M", function ()
  focusScreen(window.focusedWindow():screen():next())
end)

--Predicate that checks if a window belongs to a screen
function isInScreen(screen, win)
  return win:screen() == screen
end

function focusScreen(screen)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  local windows = hs.fnutils.filter(
      window.orderedWindows(),
      hs.fnutils.partial(isInScreen, screen))
  local windowToFocus = #windows > 0 and windows[1] or window.desktop()
  windowToFocus:focus()

  -- Move mouse to center of screen
  local pt = hs.geometry.rectMidPoint(screen:fullFrame())
  hs.mouse.setAbsolutePosition(pt)
end

-- maximized active window and move to selected monitor
moveto = function(win, n)
  local screens = screen.allScreens()
  if n > #screens then
    hs.alert.show("Only " .. #screens .. " monitors ")
  else
    local toWin = screen.allScreens()[n]:name()
    hs.alert.show("Move " .. win:application():name() .. " to " .. toWin)

    layout.apply({{nil, win:title(), toWin, layout.maximized, nil, nil}})
    
  end
end

hotkey.bind(hyperShift, "1", function()
  local win = window.focusedWindow()
  moveto(win, 1)
end)

hotkey.bind(hyperShift, "2", function()
  local win = window.focusedWindow()
  moveto(win, 2)
end)

hotkey.bind(hyperShift, "3", function()
  local win = window.focusedWindow()
  moveto(win, 3)
end)