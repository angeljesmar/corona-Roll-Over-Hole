settings = {}

local json = require("json")

function saveTable( table, file )
	local jsonTable = json.encode(table)

	local path = system.pathForFile( file, system.DocumentsDirectory )
	local file = io.open( path, "w" )
	print(jsonTable)
	file:write( jsonTable )
	io.close( file )
    file = nil
end

function loadTable( file )
	local path = system.pathForFile( file, system.DocumentsDirectory )
	local file = io.open( path, "r" )
	if file then
		local saveData = file:read( "*a" )
		io.close( file )

		local jsonRead = json.decode(saveData)
		print(saveData)
		return jsonRead and jsonRead.value or nil
	else
		return nil
	end 
end

return settings