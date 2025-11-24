local Utils = require("Server/Utils")
local Preset = require("Server/Preset")
local Channels = require("Shared/Channels")

local MOD_DIRECTORY = "CharacterAppearancePresets/"

local function SavePreset(filename)
    if not Utils.IsInGame() then
        return {
            success = false,
            message = "Presets can only be saved in-game."
        }
    end

    local success, preset = pcall(Preset.Get)
    if not success then
        return {
            success = false,
            message = "Failed to get preset."
        }
    end

    local success, json = pcall(
        Ext.Json.Stringify, 
        preset,  
        { Beautify = true }
    )
    if not success then
        return {
            success = false,
            message = "Failed to serialize preset."
        } 
    end

    local success = pcall(
        Ext.IO.SaveFile,
        MOD_DIRECTORY .. filename, 
        json
    )
    if not success then
        return {
            success = false,
            message = "Failed to save preset."
        } 
    end

    return {
        success = true,
        message = "Successfully saved preset to " .. filename .. "."
    }
end

local function LoadPreset(filename)
    if not Utils.IsInCharacterCreation() then
        return {
            success = false,
            message = "Presets can only be loaded during character creation."
        }
    end
    
    local success, json = pcall(Ext.IO.LoadFile, MOD_DIRECTORY .. filename)
    if not json then
        return {
            success = false,
            message = "Could not find file " .. filename .. "."
        }
    end

    local success, preset = pcall(Ext.Json.Parse, json)
    if not success then
        return {
            success = false,
            message = "Failed to parse JSON."
        }
    end

    if not Utils.IsCompatibleOrigin(preset.Origin) then
        return {
            success = false,
            message = "Character and preset origins are incompatible."
        }
    end

    local success = pcall(Preset.Set, preset)
    if not success then
        return {
            success = false,
            message = "Invalid JSON format."
        }
    end

    return {
        success = true,
        message = "Successfully loaded preset from " .. filename .. "."
    }
end

Channels.SavePresetChannel:SetRequestHandler(function (data, user)
    return { result = SavePreset(data.filename) }
end)

Channels.LoadPresetChannel:SetRequestHandler(function (data, user)
    return { result = LoadPreset(data.filename) }
end)
