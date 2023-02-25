local M = {}

local function can_merge(v)
	return type(v) == "table"
end

--- Merge 2 { key => value } tables preferring the right-most value
---@param ... table Two or more map-like tables
---@return table
function M.merge(...)
	local new_table = {}

	for i = 1, select("#", ...) do
		local tbl = select(i, ...)
		if tbl then
			for k, v in pairs(tbl) do
				if can_merge(v) and can_merge(new_table[k]) then
					new_table[k] = M.merge(new_table[k], v)
				else
					new_table[k] = v
				end
			end
		end
	end

	return new_table
end

function M.dump(o)
	if type(o) == "table" then
		local s = "{ "

		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
		end

		return s .. "} "
	else
		return tostring(o)
	end
end

return M
