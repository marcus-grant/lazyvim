-- My personal lsp changes

-- add pyright to lspconfig
return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      als = {},
      -- pyright will be automatically installed with mason and loaded with lspconfig
      -- pyright = {},
    },
  },
}
