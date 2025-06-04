# Upgrading LazyVim to a Cursor-Like AI IDE (with Avante.nvim)

This document collects **all** of the changes we applied while setting up Avante + LazyVim, plus the extra keymaps and script-execution tweaks.  
> **Prerequisite:** make sure your shell exports the key  
> `export OPENAI_API_KEY="sk-XXXXXXXXXXXXXXXXXXXXXXXX"`  

---

## 1 · Plugin Spec — `lua/plugins/avante.lua`

```lua
-- ~/.config/nvim/lua/plugins/avante.lua
return {
  {
    "yetone/avante.nvim",
    event   = "VeryLazy",
    version = false,

    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft   = { "markdown", "Avante" },
      },
    },
    build = "make",

    opts = {
      provider = "openai",                                 -- ← always OpenAI
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model    = "gpt-4o",
          timeout  = 30000,
          extra_request_body = {                          -- request body
            temperature = 0.7,
            max_tokens  = 4000,
          },
        },
      },

      window = { type = "float", width = 0.8, height = 0.5, border = "rounded" },

      context = {
        file_on_open = true,
        quickfix     = { enabled = true, mode = "append" },
        buffers      = { enabled = true, mode = "append" },
      },

      -- Disable Avante’s built-in “auto-run” popup (we’ll run manually)
      auto_run = false,
    },

    config = function(_, opts)
      require("avante").setup(opts)
    end,
  },
}
```

---

## 2 · AI Keymaps — `lua/keymaps.lua`

```lua
-- Add to your existing keymaps.lua
local Util = require("lazyvim.util")
local map  = Util.safe_keymap_set

-- Avante commands
map("n", "<leader>aa", "<cmd>AvanteChat<cr>",    { desc = "Avante: chat" })
map("n", "<leader>ap", "<cmd>AvanteApply<cr>",   { desc = "Avante: apply patch" })
map("n", "<leader>ar", "<cmd>AvanteReject<cr>",  { desc = "Avante: reject patch" })
map("n", "<leader>aq", "<cmd>AvanteQuickfix<cr>",{ desc = "Avante: qf → ctx" })

-- Custom: run latest generated script (defined in §3)
map("n", "<leader>as", "<cmd>AvanteRunLast<cr>", { desc = "Avante: run script" })
```

---

## 3 · Helper to Run Last Script — `lua/config/avante_run.lua`

```lua
-- ~/.config/nvim/lua/config/avante_run.lua
local M = {}

-- Expected filename: avante_run.sh in current working dir
function M.run_last()
  local script = vim.fn.getcwd() .. "/avante_run.sh"
  if vim.fn.filereadable(script) == 0 then
    vim.notify("avante_run.sh not found", vim.log.levels.ERROR)
    return
  end
  vim.cmd("botright split | resize 15")
  vim.cmd("terminal bash " .. vim.fn.fnameescape(script))
end

return M
```

Bind the helper in `init.lua` (or any startup file):

```lua
-- after require("lazyvim").setup(...)
vim.api.nvim_create_user_command("AvanteRunLast",
  function() require("config.avante_run").run_last() end,
  { desc = "Run last Avante script" }
)
```

Workflow  
1. **Chat** → `<leader>aa`  
2. **Apply patch** → `<leader>ap` (writes `avante_run.sh`)  
3. **Execute** → `<leader>as` (opens bottom terminal & runs it)

---

## 4 · Statusline (optional)

If you use **lualine**, add Avante’s status:

```lua
-- in lualine config
lualine_c = {
  "filename",
  function() return require("avante.statusline").status() end,
},
```

You’ll see `avante: thinking…` while waiting and `avante: idle` afterward.

---

## 5 · Color-Scheme Toggles (unchanged from earlier)

Keymaps for dark / light mode remained:

```lua
map("n", "<leader>wd", set_dark_mode,   { desc = "Dark mode" })
map("n", "<leader>wl", set_lite_mode,   { desc = "Light mode" })
map("n", "<leader>w ", toggle_dark_mode,{ desc = "Toggle dark ↔ light" })
```

---

## 6 · Final Checklist

| ✔︎ | Step                                             |
|---|---------------------------------------------------|
|   | **Export** `OPENAI_API_KEY` in your shell startup |
|   | `:Lazy sync` then restart Neovim                  |
|   | `<leader>aa` opens Avante chat                    |
|   | `<leader>ap` applies AI patch                     |
|   | `avante_run.sh` appears in project root           |
|   | `<leader>as` runs script in bottom terminal       |
|   | No more confirm-window errors                     |

You now have a Cursor-style workflow: chat, patch, run — all from inside LazyVim.
