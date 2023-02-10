require("mormesher/globals")

-- note: plugin-specific shortcuts go in ./plugins.lua

local silent_opts = { silent = true, noremap = true }

-- <leader>-c clears highlights
keymap.set("n", "<leader>c", "<cmd>:nohl<cr>", silent_opts)

-- <leader>-q to quit, <leader>-w to save, <leader>-x to save and quit
keymap.set("n", "<leader>q", "<cmd>:qa<cr>", silent_opts)
keymap.set("n", "<leader>w", "<cmd>:wa<cr>", silent_opts)
keymap.set("n", "<leader>x", "<cmd>:xa<cr>", silent_opts)