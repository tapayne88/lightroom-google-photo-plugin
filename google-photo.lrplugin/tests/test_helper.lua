local utils = require("utils")

local M = {}

local LrLogger = function()
	local logger = {}

	function logger:info() end
	function logger:trace() end
	function logger:enable() end

	return logger
end

function M.mock_import(mocks)
	local defaults = {
		LrLogger = LrLogger,
	}

	function _G.import(lr_module_name)
		local mocked_modules = utils.merge(defaults, mocks)

		if mocked_modules[lr_module_name] == nil then
			print("unmocked call to `import('" .. lr_module_name .. "')")
		end

		return mocked_modules[lr_module_name]
	end
end

function M.mock_import_reset()
	_G.import = nil
end

function M.mock_lightroom_globals()
	function _G.LOC(string)
		return string
	end
end

return M
