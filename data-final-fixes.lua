---------------------------------------------------------------------------------------------------
---> data-final-fixes.lua <---
---------------------------------------------------------------------------------------------------

--- Contenedor de funciones y datos usados
--- unicamente en este archivo
local This_MOD = {}

---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
function This_MOD.start()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Obtener información del nombre de MOD
    GPrefix.split_name_folder(This_MOD)

    --- Valores de la referencia
    This_MOD.setting_mod()

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    -- --- Crear las recetas
    -- This_MOD.create_recipes_one_resistance()
    -- This_MOD.create_recipes_all_resistance()

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    -- --- Crear los objetos
    -- This_MOD.create_armors_one_resistance()
    -- This_MOD.create_armors_all_resistance()

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Valores de la referencia
function This_MOD.setting_mod()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Renombrar las variables
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.damages = data.raw["damage-type"]

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Armadura a duplicar
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Default = "light-armor"
    local Setting = GPrefix.Setting[This_MOD.prefix]["armor-base"]
    local Item_base = GPrefix.Items[Setting] or GPrefix.Items[Default]

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Subgroup para este MOD
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Old_subgroup = Item_base.subgroup
    local New_subgroup = This_MOD.prefix .. This_MOD.name
    GPrefix.duplicate_subgroup(Old_subgroup, New_subgroup)

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Objeto base
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.item = GPrefix.Items[Item_base.name]
    This_MOD.item = util.copy(This_MOD.item)
    This_MOD.item.name = This_MOD.prefix .. This_MOD.item.name .. "-"
    This_MOD.item.localised_description = { "" }
    This_MOD.item.resistances = {}
    This_MOD.item.subgroup = New_subgroup
    table.insert(This_MOD.item.localised_name, " - ")

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Receta base
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.recipe = GPrefix.Recipes[Item_base.name][1]
    This_MOD.recipe = util.copy(This_MOD.recipe)
    This_MOD.recipe_name = This_MOD.recipe.name
    This_MOD.recipe.name = This_MOD.prefix .. This_MOD.recipe.name .. "-"
    This_MOD.recipe.localised_description = { "" }
    This_MOD.recipe.results = { {} }
    This_MOD.recipe.results[1].type = "item"
    This_MOD.recipe.results[1].name = This_MOD.item.name
    This_MOD.recipe.results[1].amount = 1
    This_MOD.recipe.subgroup = New_subgroup
    This_MOD.recipe.icons = util.copy(This_MOD.item.icons)
    table.insert(This_MOD.recipe.localised_name, " - ")

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Calcular el numero de digitos a usar
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.digit = GPrefix.get_length(This_MOD.damages) + 1
    This_MOD.digit = GPrefix.digit_count(This_MOD.digit > 0 and This_MOD.digit or 1) + 1

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---





    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Indicador de mod
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.Indocator = {
        icon = data.raw["virtual-signal"]["signal-heart"].icon,
        shift = { 14, -14 },
        scale = 0.15
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Crear las recetas para las armaduras con una inmunidad
function This_MOD.create_recipes_one_resistance()
    local Count = 0
    for damage, _ in pairs(This_MOD.damages) do
        --- Nueva receta
        Count = Count + 1
        local Recipe = util.copy(This_MOD.recipe)

        --- Actualizar los valores
        Recipe.results[1].name = Recipe.name .. Count
        Recipe.name = Recipe.name .. Count
        Recipe.order = GPrefix.pad_left(This_MOD.digit, Count) .. "0"
        table.insert(Recipe.localised_name, { "damage-type-name." .. damage })
        table.insert(Recipe.icons, This_MOD.Indocator)

        -- --- Crear el prototipo
        -- GPrefix.addDataRaw({ Recipe })

        -- --- Agregar a la tecnología
        -- GPrefix.addRecipeToTechnology(nil, This_MOD.recipe_name, Recipe)
    end
end

--- Crear la receta para la armadura con todas las inmunidades
function This_MOD.create_recipes_all_resistance()
    --- Nueva receta
    local Recipe           = util.copy(This_MOD.recipe)
    local Count            = GPrefix.get_length(This_MOD.damages) + 1

    --- Actualizar los valores
    Recipe.results[1].name = Recipe.name .. Count
    Recipe.name            = Recipe.name .. Count
    Recipe.order           = GPrefix.pad_left(This_MOD.digit, Count) .. "0"
    table.insert(Recipe.localised_name, { "armor-description." .. This_MOD.prefix .. "all" })
    table.insert(Recipe.icons, This_MOD.Indocator)

    --- Agregar los ingredientes
    Recipe.ingredients = {}
    for i = 1, Count - 1, 1 do
        table.insert(Recipe.ingredients, {
            type = "item",
            name = This_MOD.recipe.name .. i,
            amount = 1
        })
    end

    --- Crear el prototipo
    GPrefix.addDataRaw({ Recipe })

    --- Agregar a la tecnología
    GPrefix.addRecipeToTechnology(nil, This_MOD.recipe_name, Recipe)
end

---------------------------------------------------------------------------------------------------

--- Crear las armaduras con una inmunidad
function This_MOD.create_armors_one_resistance()
    local Count = 0
    for damage, _ in pairs(This_MOD.damages) do
        --- Nueva armadura
        local Armor = util.copy(This_MOD.item)
        Count       = Count + 1

        --- Actualizar los valores
        Armor.name  = Armor.name .. Count
        Armor.order = GPrefix.pad_left(This_MOD.digit, Count) .. "0"
        table.insert(Armor.localised_name, { "damage-type-name." .. damage })

        --- Agregar la inmunidad
        table.insert(Armor.resistances, { type = damage, decrease = 0, percent = 100 })

        --- Agregar el indicador
        table.insert(Armor.icons, This_MOD.Indocator)

        --- Crear el prototipo
        GPrefix.addDataRaw({ Armor })
    end
end

--- Crear la armadura con todas las inmunidades
function This_MOD.create_armors_all_resistance()
    --- Nueva armadura
    local Armor = util.copy(This_MOD.item)
    local Count = GPrefix.get_length(This_MOD.damages) + 1

    --- Actualizar los valores
    Armor.name  = Armor.name .. Count
    Armor.order = GPrefix.pad_left(This_MOD.digit, Count) .. "0"
    table.insert(Armor.localised_name, { "armor-description." .. This_MOD.prefix .. "all" })

    --- Agregar la inmunidad
    for damage, _ in pairs(This_MOD.damages) do
        table.insert(Armor.resistances, { type = damage, decrease = 0, percent = 100 })
    end

    --- Agregar el indicador
    table.insert(Armor.icons, This_MOD.Indocator)

    --- Crear el prototipo
    GPrefix.addDataRaw({ Armor })
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
This_MOD.start()

---------------------------------------------------------------------------------------------------
