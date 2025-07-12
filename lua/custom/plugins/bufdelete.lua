return {
  'famiu/bufdelete.nvim',
  keys = {
    -- Delete all other buffers
    {
      '<leader>Q',
      function()
        local bd = require 'bufdelete'
        local bufs = vim.api.nvim_list_bufs()
        local current_buf = vim.api.nvim_get_current_buf()

        for _, buf_id in ipairs(bufs) do
          if buf_id ~= current_buf then
            bd.bufdelete(buf_id, true)
          end
        end
      end,
      mode = 'n',
      desc = 'Delete all other buffers',
    },
    -- Delete current buffer
    {
      '<leader>q',
      function()
        require('bufdelete').bufdelete(0, false)
      end,
      mode = 'n',
      desc = 'Close current buffer',
    },
  },
}
