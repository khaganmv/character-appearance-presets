local Channels = require("Shared/Channels")

MCM.EventButton.RegisterCallback("cap_save_button", function () 
    if not Ext.Net.IsHost() then
        MCM.EventButton.ShowFeedback("cap_save_button", "Load an existing character to save their preset.", "error")
        return
    end
    
    local filename = MCM.Get("cap_text")
    
    Channels.SavePresetChannel:RequestToServer(
        { filename = filename }, 
        function (response)
            if response.result.success then
                MCM.EventButton.ShowFeedback("cap_save_button", response.result.message, "success")
            else
                MCM.EventButton.ShowFeedback("cap_save_button", response.result.message, "error")
            end
        end
    )
end)

MCM.EventButton.RegisterCallback("cap_load_button", function ()    
    if not Ext.Net.IsHost() then
        MCM.EventButton.ShowFeedback("cap_load_button", "Start a new game to load a preset.", "error")
        return
    end
    
    local filename = MCM.Get("cap_text")
    
    Channels.LoadPresetChannel:RequestToServer(
        { filename = filename }, 
        function (response)
            if response.result.success then
                MCM.EventButton.ShowFeedback("cap_load_button", response.result.message, "success")
            else
                MCM.EventButton.ShowFeedback("cap_load_button", response.result.message, "error")
            end
        end
    )
end)
