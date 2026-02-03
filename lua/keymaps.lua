-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Append at the end but cursor remains in place
vim.keymap.set('n', 'J', 'mzJ`z')

-- Move down and up but cursor remains in the middle
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Search next cursor remains in the middle
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>x', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfi[x] list' })

-- Save file
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save current buffer' })

-- Buffer closing
vim.keymap.set('n', '<leader>q', function()
  require('mini.bufremove').delete(0, false)
end, { desc = 'Close current buffer' })

vim.keymap.set('n', '<leader>Q', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      require('mini.bufremove').delete(buf, false)
    end
  end
  vim.cmd 'only'
end, { desc = 'Close all other buffers' })

-- Exit insert mode
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Remap toggle line or block comments
vim.api.nvim_set_keymap('n', '<leader>c', '<Plug>(comment_toggle_linewise_current)', { noremap = true, silent = true, desc = 'Toggle line comment' })
vim.api.nvim_set_keymap('v', '<leader>c', '<Plug>(comment_toggle_linewise_visual)', { noremap = true, silent = true, desc = 'Toggle visual comment' })
vim.api.nvim_set_keymap('n', '<leader>bc', '<Plug>(comment_toggle_blockwise_current)', { noremap = true, silent = true, desc = 'Toggle block comment' })
vim.api.nvim_set_keymap('v', '<leader>bc', '<Plug>(comment_toggle_blockwise_visual)', { noremap = true, silent = true, desc = 'Toggle block comment' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Split windows
vim.keymap.set('n', '<leader>v', '<C-w>v', { desc = 'Split window vertically' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
