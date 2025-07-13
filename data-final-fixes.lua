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
    This_MOD.create_recipes_one_resistance()
    This_MOD.create_recipes_all_resistance()

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Crear los objetos
    This_MOD.create_armors_one_resistance()
    This_MOD.create_armors_all_resistance()

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Tecnología a duplicar
    This_MOD.get_technology()

    --- Crear las tecnologias
    This_MOD.create_tech_one_resistance()
    This_MOD.create_tech_all_resistance()

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Valores de la referencia
function This_MOD.setting_mod()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Armadura a duplicar
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Default = "light-armor"
    local Setting = GPrefix.Setting[This_MOD.id]["armor-base"]
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
    ---> Renombrar las variables
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.damages = data.raw["damage-type"]

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

    This_MOD.Indicator = {
        icon = data.raw["virtual-signal"]["signal-heart"].icons[1].icon,
        shift = { 14, -14 },
        scale = 0.15
    }

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Tecnología a duplicar
function This_MOD.get_technology()
    This_MOD.tech = GPrefix.get_technology({ name = This_MOD.recipe_name })
    if not This_MOD.tech then return end
    This_MOD.tech = util.copy(This_MOD.tech)
    This_MOD.tech.prerequisites = {}
    This_MOD.tech.effects = {}
end

---------------------------------------------------------------------------------------------------

--- Crear las recetas para las armaduras con una inmunidad
function This_MOD.create_recipes_one_resistance()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Count = 0
    for damage, _ in pairs(This_MOD.damages) do
        --- Nueva receta
        Count = Count + 1
        local Recipe = util.copy(This_MOD.recipe)

        --- Actualizar los valores
        Recipe.results[1].name = Recipe.name .. Count
        Recipe.name = Recipe.name .. Count
        Recipe.order = GPrefix.pad_left_zeros(This_MOD.digit, Count) .. "0"
        table.insert(Recipe.localised_name, { "damage-type-name." .. damage })
        table.insert(Recipe.icons, This_MOD.Indicator)

        --- Agregar la receta
        GPrefix.extend(Recipe)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Crear la receta para la armadura con todas las inmunidades
function This_MOD.create_recipes_all_resistance()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nueva receta
    local Recipe = util.copy(This_MOD.recipe)
    local Count = GPrefix.get_length(This_MOD.damages) + 1

    --- Actualizar los valores
    Recipe.results[1].name = Recipe.name .. Count
    Recipe.name = Recipe.name .. Count
    Recipe.order = GPrefix.pad_left_zeros(This_MOD.digit, Count) .. "0"
    table.insert(Recipe.localised_name, { "armor-description." .. This_MOD.prefix .. "all" })
    table.insert(Recipe.icons, This_MOD.Indicator)

    --- Agregar los ingredientes
    Recipe.ingredients = {}
    for i = 1, Count - 1, 1 do
        table.insert(Recipe.ingredients, {
            type = "item",
            name = This_MOD.recipe.name .. i,
            amount = 1
        })
    end

    --- Agregar la receta
    GPrefix.extend(Recipe)

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

--- Crear las armaduras con una inmunidad
function This_MOD.create_armors_one_resistance()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    local Count = 0
    for damage, _ in pairs(This_MOD.damages) do
        --- Nueva armadura
        Count = Count + 1
        local Armor = util.copy(This_MOD.item)

        --- Actualizar los valores
        Armor.name = Armor.name .. Count
        Armor.order = GPrefix.pad_left_zeros(This_MOD.digit, Count) .. "0"
        table.insert(Armor.localised_name, { "damage-type-name." .. damage })

        --- Agregar la inmunidad
        table.insert(Armor.resistances, {
            type = damage,
            decrease = 0,
            percent = 100
        })

        --- Agregar el indicador
        table.insert(Armor.icons, This_MOD.Indicator)

        --- Crear el prototipo
        GPrefix.extend(Armor)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Crear la armadura con todas las inmunidades
function This_MOD.create_armors_all_resistance()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Nueva armadura
    local Armor = util.copy(This_MOD.item)
    local Count = GPrefix.get_length(This_MOD.damages) + 1

    --- Actualizar los valores
    Armor.name = Armor.name .. Count
    Armor.order = GPrefix.pad_left_zeros(This_MOD.digit, Count) .. "0"
    table.insert(Armor.localised_name, { "armor-description." .. This_MOD.prefix .. "all" })

    --- Agregar la inmunidad
    for damage, _ in pairs(This_MOD.damages) do
        table.insert(Armor.resistances, {
            type = damage,
            decrease = 0,
            percent = 100
        })
    end

    --- Agregar el indicador
    table.insert(Armor.icons, This_MOD.Indicator)

    --- Crear el prototipo
    GPrefix.extend(Armor)

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------

--- Crear la tecnología para una inmunidad
function This_MOD.create_tech_one_resistance()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Validación
    if not This_MOD.tech then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Recorrer los daños
    local Count = 1
    for damage, _ in pairs(This_MOD.damages) do
        --- Duplicar la tecnología
        local Tech = util.copy(This_MOD.tech)
        table.insert(Tech.prerequisites, Tech.name)
        table.insert(Tech.effects, {
            type = "unlock-recipe",
            recipe = This_MOD.recipe.name .. Count
        })
        Tech.name = GPrefix.name .. "-" .. Count
        Tech.name = Tech.name .. "-" .. Tech.name
        Count = Count + 1

        --- Daño a absorber
        table.insert(Tech.localised_name, " - ")
        table.insert(Tech.localised_name, { "damage-type-name." .. damage })

        --- Crear la tecnología
        GPrefix.extend(Tech)
    end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

--- Crear la tecnología para todas las inmunidades
function This_MOD.create_tech_all_resistance()
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Validación
    if not This_MOD.tech then return end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    --- Duplicar la tecnología
    local Tech = util.copy(This_MOD.tech)

    --- Agregar los prerequisitos
    local Count = 1
    for _, _ in pairs(This_MOD.damages) do
        local Name = Tech.name
        Name = GPrefix.name .. "-" .. Count
        Name = Name .. "-" .. Name
        Count = Count + 1

        table.insert(Tech.prerequisites, Name)
    end

    --- Agregar la receta
    table.insert(Tech.effects, {
        type = "unlock-recipe",
        recipe = This_MOD.recipe.name .. Count
    })

    --- Crear la tecnología
    GPrefix.extend(Tech)

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
This_MOD.start()
-- ERROR()

---------------------------------------------------------------------------------------------------
