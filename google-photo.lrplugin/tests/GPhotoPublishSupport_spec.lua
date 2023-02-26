local mock_import = require("test_helper").mock_import
local mock_import_reset = require("test_helper").mock_import_reset
local mock_lightroom_globals = require("test_helper").mock_lightroom_globals

local GPhotoAPIMock = {}

describe("GPhotoPublishSupport", function()
	before_each(function()
		mock_import({
			LrDialogs = function()
				return "but it's unused!"
			end,
		})

		mock_lightroom_globals()

		package.loaded["GPhotoAPI"] = GPhotoAPIMock
		_G.GPhotoAPI = GPhotoAPIMock

		require("GPhotoPublishSupport")
	end)

	after_each(function()
		mock_import_reset()
	end)

	describe("getCollectionBehaviorInfo", function()
		it("should return a table with the correct keys", function()
			---@diagnostic disable-next-line: undefined-global
			local collectionBehaviorInfo = GPhotoPublishSupport.getCollectionBehaviorInfo()

			assert.are.same({
				defaultCollectionName = "$$$/GPhoto/DefaultCollectionName/Photostream=Photos",
				defaultCollectionCanBeDeleted = false,
				canAddCollection = true,
				maxCollectionSetDepth = 0,
			}, collectionBehaviorInfo)
		end)
	end)
end)
