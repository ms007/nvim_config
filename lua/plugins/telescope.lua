local keymap = vim.keymap.set

local config = function()
	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
				},
			},
		}, 
	})
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = config,
	keys = {
    keymap("n", "<leader>fk", ":Telescope keymaps<cr>"),
    keymap("n", "<leader>fh", ":Telescope help_tags<cr>"),
    keymap("n", "<leader>ff", ":Telescope find_files<cr>"),
    keymap("n", "<leader>fg", ":Telescope live_grep<cr>"),
    keymap("n", "<leader>fb", ":Telescope buffers<cr>")
  },
}
