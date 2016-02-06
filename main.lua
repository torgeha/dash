-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

display.setStatusBar(display.HiddenStatusBar)
-- system.activate('multitouch') nessecary?

local composer = require('composer')
composer.recycleOnSceneChange = true -- Automatically remove scenes from memory
composer.gotoScene('scenes.game')