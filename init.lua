-- vim:foldmethod=marker
--Basic Vim config recommended after installation(sane defaults){{{
--Nvim default config(You probably won't edit this much.)
-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.acd = true
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

--seems to not work.
-- [[ Setting options ]] See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Print the line number in front of each line
vim.o.number = true

-- Use relative line numbers, so that it is easier to jump with j, k. This will affect the 'number'
-- option above, see `:h number_relativenumber`
vim.o.relativenumber = false

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		vim.o.clipboard = "unnamedplus"
	end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Show <n> and trailing spaces
vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ "t", "i" }, "<A-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set({ "t", "i" }, "<A-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set({ "t", "i" }, "<A-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set({ "t", "i" }, "<A-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set({ "n" }, "<A-h>", "<C-w>h")
vim.keymap.set({ "n" }, "<A-j>", "<C-w>j")
vim.keymap.set({ "n" }, "<A-k>", "<C-w>k")
vim.keymap.set({ "n" }, "<A-l>", "<C-w>l")
-- [[ Add optional packages ]]
-- Nvim comes bundled with a set of packages that are not enabled by
-- default. You can enable any of them by using the `:packadd` command.

-- For example, to add the 'nohlsearch' package to automatically turn off search highlighting after
-- 'updatetime' and when going to insert mode
vim.cmd("packadd! nohlsearch")
--}}}
--Autocommands{{{
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})
--}}}
--Create user commands{{{
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command("GitBlameLine", function()
	local line_number = vim.fn.line(".") -- Get the current line number. See `:h line()`
	local filename = vim.api.nvim_buf_get_name(0)
	print(vim.fn.system({ "git", "blame", "-L", line_number .. ",+1", filename }))
end, { desc = "Print the git blame for the current line" })

vim.api.nvim_create_user_command("Zigrun", function()
	local filename = vim.api.nvim_buf_get_name(0)
	vim.cmd("w")
	print(vim.fn.system({ "zig", "run", filename }))
end, { desc = "Run the current Zig buffer" })

vim.api.nvim_create_user_command("Zigbuild", function()
	vim.cmd("w")
	print(vim.fn.system({ "zig", "build" }))
end, { desc = "Compile the Zig project" })

vim.api.nvim_create_user_command("Zigtest", function()
	local filename = vim.api.nvim_buf_get_name(0)
	vim.cmd("w")
	print(vim.fn.system({ "zig", "test", filename }))
end, { desc = "Test the current Zig buffer" })

vim.api.nvim_create_user_command("Pyrun", function()
	local filename = vim.api.nvim_buf_get_name(0)
	vim.cmd("w")
	print(vim.fn.system({ "python", filename }))
end, { desc = "Run the current Python buffer" })
vim.api.nvim_create_user_command("Luarun", function()
	local filename = vim.api.nvim_buf_get_name(0)
	vim.cmd("w")
	print(vim.fn.system({ "lua", filename }))
end, { desc = "Run the current Lua buffer" })
vim.api.nvim_create_user_command("Dotnetrun", function()
	vim.cmd("w")
	vim.cmd("split")
	vim.cmd("terminal dotnet run")
end, { desc = "Run the current Dotnet project" })
--}}}
--Custom keybinds{{{
--The bindings for Telescope and Ranger aren't here they are in the Telescope configuration as they use require or other functions for
--their keybinds.
vim.keymap.set({ "i", "n" }, "<C-f>", function()
	vim.cmd("Telescope find_files")
end)
vim.keymap.set({ "i", "n" }, "<C-p>", function()
	vim.cmd("tabprevious")
end)
vim.keymap.set({ "i", "n" }, "<C-n>", function()
	vim.cmd("tabnext")
end)
vim.keymap.set({ "i", "n" }, "<C-A-t>", function()
	vim.cmd("split")
	vim.cmd("terminal")
end)
vim.keymap.set({ "n" }, "<leader>zr", function()
	vim.cmd("Zigrun")
end, { desc = "Zig Run" })
vim.keymap.set({ "n" }, "<leader>pe", function()
	vim.cmd("Pyrun")
end, { desc = "Python Run" })
vim.keymap.set({ "n" }, "<leader>le", function()
	vim.cmd("Luarun")
end, { desc = "Lua Run" })
vim.keymap.set({ "n" }, "<leader>zc", function()
	vim.cmd("Zigbuild")
end, { desc = "Zig Build" })
vim.keymap.set({ "n" }, "<leader>zt", function()
	vim.cmd("Zigtest")
end, { desc = "Zig Test" })
vim.keymap.set({ "n" }, "<leader>dr", function()
	vim.cmd("Dotnetrun")
end, { desc = "Dotnet Run" })
vim.keymap.set({ "n" }, "<C-d>", function()
	vim.cmd("foldclose")
end)
vim.keymap.set({ "n", "i" }, "<C-A-f>", function()
	vim.cmd("lua require('conform').format()")
	vim.cmd("w")
end)
--}}}
--Lsp servers to be enabled and configured.{{{
--Enable and mason setup{{{
--vim.lsp.start()
require("config.lazy")
require("mason").setup()
--enable LSP SERVERS and setup LSP servers
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")
vim.lsp.enable("markdown_oxide")
--vim.lsp.enable('jsonls')
--vim.lsp.enable('pylyzer')
vim.lsp.enable("omnisharp")
vim.lsp.enable("zls")
vim.lsp.enable("tombi")
vim.lsp.enable("html")
vim.lsp.enable("css_variables")
vim.lsp.enable("cssls")
vim.lsp.enable("biome")
vim.lsp.enable("ts_ls")
--}}}
--Lua{{{
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
})
--}}}
--Clangd{{{
vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objcpp", "cuda" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
})
--}}}
--zls{{{
vim.lsp.config("zls", {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = { "zls.json", "build.zig", ".git" },
	workspace_required = false,
})
--}}}
--markdown oxide{{{
vim.lsp.config("markdown_oxide", {
	cmd = { "markdown-oxide" },
	filetypes = { "markdown", "md" },
	on_attach = function(client, bufnr)
		for _, cmd in ipairs({ "today", "tomorrow", "yesterday" }) do
			vim.api.nvim_buf_create_user_command(
				bufnr,
				"Lsp" .. ("%s"):format(cmd:gsub("^%l", string.upper)),
				function()
					command_factory(client, bufnr, cmd)
				end,
				{
					desc = ("Open %s daily note"):format(cmd),
				}
			)
		end
	end,

	root_markers = { ".git", ".obsidian", ".moxide.toml" },
})
--}}}
--Omnisharp {{{
vim.lsp.config("omnisharp", {
	workspace = {
		workspaceFolders = false,
	},
	cmd = {
		"OmniSharp",
		"-z",
		"--hostPID",
		"12345",
		"DotNet:enablePackageRestore=false",
		"--encoding",
		"utf-8",
		"--languageserver",
	},
	filetypes = { "cs", "vb" },
	init_options = {},
	root_markers = { ".sln", ".csproj", "omnisharp.json", "function.json" },
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
		},
		MsBuild = {},
		RenameOptions = {},
		RoslynExtensionsOptions = {},
		Sdk = {
			IncludePrereleases = true,
		},
	},
})
vim.lsp.config("tombi", {
	cmd = { "tombi", "lsp" },
	filetypes = { "toml" },
	root_markers = { "tombi.toml", "pyproject.toml", ".git" },
})
--}}}
--html{{{
vim.lsp.config("html", {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetyps = { "html", "templ" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = false,
	},
	root_markers = { "package.json", ".git" },
	settings = {},
})
--}}}
--css_variables{{{
vim.lsp.config("css_variables", {
	cmd = { "css-variables-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { ".git" },
	settigs = {
		cssVariables = {
			blacklistFolders = {
				"**/.cache",
				"**/.DS_Store",
				"**/.git",
				"**/.hg",
				"**/.next",
				"**/.svn",
				"**/bower_components",
				"**/CVS",
				"**/dist",
				"**/node_modules",
				"**/tests",
				"**/tmp",
			},
			lookupFiles = { "**/*.less", "**/*.scss", "**/*.sass", "**/*.css" },
		},
	},
})
--}}}
--cssls{{{
vim.lsp.config("cssls", {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	init_options = {
		provideFormatter = true,
	},
	root_markers = { "package.json", ".git" },
	settings = {
		css = {
			validate = true,
		},
		less = {
			validate = true,
		},
		scss = {
			validate = true,
		},
	},
})
--}}}
--Biome{{{
vim.lsp.config("biome", {
	cmd = { "biome" },
	filetypes = {
		"astro",
		"graphql",
		"javascript",
		"javascriptreact",
		"svelte",
		"typescript",
		"typescript.tsx",
		"typescriptreact",
		"vue",
	},
	root_dir = function(bufnr, on_dir)
		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })
		-- We fallback to the current working directory if no project root is found
		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		-- We know that the buffer is using Biome if it has a config file
		-- in its directory tree.
		local filename = vim.api.nvim_buf_get_name(bufnr)
		local biome_config_files = { "biome.json", "biome.jsonc" }
		local is_buffer_using_biome = vim.fs.find(biome_config_files, {
			path = filename,
			type = "file",
			limit = 1,
			upward = true,
			stop = vim.fs.dirname(project_root),
		})[1]
		if not is_buffer_using_biome then
			return
		end

		on_dir(project_root)
	end,
	workspace_required = true,
})
--}}}
--ts_ls(typescript and javascript ls){{{
vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	commands = {
		["editor.action.showReferences"] = function(command, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			local file_uri, position, references = unpack(command.arguments)

			local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
			vim.fn.setqflist({}, " ", {
				title = command.title,
				items = quickfix_items,
				context = {
					command = command,
					bufnr = ctx.bufnr,
				},
			})
		end,
	},
	root_dir = function(bufnr, on_dir)
		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })
		-- We fallback to the current working directory if no project root is found
		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		on_dir(project_root)
	end,
	handlers = {
		-- handle rename request for certain code actions like extracting functions / types
		["_typescript.rename"] = function(_, result, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			vim.lsp.util.show_document({
				uri = result.textDocument.uri,
				range = {
					start = result.position,
					["end"] = result.position,
				},
			}, client.offset_encoding)
			vim.lsp.buf.rename()
			return vim.NIL
		end,
	},
  on_attach = function(client, bufnr)
    -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
    -- `vim.lsp.buf.code_action()` if specified in `context.only`.
    vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptSourceAction', function()
      local source_actions = vim.tbl_filter(function(action)
        return vim.startswith(action, 'source.')
      end, client.server_capabilities.codeActionProvider.codeActionKinds)

      vim.lsp.buf.code_action({
        context = {
          only = source_actions,
        },
      })
    end, {})
  end,
})

