local M = {}
local Config = require("scratchpad.config")

M.buf = nil
M.win = nil

-- Open floating scratchpad
function M.open()
	if M.win and vim.api.nvim_win_is_valid(M.win) then
		vim.api.nvim_set_current_win(M.win)
		return
	end

	-- Create buffer
	M.buf = vim.api.nvim_create_buf(false, true)

	-- Set buffer options
	vim.api.nvim_buf_set_option(M.buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(M.buf, "filetype", "scratchpad")

	-- Get editor size
	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")

	local win_opts = {
		relative = "editor",
		width = math.floor(width * 0.6),
		height = math.floor(height * 0.6),
		row = math.floor(height * 0.2),
		col = math.floor(width * 0.2),
		style = "minimal",
		border = "rounded",
	}

	-- Open floating window
	M.win = vim.api.nvim_open_win(M.buf, true, win_opts)

	-- Load scratchpad from file
	M.load()

	-- Check if buffer is empty, then add default message
	local lines = vim.api.nvim_buf_get_lines(M.buf, 0, -1, false)
	if #lines == 0 or (#lines == 1 and lines[1] == "") then
		vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, { "- [ ] Write something here!" })
	end

	-- Insert `- [ ] ` when pressing Enter in insert mode
	vim.api.nvim_buf_set_keymap(
		M.buf,
		"i",
		"<CR>",
		[[<C-o>o<C-r>=repeat(' ', indent('.')/&shiftwidth) . '- [ ] '<CR>]],
		{ noremap = true, silent = true, expr = true }
	)

	-- Insert `- [ ] ` when using `o` in normal mode (new line below)
	vim.api.nvim_buf_set_keymap(M.buf, "n", "o", [[o- [ ] <Esc>]], { noremap = true, silent = true })

	-- Insert `- [ ] ` when using `O` in normal mode (new line above)
	vim.api.nvim_buf_set_keymap(M.buf, "n", "O", [[O- [ ] <Esc>]], { noremap = true, silent = true })

	-- Close scratchpad with `q`
	vim.api.nvim_buf_set_keymap(
		M.buf,
		"n",
		"q",
		[[<Cmd>lua require('scratchpad').close()<CR>]],
		{ noremap = true, silent = true }
	)
end

-- Function to close the scratchpad
function M.close()
	if M.win and vim.api.nvim_win_is_valid(M.win) then
		vim.api.nvim_win_close(M.win, true)
		M.win = nil
		M.buf = nil
	end
end

-- Save buffer contents to .scratchpad file
function M.save()
	if not M.buf then
		return
	end

	local lines = vim.api.nvim_buf_get_lines(M.buf, 0, -1, false)
	local path = vim.fn.getcwd() .. "/.scratchpad"

	local file = io.open(path, "w")
	if file then
		file:write(table.concat(lines, "\n"))
		file:close()
	end
end

-- Load contents from .scratchpad file
function M.load()
	local path = vim.fn.getcwd() .. "/.scratchpad"
	local file = io.open(path, "r")

	if file then
		local lines = {}
		for line in file:lines() do
			table.insert(lines, line)
		end
		file:close()
		vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)
	end
end

-- Toggle checkbox [ ] → [x]
function M.toggle_checkbox()
	if not M.buf then
		return
	end

	local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1
	local line = vim.api.nvim_buf_get_lines(M.buf, line_num, line_num + 1, false)[1]

	if line:match("^%s*%- %[ %]") then
		line = line:gsub("%- %[ %]", "- [x]")
	elseif line:match("^%s*%- %[x%]") then
		line = line:gsub("%- %[x%]", "- [ ]")
	else
		return
	end

	vim.api.nvim_buf_set_lines(M.buf, line_num, line_num + 1, false, { line })
end

-- Setup function to allow user configuration
function M.setup(user_config)
	Config.set(user_config)

	vim.api.nvim_set_keymap(
		"n",
		Config.options.keymap_open,
		":lua require('scratchpad').open()<CR>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		Config.options.keymap_toggle,
		":lua require('scratchpad').toggle_checkbox()<CR>",
		{ noremap = true, silent = true }
	)

	-- Auto-save on close
	vim.api.nvim_create_autocmd("BufWinLeave", {
		pattern = "*",
		callback = M.save,
	})
end

return M
