Preset = {}

local Base64 = require("Libraries/Base64")

function Preset.Get()
    local c = Ext.Entity.Get(Osi.GetHostCharacter()):GetAllComponents()

    return {
        Icon = Base64.Encode(c.CustomIcon.Icon),
        AdditionalChoices = Ext.Types.Serialize(c.CharacterCreationAppearance.AdditionalChoices),
        Elements = Ext.Types.Serialize(c.CharacterCreationAppearance.Elements),
        Visuals = Ext.Types.Serialize(c.CharacterCreationAppearance.Visuals),
        EyeColor = c.CharacterCreationAppearance.EyeColor,
        HairColor = c.CharacterCreationAppearance.HairColor,
        SecondEyeColor = c.CharacterCreationAppearance.SecondEyeColor,
        SkinColor = c.CharacterCreationAppearance.SkinColor,
        BodyShape = c.CharacterCreationStats.BodyShape,
        BodyType = c.CharacterCreationStats.BodyType,
        Race = c.CharacterCreationStats.Race,
        Subrace = c.CharacterCreationStats.SubRace,
        RootTemplateId = c.GameObjectVisual.RootTemplateId,
        Voice = c.Voice.Voice,
        AccessorySet = c.LevelUp.LevelUps[1].AccessorySet,
        Origin = c.Origin.field_18
    }
end

function Preset.Set(p)
    local e = Ext.Entity.GetAllEntitiesWithComponent("CCCharacterDefinition")[1]
    local d = e.CCCharacterDefinition

    d.Definition.Visual.Icon = Base64.Decode(p.Icon)
    d.Definition.Visual.AdditionalChoices = p.AdditionalChoices
    d.Definition.Visual.Elements = p.Elements
    d.Definition.Visual.Visuals = p.Visuals
    d.Definition.Visual.EyeColor = p.EyeColor
    d.Definition.Visual.HairColor = p.HairColor
    d.Definition.Visual.SecondEyeColor = p.SecondEyeColor
    d.Definition.Visual.SkinColor = p.SkinColor
    d.Definition.Definition.BodyShape = p.BodyShape
    d.Definition.Definition.BodyType = p.BodyType
    d.Definition.Definition.Race = p.Race
    d.Definition.Definition.Subrace = p.Subrace
    d.Definition.Definition.RootTemplate = p.RootTemplateId
    d.Definition.Definition.Voice = p.Voice
    d.Definition.LevelUpData.AccessorySet = p.AccessorySet
    d.NeedsSync = true
    d.ChangeId = (d.ChangeId or 0) + 1

    e:Replicate("CCCharacterDefinition")
end

return Preset
