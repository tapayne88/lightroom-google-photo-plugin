local mock_import = require("test_helper").mock_import
local mock_import_reset = require("test_helper").mock_import_reset

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

	after_each(function()
		mock_import_reset()
	end)

	describe("URLHandler", function()
		local url_with_code = "lightroom://org.tapayne88.lightroom-google-photo-plugin#?code=abc123"
		local url_without_code = "lightroom://org.tapayne88.lightroom-google-photo-plugin"
		local non_lr_url = ""

		describe("when GPhotoAPI.URLCallback is set", function()
			describe("and the handler is called with a URL containing a code", function()
				before_each(function()
					GPhotoAPIMock.URLCallback = spy.new(function() end)
				end)

				it("should call GPhotoAPI.URLCallback with the URLs code param", function()
					GPhotoURLHandler.URLHandler(url_with_code)

					assert.spy(GPhotoAPIMock.URLCallback).was.called()
					assert.spy(GPhotoAPIMock.URLCallback).was.called_with("abc123")
				end)
			end)

			describe("and the handler is called with a URL not containing a code", function()
				before_each(function()
					GPhotoAPIMock.URLCallback = spy.new(function() end)
				end)

				it("should call GPhotoAPI.URLCallback with nil", function()
					GPhotoURLHandler.URLHandler(url_without_code)

					assert.spy(GPhotoAPIMock.URLCallback).was.called()
					assert.spy(GPhotoAPIMock.URLCallback).was.called_with(nil)
				end)
			end)

			describe("and the handler is called with a non lightroom URL", function()
				before_each(function()
					GPhotoAPIMock.URLCallback = spy.new(function() end)
				end)

				it("should call GPhotoAPI.URLCallback with nil", function()
					GPhotoURLHandler.URLHandler(non_lr_url)

					assert.spy(GPhotoAPIMock.URLCallback).was.called()
					assert.spy(GPhotoAPIMock.URLCallback).was.called_with(nil)
				end)
			end)
		end)

		describe("and GPhotoAPI.URLCallback is not set", function()
			describe("and the handler is called with a URL containing a code", function()
				before_each(function()
					GPhotoAPIMock.URLCallback = nil
				end)

				it("shouldn't call GPhotoAPI.URLCallback or error", function()
					assert.has_no.errors(function()
						GPhotoURLHandler.URLHandler(url_with_code)
					end)
				end)
			end)

			describe("and the handler is called with a URL not containing a code", function()
				before_each(function()
					GPhotoAPIMock.URLCallback = nil
				end)

				it("shouldn't call GPhotoAPI.URLCallback or error", function()
					assert.has_no.errors(function()
						GPhotoURLHandler.URLHandler(url_with_code)
					end)
				end)
			end)
		end)
	end)
end)
