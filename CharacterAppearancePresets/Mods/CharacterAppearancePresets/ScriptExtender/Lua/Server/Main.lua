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

local function LoadPresetInCharacterCreation(p)
    if not Utils.IsCompatibleOrigin(p.Origin) then
        error({ message = "Character and preset origins are incompatible."})
    end
    
    Preset.SetInCharacterCreation(p)
end 

local function LoadPresetInGame(p)
    if not Utils.IsCompatibleRaceAndSubrace(p.Race, p.Subrace) then
        error({ message = "Character and preset race and subrace are incompatible." })
    end
    
    Preset.SetInGame(p)
end 

local function LoadPreset(filename)
    if not Utils.IsInCharacterCreation() and not Utils.IsInGame() then
        return {
            success = false,
            message = "Presets can only be loaded during character creation or in-game."
        }
    end
    
    local success, json = pcall(Ext.IO.LoadFile, MOD_DIRECTORY .. filename)
    if not success then
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

    local success, err
    if Utils.IsInCharacterCreation() then
        success, err = pcall(LoadPresetInCharacterCreation, preset)
    elseif Utils.IsInGame() then
        success, err = pcall(LoadPresetInGame, preset)
    end
    if not success then
        return {
            success = false,
            message = err.message
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
