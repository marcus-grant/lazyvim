-- My personal lsp changes

-- add pyright to lspconfig
return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      -- disable these default lsps for now
      gopls = { mason = false },
      gofumpt = { mason = false },
      goimports = { mason = false },
      als = {},
      -- pyright will be automatically installed with mason and loaded with lspconfig
      -- pyright = {},
    },
  },
}
