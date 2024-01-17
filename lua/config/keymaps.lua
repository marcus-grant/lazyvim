-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Local Aliases & Imports
local Util = require("lazyvim.util")
local map = Util.safe_keymap_set

-- TODO: Consider moving this to a better location only part of this is keymaps
-- Functions
local set_dark_mode = function()
  vim.opt.background = "dark"
  vim.cmd("colorscheme gruvbox")
end
local set_lite_mode = function()
  vim.opt.background = "light"
  vim.cmd("colorscheme melange")
end
local toggle_dark_mode = function()
  -- Check if background is dark, if so call set_lite_mode else call set_dark_mode
  if vim.opt.background:get() == "dark" then
    set_lite_mode()
  else
    set_dark_mode()
  end
end
local dark_mode_by_time = function()
  local hour = tonumber(os.date("%H"))
  -- print("In dark_mode_by_time, hour is " .. hour)
  if hour > 15 or hour < 8 then
    set_dark_mode()
  else
    set_lite_mode()
  end
end

-- Dark Mode
dark_mode_by_time()
map("n", "<leader>wd", set_dark_mode, { desc = "Dark Mode" })
map("n", "<leader>wl", set_lite_mode, { desc = "Light Mode" })
map("n", "<leader>w ", toggle_dark_mode, { desc = "Toggle Dark/Lite Mode" })
