-- UI
vim.g.netrw_banner = 0
vim.o.laststatus = 3
vim.o.showmode = false
vim.o.cmdheight = 1
vim.o.termguicolors = true

-- Editing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- UX
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Cursor
vim.opt.cursorline = true

-- Safety
vim.opt.confirm = true

-- Auto-create directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(ev)
		local dir = vim.fn.fnamemodify(ev.match, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})
