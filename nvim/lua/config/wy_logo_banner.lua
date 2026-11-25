-- Auto-generated Weyland-Yutani Corp CRT Emblem Banner (70x9 cells, clean symmetrical W)
local M = {}

M.highlights = {
	HyperdyneWYBorder = { fg = "#d9463e", bg = "#160604", bold = true },
	HyperdyneWYTitle = { fg = "#f25c54", bg = "#160604", bold = true },
	HyperdyneWYMotto = { fg = "#e06d44", bg = "#160604", bold = true },
	HyperdyneWYBoxBorder = { fg = "#8a3a35" },
	HyperdyneWYBoxLabel = { fg = "#d9463e", bold = true },
	HyperdyneWYBoxText = { fg = "#f0a850" },
	HyperdyneWY1 = { fg = "#160604", bg = "#1a0705" },
	HyperdyneWY2 = { fg = "#160604", bg = "#3d160c" },
	HyperdyneWY3 = { fg = "#160604", bg = "#f7be6a" },
	HyperdyneWY4 = { fg = "#160604", bg = "#6e3318" },
	HyperdyneWY5 = { fg = "#160604", bg = "#ffe3ab" },
	HyperdyneWY6 = { fg = "#160604", bg = "#e69c48" },
	HyperdyneWY7 = { fg = "#3d160c", bg = "#1a0705" },
	HyperdyneWY8 = { fg = "#f7be6a", bg = "#6e3318" },
	HyperdyneWY9 = { fg = "#f7be6a", bg = "#f7be6a" },
	HyperdyneWY10 = { fg = "#f7be6a", bg = "#e69c48" },
	HyperdyneWY11 = { fg = "#ffe3ab", bg = "#e69c48" },
	HyperdyneWY12 = { fg = "#c77832", bg = "#f7be6a" },
	HyperdyneWY13 = { fg = "#c77832", bg = "#1a0705" },
	HyperdyneWY14 = { fg = "#1a0705", bg = "#1a0705" },
	HyperdyneWY15 = { fg = "#3d160c", bg = "#f7be6a" },
	HyperdyneWY16 = { fg = "#6e3318", bg = "#1a0705" },
	HyperdyneWY17 = { fg = "#f7be6a", bg = "#9c5223" },
	HyperdyneWY18 = { fg = "#f7be6a", bg = "#e08a44" },
	HyperdyneWY19 = { fg = "#3d160c", bg = "#e69c48" },
	HyperdyneWY20 = { fg = "#9c5223", bg = "#1a0705" },
	HyperdyneWY21 = { fg = "#160604", bg = "#9c5223" },
	HyperdyneWY22 = { fg = "#e08a44", bg = "#e69c48" },
	HyperdyneWY23 = { fg = "#e69c48", bg = "#c77832" },
	HyperdyneWY24 = { fg = "#e69c48", bg = "#e08a44" },
	HyperdyneWY25 = { fg = "#c77832", bg = "#e08a44" },
	HyperdyneWY26 = { fg = "#6e3318", bg = "#e69c48" },
	HyperdyneWY27 = { fg = "#f7be6a", bg = "#c77832" },
	HyperdyneWY28 = { fg = "#e08a44", bg = "#1a0705" },
	HyperdyneWY29 = { fg = "#c77832", bg = "#c77832" },
	HyperdyneWY30 = { fg = "#c77832", bg = "#9c5223" },
	HyperdyneWY31 = { fg = "#e69c48", bg = "#9c5223" },
	HyperdyneWY32 = { fg = "#e08a44", bg = "#9c5223" },
	HyperdyneWY33 = { fg = "#e08a44", bg = "#c77832" },
	HyperdyneWY34 = { fg = "#3d160c", bg = "#c77832" },
	HyperdyneWY35 = { fg = "#c77832", bg = "#3d160c" },
	HyperdyneWY36 = { fg = "#9c5223", bg = "#c77832" },
	HyperdyneWY37 = { fg = "#9c5223", bg = "#6e3318" },
	HyperdyneWY38 = { fg = "#1a0705", bg = "#9c5223" },
	HyperdyneWY39 = { fg = "#9c5223", bg = "#9c5223" },
	HyperdyneWY40 = { fg = "#d9463e", bg = "#1a0705" },
}

function M.apply_highlights()
	for name, spec in pairs(M.highlights) do
		vim.api.nvim_set_hl(0, name, spec)
	end
end

