return {
  'folke/snacks.nvim',
  config = true,
  keys = {
    {
      '<leader>Q',
      function()
        require('snacks.bufdelete').other()
      end,
      mode = 'n',
      desc = 'Delete all other buffers',
    },
    -- Delete current buffer
    {
      '<leader>q',
      function()
        require 'snacks.bufdelete'()
      end,
      mode = 'n',
      desc = 'Close current buffer',
    },
  },
}
