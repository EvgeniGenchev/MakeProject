--- Script that generates project layouts based on language\framework and licenses
-- @author Evgeni Genchev
-- @license MIT

local company, p_type, l_type = ...

local supportedProjects = {["pentest"] = 1, ["python"] = 2, ["c"] = 3, ["c++"] = 4, ["fast_api"] = 5, ["lua"] = 6}
local supportedLicenses = {["mit"] = true, ["apache"] = true, ["isc"] = true, ["bsd"] = true, ["gpl3"] = true}


function NoProjectNameException()
	print("No project name provided!")
	print("Syntax: mkprj <PROJECT NAME> <PROJECT_TYPE>")
	os.exit()
end


function NoProjectTypeException()
	print("No project type provided!")
	print("Syntax: mkprj <PROJECT NAME> <PROJECT_TYPE>")
	os.exit()
end


function IllegalProjectTypeException(p_type)
	print("Project type '" .. p_type .. "' not supported")
	print("Supported types: pentest, python, c, c++, fast_api")
	os.exit()
end

function IllegalLicenseException(l_type)
	print("License type '" .. l_type .. "' not supported")
	print("Supported types: mit, apache, isc, bsd, gpl3")
	os.exit()
end


--- Strips spaces from end and start of the sting
-- @param str A string that needs "trimming"
-- @return Stripped string
local function strip(str)
	local n = string.len(str)

	local startIndex, endIndex = 0, 0

	--- Iterate over a string and log the empty whitespace before the string
	-- @param strg The string that is going to be checked
	-- @param pos The position till when the string should be checked
	-- @retun count The count of whitespaces before a the first letter
	local function spaceChecker(strg, pos)
		local count = 0
		for i = 1, pos, 1 do
			if strg:sub(i,i) == " " then
				count = count + 1
			else break end
		end
		return count
	end

	startIndex = spaceChecker(str, n) + 1
	endIndex = n - spaceChecker(str:reverse(), n - startIndex)

	return str:sub(startIndex, endIndex)

end

--- Check if the all the arguments are present and legal
local function check_args()
	if not company then
		NoProjectNameException()
	else
		p_type = strip(p_type:lower())

		if not p_type then
			NoProjectTypeException()
		end
		if not supportedProjects[p_type] then
			IllegalProjectTypeException(p_type)
		end
		if not (l_type==nil) then

			l_type = strip(l_type:lower())

			if not supportedLicenses[l_type] then
				IllegalLicenseException(l_type)
			end
		end
	end
	return true
end



if check_args() then
	local pwd = os.getenv("PWD")
	os.execute("cd " .. pwd)
end


