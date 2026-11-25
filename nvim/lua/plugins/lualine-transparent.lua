-- Let the status line show the terminal background, like the rest of the
-- editor. Lualine's auto theme paints its middle sections a solid colour, so
-- they are cleared on each theme it builds, which it does again on every
-- colorscheme change. The mode and position sections keep their colours.
local mode_labels = {
	n = "WY:NORM",
	i = "WY:INSRT",
	v = "WY:VISL",
	V = "WY:V-LN",
	["\22"] = "WY:V-BK",
	c = "WY:CMND",
	R = "WY:REPL",
	t = "WY:TERM",
	s = "WY:SEL",
	S = "WY:S-LN",
}

return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.options = opts.options or {}
		opts.options.component_separators = { left = "│", right = "│" }
		opts.options.section_separators = { left = "▌", right = "▐" }
		opts.options.theme = function()
			local theme = require("lualine.utils.loader").load_theme("auto")
			for _, mode in pairs(theme) do
				for _, section in ipairs({ "b", "c", "x" }) do
					if mode[section] then
						mode[section].bg = "None"
					end
				end
			end
			return theme
		end

		opts.sections = opts.sections or {}
		opts.sections.lualine_a = {
			{
				"mode",
				fmt = function()
					return mode_labels[vim.fn.mode()] or ("WY:" .. vim.fn.mode())
				end,
			},
		}
		opts.sections.lualine_x = {
			{
				function()
					return "HD-13-231"
				end,
				color = { fg = "#8a3a35" },
			},
			"encoding",
			"filetype",
		}
		opts.sections.lualine_z = {
			{
				function()
					return string.format("LN %d:%d", vim.fn.line("."), vim.fn.col("."))
				end,
			},
		}
	end,
}
