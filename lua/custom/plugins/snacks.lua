---@diagnostic disable: undefined-global
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bufdelete = { enabled = true },
    notifier = { enabled = true },
  },
  keys = {
    {
      '<leader>Q',
      function()
        Snacks.bufdelete.other()
        vim.cmd.only()
      end,
      desc = 'Delete all other buffers',
    },
    {
      '<leader>q',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Close current buffer',
    },
    {
      '<leader>nh',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>nd',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
  },
}
