local coq = require("coq")
local lspconfig = require("lspconfig")

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "rust_analyzer", "solargraph" }
})
local options = {on_attach=require'virtualtypes'.on_attach}
lspconfig.sumneko_lua.setup(coq.lsp_ensure_capabilities(options))
lspconfig.solargraph.setup(coq.lsp_ensure_capabilities(options))