--}}}
--}}}
--Colorizer{{{
require("colorizer").setup({
	filetypes = { "*" }, -- Filetype options.  Accepts nle like `user_default_options`
	buftypes = {}, -- Buftype options.  Accepts nle like `user_default_options`
	-- Boolean | List of usercommands to enable.  See User commands section.
	user_commands = true, -- Enable all or some usercommands
	lazy_load = false, -- Lazily schedule buffer highlighting setup function
	user_default_options = {
		names = true, -- 'Name' codes like Blue or red.  Added from `vim.api.nvim_get_color_map()`
		names_opts = { -- options for mutating/filtering names.
			lowercase = true, -- name:lower(), highlight `blue` and `red`
			camelcase = true, -- name, highlight `Blue` and `Red`
			uppercase = false, -- name:upper(), highlight `BLUE` and `RED`
			strip_digits = false, -- ignore names with digits,
			-- highlight `blue` and `red`, but not `blue3` and `red4`
		},
		-- Expects a nle of color name to #RRGGBB value pairs.  # is optional
		-- Example: { cool = '#107dac', ["notcool"] = "ee9240" }
		-- Set to false to disable, for example when setting filetype options
		names_custom = false, -- Custom names to be highlighted: nle|function|false
		RGB = true, -- #RGB hex codes
		RGBA = true, -- #RGBA hex codes
		RRGGBB = true, -- #RRGGBB hex codes
		RRGGBBAA = true, -- #RRGGBBAA hex codes
		AARRGGBB = true, -- 0xAARRGGBB hex codes
		rgb_fn = false, -- CSS rgb() and rgba() functions
		hsl_fn = false, -- CSS hsl() and hsla() functions
		css = false, -- Enable all CSS *features*:
		-- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
		css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
		-- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
		tailwind = false, -- Enable tailwind colors
		tailwind_opts = { -- Options for highlighting tailwind names
			update_names = false, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
		},
		-- parsers can contain values used in `user_default_options`
		sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
		xterm = false, -- Enable xterm 256-color codes (#xNN, \e[38;5;NNNm)
		-- Highlighting mode.  'background'|'foreground'|'virtualtext'
		mode = "background", -- Set the display mode
		-- Virtualtext character to use
		virtualtext = "■",
		-- Display virtualtext inline with color.  boolean|'before'|'after'.  True sets to 'after'
		virtualtext_inline = false,
		-- Virtualtext highlight mode: 'background'|'foreground'
		virtualtext_mode = "foreground",
		-- update color values even if buffer is not focused
		-- example use: cmp_menu, cmp_docs
		always_update = false,
		-- hooks to invert control of colorizer
		hooks = {
			-- called before line parsing.  Accepts boolean or function that returns boolean
			-- see hooks section below
			disable_line_highlight = false,
		},
	},
})
--}}}
--{{{Ranger configuration
local ranger_nvim = require("ranger-nvim")
ranger_nvim.setup({
	enable_cmds = false,
	replace_netrw = false,
	keybinds = {
		["ov"] = ranger_nvim.OPEN_MODE.vsplit,
		["oh"] = ranger_nvim.OPEN_MODE.split,
		["ot"] = ranger_nvim.OPEN_MODE.nedit,
		["or"] = ranger_nvim.OPEN_MODE.rifle,
	},
	ui = {
		border = "none",
		height = 1,
		width = 1,
		x = 0.5,
		y = 0.5,
	},
})
--}}}
--Set up builtin completion{{{
vim.cmd([[set completeopt+=menuone,noselect,popup,preinsert]])
local triggers = { "." }
vim.api.nvim_create_autocmd("InsertCharPre", {
	buffer = vim.api.nvim_get_current_buf(),
	callback = function()
		if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
			return
		end
		local char = vim.v.char
		if vim.list_contains(triggers, char) then
			local key = vim.keycode("<C-x><C-n>")
			vim.api.nvim_feedkeys(key, "m", false)
		end
	end,
})
--}}}
--Setup Lualine.lua{{{
require("lualine").setup({
	options = { theme = "molokai" },
})
--}}}
-- Telescope config and setup{{{
local telescopeBuiltin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescopeBuiltin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescopeBuiltin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescopeBuiltin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescopeBuiltin.help_tags, { desc = "Telescope help tags" })
--}}}
-- Treesitter config and setup{{{
require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
	ensure_installed = { "lua", "markdown", "markdown_inline" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = false,

	-- List of parsers to ignore installing (or "all")
	ignore_install = {},

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = {},
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
})
--}}}
--Conform configuration(formatter){{{
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		cpp = { "clang-format" },
		cs = { "clang-format" },
		c = { "clang-format" },
		css = {"biome","format"},
		javascript = {"biome","format"},
		html = {"htmlbeautifier"}
	},
})

--}}}
--Luasnip configuration{{{
local ls = require("luasnip")
vim.keymap.set({ "i" }, "<C-p>", function()
	ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-j>", function()
	ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

--Enable (broadcasting) snippet capability for completion
require("luasnip.loaders.from_vscode").lazy_load()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("html", {
	capabilities = capabilities,
})
vim.lsp.config("cssls", {
	capabilities = capabilities,
})
--}}}
