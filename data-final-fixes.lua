---------------------------------------------------------------------------------------------------
---> data-final-fixes.lua <---
---------------------------------------------------------------------------------------------------

--- Contenedor de funciones y datos usados
--- unicamente en este archivo
local ThisMOD = {}

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
function ThisMOD.Start()
    --- Valores de la referencia
    ThisMOD.setSetting()

    --- Crear las recetas
    ThisMOD.Create_OneResistance_Recipes()
    ThisMOD.Create_AllResistance_Recipe()

    --- Crear los objetos
    ThisMOD.Create_OneResistance_Armors()
    ThisMOD.Create_AllResistance_Armor()
end

--- Valores de la referencia
function ThisMOD.setSetting()
    --- Otros valores
    ThisMOD.Prefix    = "zzzYAIM0425-0200-"
    ThisMOD.name      = "armors-with-immunity"

    --- Armadura a duplicar
    local Default     = "light-armor"
    local Setting     = GPrefix.Setting[ThisMOD.Prefix]["armor-base"]
    local ItemBase    = GPrefix.Items[Setting] or GPrefix.Items[Default]

    --- Subgroup para este MOD
    local oldSubgroup = ItemBase.subgroup
    local newSubgroup = ThisMOD.Prefix .. ThisMOD.name
    GPrefix.duplicate_subgroup(oldSubgroup, newSubgroup)

    --- Objeto base
    ThisMOD.item                       = GPrefix.Items[ItemBase.name]
    ThisMOD.item                       = util.copy(ThisMOD.item)
    ThisMOD.item.name                  = ThisMOD.Prefix .. ThisMOD.item.name .. "-"
    ThisMOD.item.localised_description = { "" }
    ThisMOD.item.resistances           = {}
    ThisMOD.item.subgroup              = newSubgroup
    table.insert(ThisMOD.item.localised_name, " - ")

    --- Receta base
    ThisMOD.recipe                       = GPrefix.Recipes[ItemBase.name][1]
    ThisMOD.recipe                       = util.copy(ThisMOD.recipe)
    ThisMOD.recipe_name                  = ThisMOD.recipe.name
    ThisMOD.recipe.name                  = ThisMOD.Prefix .. ThisMOD.recipe.name .. "-"
    ThisMOD.recipe.localised_description = { "" }
    ThisMOD.recipe.results               = { {} }
    ThisMOD.recipe.results[1].type       = "item"
    ThisMOD.recipe.results[1].name       = ThisMOD.item.name
    ThisMOD.recipe.results[1].amount     = 1
    ThisMOD.recipe.subgroup              = newSubgroup
    ThisMOD.recipe.icons                 = util.copy(ThisMOD.item.icons)
    table.insert(ThisMOD.recipe.localised_name, " - ")

    --- Calcular el numero de digitos a usar
    ThisMOD.digit = GPrefix.get_length(data.raw["damage-type"]) + 1
    ThisMOD.digit = GPrefix.digit_count(ThisMOD.digit > 0 and ThisMOD.digit or 1) + 1

    --- Indicador de mod
    ThisMOD.Indocator = {
        icon = data.raw["virtual-signal"]["signal-heart"].icon,
        shift = { 14, -14 },
        scale = 0.15
    }
end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------

--- Crear las recetas para las armaduras con una inmunidad
function ThisMOD.Create_OneResistance_Recipes()
    local Count = 0
    for damage, _ in pairs(data.raw["damage-type"]) do
        --- Nueva receta
        local Recipe           = util.copy(ThisMOD.recipe)
        Count                  = Count + 1

        --- Actualizar los valores
        Recipe.results[1].name = Recipe.name .. Count
        Recipe.name            = Recipe.name .. Count
        Recipe.order           = GPrefix.pad_left(ThisMOD.digit, Count) .. "0"
        table.insert(Recipe.localised_name, { "damage-type-name." .. damage })
        table.insert(Recipe.icons, ThisMOD.Indocator)

        --- Crear el prototipo
        GPrefix.addDataRaw({ Recipe })

        --- Agregar a la tecnología
        GPrefix.addRecipeToTechnology(nil, ThisMOD.recipe_name, Recipe)
    end
end

--- Crear la receta para la armadura con todas las inmunidades
function ThisMOD.Create_AllResistance_Recipe()
    --- Nueva receta
    local Recipe           = util.copy(ThisMOD.recipe)
    local Count            = GPrefix.get_length(data.raw["damage-type"]) + 1

    --- Actualizar los valores
    Recipe.results[1].name = Recipe.name .. Count
    Recipe.name            = Recipe.name .. Count
    Recipe.order           = GPrefix.pad_left(ThisMOD.digit, Count) .. "0"
    table.insert(Recipe.localised_name, { "armor-description." .. ThisMOD.Prefix .. "all" })
    table.insert(Recipe.icons, ThisMOD.Indocator)

    --- Agregar los ingredientes
    Recipe.ingredients = {}
    for i = 1, Count - 1, 1 do
        table.insert(Recipe.ingredients, {
            type = "item",
            name = ThisMOD.recipe.name .. i,
            amount = 1
        })
    end

    --- Crear el prototipo
    GPrefix.addDataRaw({ Recipe })

    --- Agregar a la tecnología
    GPrefix.addRecipeToTechnology(nil, ThisMOD.recipe_name, Recipe)
end

--- Crear las armaduras con una inmunidad
function ThisMOD.Create_OneResistance_Armors()
    local Count = 0
    for damage, _ in pairs(data.raw["damage-type"]) do
        --- Nueva armadura
        local Armor = util.copy(ThisMOD.item)
        Count       = Count + 1

        --- Actualizar los valores
        Armor.name  = Armor.name .. Count
        Armor.order = GPrefix.pad_left(ThisMOD.digit, Count) .. "0"
        table.insert(Armor.localised_name, { "damage-type-name." .. damage })

        --- Agregar la inmunidad
        table.insert(Armor.resistances, { type = damage, decrease = 0, percent = 100 })

        --- Agregar el indicador
        table.insert(Armor.icons, ThisMOD.Indocator)

        --- Crear el prototipo
        GPrefix.addDataRaw({ Armor })
    end
end

--- Crear la armadura con todas las inmunidades
function ThisMOD.Create_AllResistance_Armor()
    --- Nueva armadura
    local Armor = util.copy(ThisMOD.item)
    local Count = GPrefix.get_length(data.raw["damage-type"]) + 1

    --- Actualizar los valores
    Armor.name  = Armor.name .. Count
    Armor.order = GPrefix.pad_left(ThisMOD.digit, Count) .. "0"
    table.insert(Armor.localised_name, { "armor-description." .. ThisMOD.Prefix .. "all" })

    --- Agregar la inmunidad
    for damage, _ in pairs(data.raw["damage-type"]) do
        table.insert(Armor.resistances, { type = damage, decrease = 0, percent = 100 })
    end

    --- Agregar el indicador
    table.insert(Armor.icons, ThisMOD.Indocator)

    --- Crear el prototipo
    GPrefix.addDataRaw({ Armor })
end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
ThisMOD.Start()

---------------------------------------------------------------------------------------------------
