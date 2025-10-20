return {
	{
		"maxmx03/fluoromachine.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local fm = require("fluoromachine")

			fm.setup({
				glow = true,
				theme = "fluoromachine",
				transparent = false,
				colors = function(_, color)
					local darken = color.darken
					local lighten = color.lighten
					local blend = color.blend
					local shade = color.shade
					local tint = color.tint
					return {
						bg = "#10001e",
						bgdark = darken("#10001e", 20),
						cyan = "#49eaff",
						red = "#ff1e34",
						yellow = "#ffe756",
						orange = "#f38e21",
						pink = "#ffadff",
						purple = "#9544f7",
					}
				end,
			})
			vim.cmd.colorscheme("fluoromachine")
		end,
	},
}
