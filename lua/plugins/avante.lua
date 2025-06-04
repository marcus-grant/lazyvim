-- lua/plugins/avante.lua
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    build = "make",
    opts = {
      provider = "openai",
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4o",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.7,
            max_tokens = 4000,
          },
        },
      },
      window = {
        type = "float",
        width = 0.8,
        height = 0.5,
        border = "rounded",
      },
      context = {
        file_on_open = true,
        quickfix = { enabled = true, mode = "append" },
        buffers = { enabled = true, mode = "append" },
      },
      -- Disable any “auto‐run” / confirm behavior so Avante will never pop up
      -- the “run generated script?” dialog (and thus never hit that missing‐group error).
      auto_run = false,
    },
    config = function(_, opts)
      require("avante").setup(opts)
    end,
  },
}
