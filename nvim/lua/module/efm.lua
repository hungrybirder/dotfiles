-- luarocks install --server=https://luarocks.org/dev luaformatter
-- MacOS: brew install efm-langserver
-- Linux: go get github.com/mattn/efm-langserver
--
-- LuaFormatter https://awesomeopensource.com/project/Koihik/LuaFormatter
--
require"lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    filetypes = {"lua"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                {
                    formatCommand = "lua-format -i --column-limit=120 --no-keep-simple-function-one-line",
                    formatStdin = true
                }
            }
        }
    }
}
