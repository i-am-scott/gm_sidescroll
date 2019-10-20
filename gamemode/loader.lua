loader = loader or {}
loader.config_path = GM.FolderName .. '/gamemode/configs/'

local paths = { 
	["shared/"] = true, 
	["client/"] = CLIENT, 
	["server/"] = SERVER 
}

function loader.GetConfig(fn)
	if fn:sub(-4) ~= ".lua" then
		fn = fn .. ".lua"
	end

	for folder, canuse in pairs(paths) do
		if not canuse then
			continue
		end

		local path = loader.config_path .. folder .. fn
		if file.Exists(path, "LUA") then
			local config = include(path)
			if not config then
				continue
			end

			return config
		end
	end
	return nil
end

function loader.GetConfigFolder(fn, recursive, keysAsFolderNames)
	local realmpath   = SERVER and "server/" or "client/"
	local files, dirs = file.Find(loader.config_path .. "shared/"  .. fn .. "/*" ,  "LUA")

	if (not files or #files == 0) and (not dirs or #dirs == 0) then
		files, dirs = file.Find(loader.config_path .. realmpath  .. fn .. "/*"  ,  "LUA")
	else
		realmpath   = "shared/"
	end

	local configs = { }
	for _, filename in ipairs(files or {}) do
		local config = include(loader.config_path .. realmpath .. fn ..  "/" .. filename)
		if keysAsFolderNames then
			configs[filename:Replace(".lua", "")] = config
		else
			configs[#configs+1] =config
		end
	end

	if recursive then
		for _, dirname in ipairs(dirs or {}) do
			configs[dirname] = loader.GetConfigFolder(fn ..  "/" .. dirname, recursive, keysAsFolderNames)
		end
	end

	return configs
end

function loader.PrepareRecursive(strpath, depth, curdepth)
	strpath  = strpath[#strpath] == "/" and strpath or strpath .. "/"
	curdepth = curdepth or 0

    if curdepth == 0 then
        local last = string.Explode('/', strpath, false)
        last = last[#last-1]
        MsgC(col.red, '| ')
        print('Module ' .. last .. ' was loaded!')
    end

	local files, directories = file.Find(strpath .. "*", "LUA", "namedesc")
	for _, fn in ipairs(files or {}) do
		loader.PrepareFile(strpath, fn)
	end

	if depth and curdepth == depth then
		return
	end

	for _, dir in ipairs(directories or {}) do
		loader.PrepareRecursive(strpath .. dir, depth, curdepth + 1)
	end
end

function loader.PrepareFile(path, fn)
	if not path or not fn then
		return
	end

	local prefix = fn:sub(1, 3)
	if prefix == "sh_" then
		if SERVER then
			AddCSLuaFile(path .. fn)
		end
		include(path .. fn)
	elseif prefix == "ui_" or prefix == "cl_" then
		if SERVER then
			AddCSLuaFile(path .. fn)
		else
			include(path .. fn)
		end
	elseif SERVER then
		include(path .. fn)
	end
end

function loader.AddWorkshopItems(data)
	for _, ws_id in ipairs(data) do
		resource.AddWorkshop(ws_id)
	end
end

local function proccessFiles(path, func, deepAdd, mode)
	if not func then
			return
	end

	path = path[#path] == "/" and path or path .. "/"

	local files, dirs = file.Find(path .. "*", mode or "LUA")
	if not (files and dirs) or (#files == 0 and #dirs == 0) then
		return
	end

	if deepAdd and dirs then
		for I = 1, #dirs do
			local dir = dirs[I]
			if not dir then
					continue
			end
			proccessFiles(Format("%s%s/", path, dir),
					func,
					deepAdd,
					mode )
		end
	end

	for I = 1, #files do
		local file = files[I]
		if not file then
			continue
		end
		func(path .. file)
	end
end

function loader.AddCSLuaDir(path, deepAdd)
	proccessFiles(path, AddCSLuaFile, deepAdd)
end

function loader.IncludeDir(path, deepAdd)
	proccessFiles(path, include, deepAdd)
end

function loader.AddResources(path, deepAdd)
	proccessFiles(path, resource.AddFile, deepAdd, "GAME")
end