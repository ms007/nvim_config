return {
  {
    'unblevable/quick-scope',
    event = 'VimEnter',
    config = function()
      vim.cmd [[highlight QuickScopePrimary guifg=#c0caf5 guibg=#414868]]
      vim.cmd [[highlight QuickScopeSecondary guifg=#c0caf5 guibg=#414868]]
    end,
  },
}
