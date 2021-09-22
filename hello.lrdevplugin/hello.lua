--[[----------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2007 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

--------------------------------------------------------------------------------

CustomDialogWithObserver.lua
From the Hello World sample plug-in. Displays several custom dialog and writes debug info.

------------------------------------------------------------------------------]]

-- Access the Lightroom SDK namespaces.

local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrLogger = import 'LrLogger'
local LrColor = import 'LrColor'
local LrLogger = import 'LrLogger'
local share = LrView.share
local LrHttp = import "LrHttp"
local LrApplication = import "LrApplication"
local catalog = LrApplication.activeCatalog()
local targetPhotos = catalog.targetPhotos
local targetPhotosCopies = targetPhotos

local function showCustomDialogWithObserver()

	LrFunctionContext.callWithContext( "showCustomDialogWithObserver", function( context )
	
        local f = LrView.osFactory()

        local props = LrBinding.makePropertyTable( context )
		props.myObservedString = "Ankit Kanojia"
	    props.isChecked = true
		props.selectedButton = "male"
		
        local filenames_field = f:edit_field {
            title = "filenames",
            height_in_lines = 10,
            width_in_chars = 40,
            value = '',
          }

		local c = f:column {
			bindToObject = props,
			spacing = f:dialog_spacing(),
            f:row{
                f:column {
                    spacing = f:control_spacing(),
                    f:radio_button {
                        title = "Male",
                        value = LrView.bind( "selectedButton" ),
                        checked_value = "male",
                    },
                    
                    f:radio_button {
                        title = "Female",
                        value = LrView.bind( "selectedButton" ),
                        checked_value = "female",
                    },
                },
            },
            f:row {
				bind_to_object = props,
				f:checkbox {
					title = "Doing JOB?",
					value = LrView.bind( "isChecked" ),
				}
			},
			f:row {
                bind_to_object = props,
                f:edit_field {
                    immediate = true,
                    value = LrView.bind( "myObservedString")
                }				
			},
            f:row{
                f:push_button {
					title = "Show Detail",
					action = function()
						--props.myObservedString = updateField.value
					end
				},
                filenames_field,
                f:push_button {
					title = "Normal Dialog",
					action = function()
                        import "LrTasks".startAsyncTask( function()
                        if targetPhotosCopies == nil then
                            LrDialogs.message("Form Values", "No photo")
                        else
                            for p, photo in ipairs(catalog:getAllPhotos()) do
                                if filenames_field.value == nil  then
                                    filenames_field.value = photo:getFormattedMetadata('fileName')
                                else
                                     filenames_field.value = filenames_field.value .. "\n" .. photo:getFormattedMetadata('fileName')
                                end
                            end
                        end
                    end)

                        -- local logs_field;
                        -- import "LrTasks".startAsyncTask( function()
                        --   logs_field.value = "Starting search\n"
                
                        --   local catalog = import "LrApplication".activeCatalog()
                        --   catalog:withWriteAccessDo("Batch set rating", function( context )
                        --     for i,photo in ipairs(catalog:getAllPhotos()) do
                        --       for fname in string.gmatch(filenames_field.value, "%w+") do
                        --         if string.find(photo:getFormattedMetadata('fileName'), fname) then
                        --           logs_field = logs_field .. rating_field.value
                        --         end
                        --       end
                        --     end
                        --   end)
                        -- end)
                        -- LrDialogs.message("Form Values", logs_field)


                        -- -- Post Method
                        -- local headers = {
                        --     { field = 'Content-Type', value = "application/x-www-form-urlencoded" }
                        -- }
                        
                        -- local name = 'morpheus1'
                        -- local job = 'leader1'
                        -- local postBody = "name=" .. name .. "&job=" .. job
                        -- import "LrTasks".startAsyncTask( function()
                        --     local response, hdrs = LrHttp.post( "https://reqres.in/api/users", postBody, headers, "POST" ,5000)
                        --     if response then
                        --         LrDialogs.message("Form Values", response)
                        --     else
                        --         LrDialogs.message("Form Values", "API issue")
                        --     end
                        -- end )

                        -- --Get Method

                        -- local headers = {
                        --     { field = 'Content-Type', value = "application/json" }
                        --     -- { field = 'Authorization', value = "auth_header" },
                        --     -- { field = 'Content-Length', value = 1000 },
                        --     -- { field = 'Content-MD5', value = LrMD5.digest( 'something' ) },
                        -- }
                        
                        -- import "LrTasks".startAsyncTask( function()
                        --     local response, hdrs = LrHttp.get( "https://reqres.in/api/products/3", headers)
                        --     LrDialogs.message("Form Values", "API call initiate")
                        --     if response then
                        --         LrDialogs.message("Form Values", response)
                        --     else
                        --         LrDialogs.message("Form Values", "API issue")
                        --     end
                        -- end )
					end
				},
            }, -- end row
            f:row {
                f:static_text {
                    title = LOC "$$$/Flickr/ExportDialog/Privacy=Privacy:",
                    alignment = 'right',
                    width = LrView.share('labelWidth'),
                },

                f:radio_button {
                    title = LOC "$$$/Flickr/ExportDialog/Private=Private",
                    checked_value = 'private',
                    value = LrView.bind('privacy')
                },
            },
            f:row {
                place = 'overlapping',
                frame_width = 50,
                f:picture {
                    value = _PLUGIN:resourceId( 'A.png' )
                }
            },
            f:row {
				spacing = f:control_spacing(),
                f:static_text {
                    fill_horizontal = 1,
                    text_color = LrColor('blue'),
                  

                    title = LrView.bind(
                    {
                        keys = {
                            {
                                key = "myObservedString"
                            },
                            {
                                key = "isChecked"
                            },
                            {
                                key = "selectedButton"
                            }
                        },  -- "selectedButton", "isChecked" -- the key value to bind to.  The property table (props) is already bound
                        operation = function( _, values, _ )
                            -- if value == "male" then
                            --     return value"Button one selected"
                            -- else
                            --     return "Button two selected"
                            -- end
                            -- if value == true then
                            --     return "checked"
                            -- else
                            --     return "not checked"
                            -- end
                            local working 
                            if values.isChecked == true then
                                working = "yes"
                            else
                                working = "no"
                            end
                            return "Name: " .. values.myObservedString .. "\nGender: " .. values.selectedButton .. "\nCompany: " .. working
                        end
                    }),
                }
            },
		} -- end column
		
		LrDialogs.presentModalDialog {
                text_color = LrColor("blue"),
				title = "Custom Dialog Observer",
				contents = c
			}

	end) -- end main function

end

showCustomDialogWithObserver()
