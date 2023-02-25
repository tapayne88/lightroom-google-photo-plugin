local mock_import = require("test_helper").mock_import

local GPhotoAPIMock = {}
local GPhotoURLHandler

describe("GPhotoURLHandler", function()
	before_each(function()
		mock_import({
			LrDialogs = function()
				return "but it's unused!"
			end,
		})

		package.loaded["GPhotoAPI"] = GPhotoAPIMock
		_G.GPhotoAPI = GPhotoAPIMock

		GPhotoURLHandler = require("GPhotoURLHandler")
	end)

	describe("URLHandler", function()
		describe("called with a URL containing a code and GPhotoAPI.URLCallback is set", function()
			before_each(function()
				GPhotoAPIMock.URLCallback = spy.new(function() end)
			end)

			it("calls GPhotoAPI.URLCallback with the URLs code param", function()
				GPhotoURLHandler.URLHandler("lightroom://org.tapayne88.lightroom-google-photo-plugin#?code=abc123")

				assert.spy(GPhotoAPIMock.URLCallback).was.called()
				assert.spy(GPhotoAPIMock.URLCallback).was.called_with("abc123")
			end)
		end)
	end)
end)
