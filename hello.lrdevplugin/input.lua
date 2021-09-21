--local LrDialogs = import "LrDialogs"
local LrFunctionContext = import "LrFunctionContext"
local LrView = import "LrView"

LrFunctionContext.callWithContext(
    "bindingExample",
    function(context)
        local f = LrView.osFactory() -- obtain view factory
        local contents =
            f:column {
            -- define view hierarchy
            spacing = f:control_spacing(),
            f:row {
                spacing = f:label_spacing(),
                f:static_text {
                    title = "Name:",
                    alignment = "right",
                    width = LrView.share "label_width" -- the shared binding
                },
                f:edit_field {
                    width_in_chars = 20
                }
            },
            f:row {
                spacing = f:label_spacing(),
                f:static_text {
                    title = "Occupation:",
                    alignment = "right",
                    width = LrView.share "label_width" -- the shared binding
                },
                f:edit_field {
                    width_in_chars = 20
                }
            }
        }
        local result =
            LrDialogs.presentModalDialog( -- invoke the dialog
            {
                title = "Dialog Example",
                contents = contents
            }
        )
    end
)



