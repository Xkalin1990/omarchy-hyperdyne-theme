-- Hyperdyne Systems / Weyland-Yutani Corp (Private Terminal 13-231-1)
-- Weyland-Yutani bootsplash emblem banner, sharp CRT borders, dashboard telemetry, and theme-matched highlights.

local wy_banner = require("config.wy_logo_banner")

local palette = {
	bg = "#1a0806",
	dark_bg = "#140604",
	darker_bg = "#0e0403",
	lighter_bg = "#2b0f0c",
	selection = "#3b1512",
	fg = "#f0a850",
	dark_fg = "#c47d38",
	light_fg = "#f5bc73",
	bright_fg = "#ffd08a",
	muted = "#8a3a35",
	accent = "#d9463e",
	orange = "#e06d44",
	brown = "#7a2722",
	bright_red = "#f25c54",
}

local function is_hyperdyne_active()
	local state_file = vim.fn.expand("~/.local/state/omarchy/current/theme.name")
	local ok, lines = pcall(vim.fn.readfile, state_file)
	if ok and lines and lines[1] then
		return vim.trim(lines[1]) == "hyperdyne"
	end
	return vim.g.colors_name == "aether"
end

local function apply_hyperdyne_highlights()
	-- Always ensure the Weyland-Yutani multi-color emblem highlights are defined
	wy_banner.apply_highlights()

	if not is_hyperdyne_active() then
		return
	end

	local hl = vim.api.nvim_set_hl

	-- Sharp industrial borders and window dividers
	hl(0, "FloatBorder", { fg = palette.muted })
	hl(0, "FloatTitle", { fg = palette.bright_fg, bg = palette.lighter_bg, bold = true })
	hl(0, "WinSeparator", { fg = palette.brown })
	hl(0, "VertSplit", { fg = palette.brown })
	hl(0, "NeoTreeWinSeparator", { fg = palette.brown })
	hl(0, "CursorLineNr", { fg = palette.accent, bold = true })
	hl(0, "LineNr", { fg = palette.muted })

	-- Snacks dashboard: amber phosphor + crimson alert hierarchy
	hl(0, "SnacksDashboardHeader", { fg = palette.fg })
	hl(0, "SnacksDashboardIcon", { fg = palette.accent })
	hl(0, "SnacksDashboardKey", { fg = palette.bright_fg, bold = true })
	hl(0, "SnacksDashboardDesc", { fg = palette.fg })
	hl(0, "SnacksDashboardFile", { fg = palette.light_fg })
	hl(0, "SnacksDashboardDir", { fg = palette.dark_fg })
	hl(0, "SnacksDashboardSpecial", { fg = palette.accent, bold = true })
	hl(0, "SnacksDashboardFooter", { fg = palette.muted })

	-- Snacks indent & picker chrome
	hl(0, "SnacksIndent", { fg = palette.selection })
	hl(0, "SnacksIndentScope", { fg = palette.muted })
	hl(0, "SnacksPickerBorder", { fg = palette.muted })
	hl(0, "SnacksPickerTitle", { fg = palette.bright_fg, bg = palette.lighter_bg, bold = true })
	hl(0, "SnacksPickerPrompt", { fg = palette.accent, bold = true })

	-- WhichKey & Noice borders
	hl(0, "WhichKeyBorder", { fg = palette.muted })
	hl(0, "WhichKeyTitle", { fg = palette.bright_fg, bg = palette.lighter_bg, bold = true })
	hl(0, "NoiceCmdlinePopupBorder", { fg = palette.accent })
	hl(0, "NoiceCmdlinePopupTitle", { fg = palette.bright_fg, bg = palette.lighter_bg, bold = true })
	hl(0, "NoiceCmdlineIcon", { fg = palette.accent })
end

-- Sharp 90-degree CRT window borders across Neovim 0.11+
vim.o.winborder = "single"
apply_hyperdyne_highlights()

local group = vim.api.nvim_create_augroup("HyperdyneUI", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
	group = group,
	callback = function()
		apply_hyperdyne_highlights()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "snacks_dashboard",
	callback = function()
		apply_hyperdyne_highlights()
	end,
})

return {
	{
		"folke/snacks.nvim",
		opts = {
			image = {
				enabled = true,
			},
			dashboard = {
				width = 70,
				preset = {
					keys = {
						{ icon = " ", key = "f", desc = "FIND_FILE     // Locate Workspace Target", action = ":lua Snacks.dashboard.pick('files')" },
						{ icon = " ", key = "n", desc = "NEW_BUFFER    // Initialize Blank Sector", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "GREP_SOURCE   // Scan Repository Patterns", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{ icon = " ", key = "r", desc = "RECENT_LOGS   // Recall Accessed Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						{ icon = " ", key = "c", desc = "SYS_CONFIG    // Edit Terminal Parameters", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = " ", key = "s", desc = "RESTORE_STATE // Resume Last Session", section = "session" },
						{ icon = " ", key = "x", desc = "LAZY_EXTRAS   // Subsystem Modules", action = ":LazyExtras" },
						{ icon = "󰒲 ", key = "l", desc = "LAZY_SYNC     // Package Manifest", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "TERMINATE     // Close Terminal Session", action = ":qa" },
					},
				},
				sections = {
					function()
						apply_hyperdyne_highlights()
						return wy_banner.section()
					end,
					{ section = "keys", gap = 0, padding = 1 },
					{ section = "startup", padding = 0 },
					{
						text = {
							{ "──[ HYPERDYNE SYSTEMS TERMINAL // UNIT 13-231-1 ]──", hl = "SnacksDashboardSpecial" },
						},
						align = "center",
					},
				},
			},
			indent = {
				indent = { char = "│" },
				scope = { char = "┃" },
			},
		},
	},
	{
		"folke/which-key.nvim",
		opts = {
			win = {
				border = "single",
				title = " WY // KEYMAP MATRIX ",
				title_pos = "center",
			},
		},
	},
	{
		"folke/noice.nvim",
		opts = {
			presets = {
				lsp_doc_border = true,
			},
			views = {
				cmdline_popup = {
					border = {
						style = "single",
						padding = { 0, 1 },
					},
				},
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			popup_border_style = "single",
		},
	},
	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				separator_style = "thin",
				indicator = {
					icon = "▌",
					style = "icon",
				},
			},
		},
	},
}
