-- Fix taken from:
-- https://github.com/lukas-reineke/headlines.nvim/issues/41
return {
  "lukas-reineke/headlines.nvim",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    markdown = {
      fat_headline_lower_string = "▔",
    },
  },
}
-- Full Spec taken from lazyvim docs:
-- https://www.lazyvim.org/extras/lang/markdown#headlinesnvim
-- opts = function()
--   local opts = {}
--   for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
--     opts[ft] = {
--       headline_highlights = {},
--       -- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
--       bullets = {},
--     }
--     for i = 1, 6 do
--       local hl = "Headline" .. i
--       vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
--       table.insert(opts[ft].headline_highlights, hl)
--     end
--   end
--   return opts
-- end
