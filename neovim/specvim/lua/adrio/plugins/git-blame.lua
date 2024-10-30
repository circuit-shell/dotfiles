return {
	"f-person/git-blame.nvim",
	event = "BufRead",
	config = function()
		vim.cmd("highlight default link gitblame SpecialComment")
		require("gitblame").setup({
			enabled = true,
			display_virtual_text = 0,
			message_template = "<author> at <date> on <sha>",
			message_when_not_committed = "Not commited.",
			date_format = "%a %b %d %Y",
			delay = 150,
		})
		vim.keymap.set("n", "<leader>gb", ":GitBlameToggle<CR>", {})
	end,
}
