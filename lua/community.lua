-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.python" },
  -- { import = "astrocommunity.pack.cs" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.json" },
  { import = 'astrocommunity.pack.dart'},
  -- { import = "astrocommunity.pack.angular" },
  -- { import = "astrocommunity.colorscheme.tokyodark-nvim" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.colorscheme.dracula-nvim"},
  { import = "astrocommunity.colorscheme.onedarkpro-nvim"},
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.motion.mini-surround" },
  -- { import = "astrocommunity.recipes.vscode" },
  -- { import = "astrocommunity.completion.avante-nvim" },
  { import = "astrocommunity.docker.lazydocker" },
  -- { import = "astrocommunity.workflow.hardtime-nvim" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.recipes.vscode-icons" },
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  -- import/override with your plugins folder
  -- Lsp Picker Mappings
  { import = "astrocommunity.recipes.picker-lsp-mappings" }
}
