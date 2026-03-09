return {
  'folke/trouble.nvim',
  opts = {
    focus = true,
  },
  keys = {
    {
      '<leader>x',
      '<cmd>Trouble diagnostics toggle filter.buf=0 win.type=float win.border=rounded<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>X',
      '<cmd>Trouble diagnostics toggle win.type=float win.border=rounded<cr>',
      desc = 'Workspace Diagnostics (Trouble)',
    },
  },
}
