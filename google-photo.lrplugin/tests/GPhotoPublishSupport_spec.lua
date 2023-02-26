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

	describe("deletePhotosFromPublishedCollection", function()
		describe("when passed an empty list of photo IDs", function()
			it("should not call the callback", function()
				local deleteCallbackSpy = spy.new(function() end)

				---@diagnostic disable-next-line: undefined-global
				GPhotoPublishSupport.deletePhotosFromPublishedCollection(nil, {}, deleteCallbackSpy)

				assert.spy(deleteCallbackSpy).was.not_called()
			end)
		end)

		describe("when passed a number of photo IDs", function()
			it("should pass each photoId to the callback", function()
				local deleteCallbackSpy = spy.new(function() end)

				---@diagnostic disable-next-line: undefined-global
				GPhotoPublishSupport.deletePhotosFromPublishedCollection(nil, { 4, 5, 6 }, deleteCallbackSpy)

				assert.spy(deleteCallbackSpy).was.called(3)
				assert.spy(deleteCallbackSpy).was.called_with(4)
				assert.spy(deleteCallbackSpy).was.called_with(5)
				assert.spy(deleteCallbackSpy).was.called_with(6)
			end)
		end)
	end)

	describe("metadataThatTriggersRepublish", function()
		it("should return a table with the correct keys", function()
			---@diagnostic disable-next-line: undefined-global
			local metadata = GPhotoPublishSupport.metadataThatTriggersRepublish()

			assert.are.same({
				default = false,
				title = false,
				caption = false,
				keywords = false,
				gps = false,
				dateCreated = false,
			}, metadata)
		end)
	end)
end)
