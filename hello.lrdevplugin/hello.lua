local LrFunctionContext = import "LrFunctionContext"
local LrBinding = import "LrBinding"
local LrDialogs = import "LrDialogs"
local LrView = import "LrView"
local LrLogger = import "LrLogger"
local LrColor = import "LrColor"
local LrLogger = import "LrLogger"
local share = LrView.share
local LrHttp = import "LrHttp"
local LrApplication = import "LrApplication"
local catalog = LrApplication.activeCatalog()
local targetPhotos = catalog.targetPhotos
local targetPhotosCopies = targetPhotos
local JSON = require 'JSON'

local function uploadFile(filePath)
    local fileName = LrPathUtils.leafName( filePath )
    local mimeChunks = {}
    mimeChunks[ #mimeChunks + 1 ] = { name = 'api_sig', value = "test value"}
    mimeChunks[#mimeChunks + 1] = {
        name = "file",
        filePath = filePath,
        fileName = fileName,
        contentType = "image/jpeg"  --multipart/form-data  --application/octet-stream
    }
    import "LrTasks".startAsyncTask( 
        function()
            local postUrl = "http://cms.local.com/api/v1/upload"
            local result, hdrs = LrHttp.postMultipart(postUrl, mimeChunks)
            if result then
                LrDialogs.message("Image uploaded.", result)
            else
                LrDialogs.message("Error", "API issue")
            end
        end
    )
end

local function showCustomDialogWithObserver()
    LrFunctionContext.callWithContext(
        "showCustomDialogWithObserver",
        function(context)
            local f = LrView.osFactory()

            local props = LrBinding.makePropertyTable(context)
            props.myObservedString = "Ankit Kanojia"
            props.isChecked = true
            props.selectedButton = "male"

            local filenames_field =
                f:edit_field {
                title = "filenames",
                height_in_lines = 10,
                width_in_chars = 40,
                value = ""
            }

            local c =
                f:column {
                bindToObject = props,
                spacing = f:dialog_spacing(),
                f:row {
                    f:column {
                        spacing = f:control_spacing(),
                        f:radio_button {
                            title = "Male",
                            value = LrView.bind("selectedButton"),
                            checked_value = "male"
                        },
                        f:radio_button {
                            title = "Female",
                            value = LrView.bind("selectedButton"),
                            checked_value = "female"
                        }
                    }
                },
                f:row {
                    bind_to_object = props,
                    f:checkbox {
                        title = "Doing JOB?",
                        value = LrView.bind("isChecked")
                    }
                },
                f:row {
                    bind_to_object = props,
                    f:edit_field {
                        immediate = true,
                        value = LrView.bind("myObservedString")
                    }
                },
                f:row {
                    f:push_button {
                        title = "JSON convert",
                        action = function()
                             -- Get Method JSON Convert
                             local headers = {
                                { field = 'Content-Type', value = "application/json" }
                             }
                             
                             import "LrTasks".startAsyncTask( function()
                                local response, hdrs = LrHttp.get( "https://reqres.in/api/products/3", headers)
	                            filenames_field.value = JSON:decode(response).data.id
                             end )
                        end
                    }
                },        
                f:row {
                    f:push_button {
                        title = "API call Methods",
                        action = function()
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

                            --Get Method
                            -- local headers = {
                            --     { field = 'Content-Type', value = "application/json" }
                            --     -- { field = 'Authorization', value = "auth_header" },
                            --     -- { field = 'Content-Length', value = 1000 },
                            --     -- { field = 'Content-MD5', value = LrMD5.digest( 'something' ) },
                            -- }
                            -- import "LrTasks".startAsyncTask( function()
                            --     local response, hdrs = LrHttp.get( "https://reqres.in/api/products/3", headers)
                            --     --local convertedObj = JSON:encode_pretty(response)
                            --     local json = require 'json'
	                        --     local auth = json.decode(response)
                                
                            --     if response then
                            --         for k, v in pairs(auth.array) do                
                            --             LrDialogs.message("Form Values", k)
                            --         end
                            --         filenames_field.value = auth.data --convertedObj.data
                            --     else
                            --         LrDialogs.message("Form Values", json.decode(response))
                            --     end
                            -- end )
                        end
                    },
                    filenames_field,
                    f:push_button {
                        title = "Upload Images",
                        action = function()
                            import "LrTasks".startAsyncTask(
                                function()
                                    if targetPhotosCopies == nil then
                                        LrDialogs.message("Form Values", "No photo")
                                    else
                                        for p, photo in ipairs(targetPhotosCopies) do
                                            if photo:getRawMetadata('pickStatus') == 1 then
                                                --photo:getRawMetadata('path')   -- photo:getRawMetadata('fileName')
                                                uploadFile(assert(photo:getRawMetadata('path')));
                                                --filenames_field.value = filenames_field.value .. "\n" .. photo:getFormattedMetadata("fileName") .. " -- Flagged " .. photo:getRawMetadata('path')
                                            else
                                                uploadFile(assert(photo:getRawMetadata('path')));
                                                --filenames_field.value = filenames_field.value .. "\n" .. photo:getFormattedMetadata("fileName") .. " -- Not Flagged " .. photo:getRawMetadata('path')
                                            end
                                        end
                                    end
                                end
                            )
                        end
                    }
                }, -- end row
                f:row {
                    f:static_text {
                        title = LOC "$$$/Flickr/ExportDialog/Privacy=Privacy:",
                        alignment = "right",
                        width = LrView.share("labelWidth")
                    },
                    f:radio_button {
                        title = LOC "$$$/Flickr/ExportDialog/Private=Private",
                        checked_value = "private",
                        value = LrView.bind("privacy")
                    }
                },
                f:row {
                    place = "overlapping",
                    frame_width = 50,
                    f:picture {
                        value = _PLUGIN:resourceId("A.png")
                    }
                },
                f:row {
                    spacing = f:control_spacing(),
                    f:static_text {
                        fill_horizontal = 1,
                        text_color = LrColor("blue"),
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
                                }, -- "selectedButton", "isChecked" -- the key value to bind to.  The property table (props) is already bound
                                operation = function(_, values, _)
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
                                    return "Name: " ..
                                        values.myObservedString ..
                                            "\nGender: " .. values.selectedButton .. "\nCompany: " .. working
                                end
                            }
                        )
                    }
                }
            } -- end column

            local result =
                LrDialogs.presentModalDialog(
                {
                    -- display cuustom dialog
                    title = "Dialog Main Title",
                    contents = c, -- defined view hierarchy
                    cancelVerb = '< exclude >',
                    actionVerb = 'Close Window',
                }
            )
            if (result == "cancel") then --cancel the progress after pushing the "Cancel"-Button
                if progressBar ~= nil then
                   -- progressBar:setCancelable(false)
                   -- progressBar:cancel()
                end
            end
        end
    ) -- end main function
end

showCustomDialogWithObserver()
