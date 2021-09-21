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

local function showCustomDialogWithObserver()

	LrFunctionContext.callWithContext( "showCustomDialogWithObserver", function( context )
	
        local f = LrView.osFactory()

        local props = LrBinding.makePropertyTable( context )
		props.myObservedString = "Ankit Kanojia"
	    props.isChecked = true
		props.selectedButton = "male"
		
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
                f:push_button {
					title = "Normal Dialog",
					action = function()
                        LrDialogs.message("Form Values", "Simple dialog button")
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
				spacing = f:control_spacing(),
                f:static_text {
                    fill_horizontal = 1,
                    text_color = LrColor( 1, 0, 0 ),
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
				title = "Custom Dialog Observer",
				contents = c
			}

	end) -- end main function

end

showCustomDialogWithObserver()
