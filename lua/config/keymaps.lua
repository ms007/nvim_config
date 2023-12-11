local keymap = vim.keymap.set
local opts = { noremap = true, silent = true}

keymap("", "<Space>", "<Nop>", opts)

-- Insert
keymap("i", "jk", "<Esc>", opts)

-- Normal --
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<Space>q", ":q<cr>", opts)
keymap("n", "<Space>w", ":w<cr>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

-- Comments
vim.api.nvim_set_keymap("n", "<C-/>", "gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "<C-/>", "gbc<Esc>", { noremap = false })
