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
          },
        },
        format = {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          -- title: set to anything or empty string to hide
          cmdline = { pattern = '^:', icon = '', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
          filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
          lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
          help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
          input = { view = 'cmdline_input', icon = '󰥻 ' }, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
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
