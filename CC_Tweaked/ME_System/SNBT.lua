local function escape (escapeLvl, str)
	local output = str
	
	for i=1, escapeLvl do
		output = string.gsub(output, "\\", "\\\\")
		output = string.gsub(output, "\"", "\\\"")
	end
	
	return output
end


local function removeComma (str)
	if string.sub(str, -1, -1) == "," then --remove last comma
		str = string.sub(str, 1, -2)
	end
	
	return str
end



local SNBT = { output = "" }

function SNBT:new (obj)
	obj = obj or {}
	setmetatable(obj, self)
	self.__index = self
	
	obj.lastSave = nil
	obj.escapeLvl = 0 -- Change to 1 if not using textutils. Default 0
	
	return obj
end

function SNBT:tbl (obj)
	obj = obj or SNBT:new(obj)
	
	obj.output = ""
	obj.beginning = "{"
	obj.ending = "},"
	obj.parent = self --self refers to SNBT obj not SNBT:tbl obj
	
	return obj
end

function SNBT:arr (obj)
	obj = obj or SNBT:new(obj)
	
	obj.output = ""
	obj.beginning = "["
	obj.ending = "],"
	obj.parent = self
	
	return obj
end

function SNBT:json (tbl)
	tbl = tbl or {}
	
	local tblString = textutils.serializeJSON( textutils.serializeJSON(tbl, false), true )
	self.output = self.output .. tblString .. ","
	
	return self
end

function SNBT:key (str)
	self.output = self.output .. "\"" .. str .. "\":"
	return self
end

function SNBT:text (str)
	str = str or ""
	self.output = escape( self.escapeLvl - 1 , self.output .. "\"" .. escape(1, str) .. "\",")
	return self
end

function SNBT:raw (data)
	data = data or ""
	self.output = self.output .. data .. ","
	return self
end

function SNBT:pause ()
	local root = self
	while root.parent ~= nil do
	    root = root.parent
	end
	root.lastSave = self
    return root
end

function SNBT:resume ()
	local saved = self.lastSave
	self.lastSave = nil
	return saved
end

function SNBT:done ()	
	self.output = removeComma(self.output)
	
	self.output = self.beginning .. self.output .. self.ending
	self.parent.output = self.parent.output .. self.output
	return self.parent
end

function SNBT:allDone ()
	self.output = escape(self.escapeLvl, self.output)
	self.output = removeComma(self.output)
	-- Uncomment if you are not using textutils.serializeJSON()
	--self.output = "\"" .. self.output .. "\""
	
	return self.output
end

return SNBT