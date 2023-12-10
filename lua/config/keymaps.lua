local keymap = vim.keymap.set
local opts = { noremap = true, silent = true}

keymap("", "<Space>", "<Nop>", opts)

-- Normal --
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<Space>q", ":q<cr>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<cr>", opts)
keymap("n", "<S-h>", ":bprevious<cr>", opts)

-- Comments
vim.api.nvim_set_keymap("n", "<C-k>", "gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "<C-k>", "gbc", { noremap = false })
