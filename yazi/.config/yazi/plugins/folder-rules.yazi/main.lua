local function setup()
  -- Available sort options
  local sortby = {
    btime = "btime",          -- sort by birth time (creation)
    mtime = "mtime",          -- sort by modified time
    atime = "atime",          -- sort by access time
    alphabetical = "alphabetical", -- sort by name
    size = "size",            -- sort by file size
    extension = "extension",  -- sort by file extension
  }

  -- Folder-specific sorting rules
  local folder_rules = {
    { name = "Downloads", sortby = sortby.mtime, reverse = true, dir_first = false },
    { name = "Documents", sortby = sortby.alphabetical, reverse = false, dir_first = false },
    { name = "Pictures",  sortby = sortby.btime, reverse = true, dir_first = false },
    { name = "Videos",    sortby = sortby.btime, reverse = true, dir_first = false },
    { name = "Music",     sortby = sortby.btime, reverse = true, dir_first = false },
    { name = "projects",  sortby = sortby.mtime, reverse = true, dir_first = false },
  }
	ps.sub("cd", function()
    local matched = false
		local cwd = cx.active.current.cwd
    for _, rule in ipairs(folder_rules) do
      if cwd:ends_with(rule.name) then
        ya.emit("sort", { rule.sortby, reverse = rule.reverse, dir_first = rule.dir_first })
        matched = true
        break
        end
    end
		if not matched then
			ya.emit("sort", { "alphabetical", reverse = false, dir_first = false })
		end
	end)
end

return { setup = setup }
