Utils = {}

function Utils.IsInCharacterCreation()
    return #Ext.Entity.GetAllEntitiesWithComponent("CCCharacterDefinition") > 0
end

function Utils.IsInGame()
    return #Ext.Entity.GetAllEntitiesWithComponent("CharacterCreationAppearance") > 0
end

function Utils.IsCompatibleOrigin(po)
    local ot = {
        ["a4b56492-d5ac-4a84-8e45-5437cd9da7f3"] = "Generic",
        ["5af0f42c-9b32-4c3c-b108-46c44196081b"] = "DarkUrge"
    }

    local co = Utils.IsInCharacterCreation() and (
            Ext.Entity.GetAllEntitiesWithComponent("CCCharacterDefinition")[1]
                .CCCharacterDefinition
                .Definition
                .Definition
                .Origin
        ) or (
            Ext.Entity.Get(Osi.GetHostCharacter()):GetAllComponents().Origin.field_18
        )

    if ot[co] ~= nil and ot[po] ~= nil then
        return true
    end

    return co == po
end

function Utils.IsCompatibleRaceAndSubrace(pr, psr)
    local ccs = Ext.Entity.Get(Osi.GetHostCharacter()):GetAllComponents().CharacterCreationStats

    return ccs.Race == pr and ccs.SubRace == psr
end

return Utils
