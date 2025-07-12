return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      cmdline = {
        view = 'cmdline_popup',
        opts = {
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
        },
      },
      presets = {
        command_palette = true,
        lsp_doc_border = true,
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },
}
