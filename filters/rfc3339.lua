function Meta(m)
    for k,v in ipairs(m.posts) do
        v.date = pandoc.pipe("date", {"-u", "-d",
        pandoc.utils.stringify(v.date), "+%FT%TZ"}, ""):gsub('%s+', '')
    end
    return m
end
