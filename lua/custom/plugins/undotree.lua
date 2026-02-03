return {
  'jiaoshijie/undotree',
  dependencies = 'nvim-lua/plenary.nvim',
  keys = {
    { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Toggle UndoTree' },
  },
}
