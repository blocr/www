local b = require('cmark.builder')
local lc = require('lcmark')
local lfs = require('lfs')
local date = require('date')

function metadata(filename)
    local fh = assert(io.open(filename, "rb"))
    local content = fh:read("*all")
    local body, meta = lc.convert(content, "html", {yaml_metadata = true})
    fh:close()
    return meta
end

function posts_list()
    local posts = {}
    local list = {}
    for file in lfs.dir("posts") do
        if string.match(file, ".*[.]md") then
            local f = "posts" .. '/' .. file
            local m = metadata("posts/" .. file)
            m.path = f
            table.insert(posts, m)
        end
    end
    -- sort posts by publish date
    table.sort(posts, function(p1, p2) return date(p1.date) > date(p2.date) end)
    for _, v in ipairs(posts) do
        table.insert(list, b.item{ 
            b.link{
                url = v.path:gsub("%.md", ".html"), v.title
            },
            b.html_block("<date>" .. v.date .. "</date>"),
            b.html_block("<span>" .. v.abstract .. "</span>")
        })
    end
    return list
end

return function(doc, meta, format)
    local list = posts_list()
    node_append_child(doc, b.bullet_list{ list, tight = true})
end