M.rows = {
	{ { "▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY2" }, { "▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY3" }, { "▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY4" }, { "▀", hl = "HyperdyneWY5" }, { "▀▀▀▀▀", hl = "HyperdyneWY3" }, { "▀", hl = "HyperdyneWY6" }, { "▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY4" }, { "▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY3" }, { "▀", hl = "HyperdyneWY4" }, { "▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY6" }, { "▀▀▀▀▀", hl = "HyperdyneWY3" }, { "▀", hl = "HyperdyneWY5" }, { "▀", hl = "HyperdyneWY4" }, { "▀", hl = "HyperdyneWY1" }, { "▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY3" }, { "▀", hl = "HyperdyneWY2" }, { "▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" } },
	{ { "▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY7" }, { "▀", hl = "HyperdyneWY8" }, { "▀", hl = "HyperdyneWY9" }, { "▀▀▀▀▀", hl = "HyperdyneWY10" }, { "▀", hl = "HyperdyneWY11" }, { "▀", hl = "HyperdyneWY12" }, { "▀", hl = "HyperdyneWY4" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY11" }, { "▀▀", hl = "HyperdyneWY10" }, { "▀", hl = "HyperdyneWY9" }, { "▀", hl = "HyperdyneWY8" }, { "▀", hl = "HyperdyneWY14" }, { "▀", hl = "HyperdyneWY15" }, { "▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY10" }, { "▀", hl = "HyperdyneWY15" }, { "▀", hl = "HyperdyneWY14" }, { "▀", hl = "HyperdyneWY8" }, { "▀", hl = "HyperdyneWY9" }, { "▀▀", hl = "HyperdyneWY10" }, { "▀", hl = "HyperdyneWY11" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY4" }, { "▀", hl = "HyperdyneWY12" }, { "▀", hl = "HyperdyneWY11" }, { "▀▀▀▀▀", hl = "HyperdyneWY10" }, { "▀", hl = "HyperdyneWY9" }, { "▀", hl = "HyperdyneWY8" }, { "▀", hl = "HyperdyneWY7" }, { "▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" } },
	{ { "▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY16" }, { "▀", hl = "HyperdyneWY17" }, { "▀", hl = "HyperdyneWY10" }, { "▀▀▀▀▀▀", hl = "HyperdyneWY18" }, { "▀", hl = "HyperdyneWY19" }, { "▀", hl = "HyperdyneWY7" }, { "▀", hl = "HyperdyneWY8" }, { "▀", hl = "HyperdyneWY18" }, { "▀", hl = "HyperdyneWY20" }, { "▀", hl = "HyperdyneWY21" }, { "▀", hl = "HyperdyneWY22" }, { "▀▀▀▀▀", hl = "HyperdyneWY18" }, { "▀", hl = "HyperdyneWY10" }, { "▀▀", hl = "HyperdyneWY8" }, { "▀", hl = "HyperdyneWY10" }, { "▀▀▀▀▀", hl = "HyperdyneWY18" }, { "▀", hl = "HyperdyneWY22" }, { "▀", hl = "HyperdyneWY21" }, { "▀", hl = "HyperdyneWY20" }, { "▀", hl = "HyperdyneWY18" }, { "▀", hl = "HyperdyneWY8" }, { "▀", hl = "HyperdyneWY7" }, { "▀", hl = "HyperdyneWY19" }, { "▀▀▀▀▀▀", hl = "HyperdyneWY18" }, { "▀", hl = "HyperdyneWY10" }, { "▀", hl = "HyperdyneWY17" }, { "▀", hl = "HyperdyneWY16" }, { "▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" } },
	{ { "▀▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY23" }, { "▀", hl = "HyperdyneWY24" }, { "▀▀▀▀▀", hl = "HyperdyneWY23" }, { "▀", hl = "HyperdyneWY25" }, { "▀", hl = "HyperdyneWY21" }, { "▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY26" }, { "▀", hl = "HyperdyneWY27" }, { "▀▀▀▀", hl = "HyperdyneWY23" }, { "▀", hl = "HyperdyneWY24" }, { "▀", hl = "HyperdyneWY27" }, { "▀", hl = "HyperdyneWY20" }, { "▀▀", hl = "HyperdyneWY4" }, { "▀", hl = "HyperdyneWY20" }, { "▀", hl = "HyperdyneWY27" }, { "▀", hl = "HyperdyneWY24" }, { "▀▀▀▀", hl = "HyperdyneWY23" }, { "▀", hl = "HyperdyneWY27" }, { "▀", hl = "HyperdyneWY26" }, { "▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY21" }, { "▀", hl = "HyperdyneWY25" }, { "▀▀▀▀▀", hl = "HyperdyneWY23" }, { "▀", hl = "HyperdyneWY24" }, { "▀", hl = "HyperdyneWY23" }, { "▀", hl = "HyperdyneWY13" }, { "▀▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" } },
	{ { "▀▀▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY14" }, { "▀", hl = "HyperdyneWY28" }, { "▀", hl = "HyperdyneWY29" }, { "▀▀▀▀▀", hl = "HyperdyneWY30" }, { "▀", hl = "HyperdyneWY31" }, { "▀", hl = "HyperdyneWY32" }, { "▀▀▀▀▀", hl = "HyperdyneWY30" }, { "▀", hl = "HyperdyneWY33" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY2" }, { "▀", hl = "HyperdyneWY34" }, { "▀▀", hl = "HyperdyneWY30" }, { "▀", hl = "HyperdyneWY34" }, { "▀", hl = "HyperdyneWY2" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY33" }, { "▀▀▀▀▀", hl = "HyperdyneWY30" }, { "▀", hl = "HyperdyneWY32" }, { "▀", hl = "HyperdyneWY31" }, { "▀▀▀▀▀", hl = "HyperdyneWY30" }, { "▀", hl = "HyperdyneWY29" }, { "▀", hl = "HyperdyneWY28" }, { "▀", hl = "HyperdyneWY14" }, { "▀▀▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" } },
	{ { "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY7" }, { "▀", hl = "HyperdyneWY35" }, { "▀", hl = "HyperdyneWY36" }, { "▀▀▀▀▀▀▀▀", hl = "HyperdyneWY37" }, { "▀", hl = "HyperdyneWY36" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY14" }, { "▀", hl = "HyperdyneWY38" }, { "▀", hl = "HyperdyneWY39" }, { "▀", hl = "HyperdyneWY20" }, { "▀▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY20" }, { "▀", hl = "HyperdyneWY39" }, { "▀", hl = "HyperdyneWY38" }, { "▀", hl = "HyperdyneWY14" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY36" }, { "▀▀▀▀▀▀▀▀", hl = "HyperdyneWY37" }, { "▀", hl = "HyperdyneWY36" }, { "▀", hl = "HyperdyneWY35" }, { "▀", hl = "HyperdyneWY7" }, { "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" } },
	{ { "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY7" }, { "▀", hl = "HyperdyneWY13" }, { "▀▀▀▀▀▀", hl = "HyperdyneWY20" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY7" }, { "▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY20" }, { "▀▀▀▀▀▀▀▀", hl = "HyperdyneWY40" }, { "▀", hl = "HyperdyneWY20" }, { "▀", hl = "HyperdyneWY1" }, { "▀", hl = "HyperdyneWY7" }, { "▀", hl = "HyperdyneWY13" }, { "▀▀▀▀▀▀", hl = "HyperdyneWY20" }, { "▀", hl = "HyperdyneWY13" }, { "▀", hl = "HyperdyneWY7" }, { "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀", hl = "HyperdyneWY1" } },
}

function M.section()
	local text = {
		{ "╔═════════════[ ", hl = "HyperdyneWYBorder" },
		{ "W E Y L A N D - Y U T A N I   C O R P", hl = "HyperdyneWYTitle" },
		{ " ]══════════════╗\n", hl = "HyperdyneWYBorder" },
	}
	for _, row in ipairs(M.rows) do
		table.insert(text, { "║", hl = "HyperdyneWYBorder" })
		for _, seg in ipairs(row) do
			table.insert(text, seg)
		end
		table.insert(text, { "║\n", hl = "HyperdyneWYBorder" })
	end
	vim.list_extend(text, {
		{ "╚══════════[ ", hl = "HyperdyneWYBorder" },
		{ "B U I L D I N G   B E T T E R   W O R L D S", hl = "HyperdyneWYMotto" },
		{ " ]═══════════╝\n", hl = "HyperdyneWYBorder" },
		{ "┌─[ ", hl = "HyperdyneWYBoxBorder" },
		{ "NVIM-CORE // SOURCE & BUFFER OPERATIONS", hl = "HyperdyneWYBoxLabel" },
		{ " ]───────────[ ", hl = "HyperdyneWYBoxBorder" },
		{ "13-231-1", hl = "HyperdyneWYBoxLabel" },
		{ " ]─┐\n", hl = "HyperdyneWYBoxBorder" },
		{ "│ ", hl = "HyperdyneWYBoxBorder" },
		{ "FUNCTION : TREESITTER AST · LSP DIAGNOSTICS · DIFF/PATCH SYNTHESIS", hl = "HyperdyneWYBoxText" },
		{ " │\n", hl = "HyperdyneWYBoxBorder" },
		{ "│ ", hl = "HyperdyneWYBoxBorder" },
		{ "PROTOCOL : CREST-CRT AMBER-4       // CLEARANCE: SYNTHETIC OPS    ", hl = "HyperdyneWYBoxText" },
		{ " │\n", hl = "HyperdyneWYBoxBorder" },
		{ "│ ", hl = "HyperdyneWYBoxBorder" },
		{ "DIRECTIVE: BUILDING BETTER SOFTWARE                               ", hl = "HyperdyneWYBoxText" },
		{ " │\n", hl = "HyperdyneWYBoxBorder" },
		{ "└────────────────────────────────────────────────────────────────────┘", hl = "HyperdyneWYBoxBorder" },
	})
	return {
		text = text,
		align = "center",
		padding = 1,
	}
end

return M
