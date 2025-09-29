return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function()
      require('neogit').setup {
        kind = 'floating',
        signs = {
          -- { CLOSED, OPENED }
          section = { '', '' },
          item = { '', '' },
          hunk = { '', '' },
        },
        integrations = { diffview = true }, -- adds integration with diffview.nvim
      }
    end,
    keys = { { '<leader>gg', '<cmd>Neogit<CR>', mode = { 'n' }, desc = 'Open Neogit' } },
  },
  {
    'sindrets/diffview.nvim',
    keys = {
      { '<leader>gv', '<cmd>DiffviewOpen<CR>', mode = { 'n' }, desc = 'Open Diffview' },
      { '<leader>gc', '<cmd>DiffviewClose<CR>', mode = { 'n' }, desc = 'Close Diffview' },
    },
  },
}
