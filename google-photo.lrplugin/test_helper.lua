local utils = require("utils")

local M = {}

local LrLogger = function()
	local logger = {}

	function logger:info() end
	function logger:enable() end

	return logger
end

function M.mock_import(mocks)
	local defaults = {
		LrLogger = LrLogger,
	}

	function _G.import(lr_module_name)
		local mocked_modules = utils.merge(defaults, mocks)

		if type(mocked_modules[lr_module_name]) ~= "function" then
			print("unmocked call to `import('" .. lr_module_name .. "')")
		end

		return mocked_modules[lr_module_name]
	end
end

return M
