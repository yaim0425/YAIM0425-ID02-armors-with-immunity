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

    --- Obtener información desde el nombre de MOD
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
    local Setting = GPrefix.setting[This_MOD.id]["armor-base"]
    local Item_base = GPrefix.items[Setting] or GPrefix.items[Default]

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

    This_MOD.item = GPrefix.items[Item_base.name]
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

    This_MOD.recipe = GPrefix.recipes[Item_base.name][1]
    This_MOD.recipe = util.copy(This_MOD.recipe)
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

    local Indicator = data.raw["virtual-signal"]["signal-heart"].icons[1].icon

    This_MOD.icon = {}
    This_MOD.icon.tech = { icon = Indicator, scale = 0.50, shift = { 50, 50 } }
    This_MOD.icon.tech_bg = { icon = GPrefix.color.black, scale = 0.50, shift = { 50, 50 } }
    This_MOD.icon.other = { icon = Indicator, scale = 0.15, shift = { 12, -12 } }

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---



    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    ---> Tecnología a duplicar
    --- --- --- --- --- --- --- --- --- --- --- --- --- ---

    This_MOD.tech = GPrefix.get_technology({ name = GPrefix.recipes[Item_base.name][1].name })
    This_MOD.tech = util.copy(This_MOD.tech)
    if This_MOD.tech then This_MOD.tech.effects = {} end

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





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
        Recipe.results[1].name = Recipe.name .. damage
        Recipe.name = Recipe.name .. damage
        Recipe.order = GPrefix.pad_left_zeros(This_MOD.digit, Count) .. "0"
        table.insert(Recipe.localised_name, { "damage-type-name." .. damage })
        table.insert(Recipe.icons, This_MOD.icon.other)

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
    Recipe.results[1].name = Recipe.name .. "all"
    Recipe.name = Recipe.name .. "all"
    Recipe.order = GPrefix.pad_left_zeros(This_MOD.digit, Count) .. "0"
    table.insert(Recipe.localised_name, { "gui.all" })
    table.insert(Recipe.icons, This_MOD.icon.other)

    --- Agregar los ingredientes
    Recipe.ingredients = {}
    for damage, _ in pairs(This_MOD.damages) do
        table.insert(Recipe.ingredients, {
            type = "item",
            name = This_MOD.recipe.name .. damage,
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
        Armor.name = Armor.name .. damage
        Armor.order = GPrefix.pad_left_zeros(This_MOD.digit, Count) .. "0"
        table.insert(Armor.localised_name, { "damage-type-name." .. damage })
        Armor.factoriopedia_simulation = {
            init =
                'game.simulation.camera_zoom = 4' ..
                'game.simulation.camera_position = {0.5, -0.25}' ..
                'local character = game.surfaces[1].create_entity{name = "character", position = {0.5, 0.5}, force = "player", direction = defines.direction.south}' ..
                'character.insert{name = "' .. Armor.name .. '"}'
        }

        --- Agregar la inmunidad
        table.insert(Armor.resistances, {
            type = damage,
            decrease = 0,
            percent = 100
        })

        --- Agregar el indicador
        table.insert(Armor.icons, This_MOD.icon.other)

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
    Armor.name = Armor.name .. "all"
    Armor.order = GPrefix.pad_left_zeros(This_MOD.digit, Count) .. "0"
    table.insert(Armor.localised_name, { "gui-blueprint-library.shelf-choice-all" })
    Armor.factoriopedia_simulation = {
        init =
            'game.simulation.camera_zoom = 4' ..
            'game.simulation.camera_position = {0.5, -0.25}' ..
            'local character = game.surfaces[1].create_entity{name = "character", position = {0.5, 0.5}, force = "player", direction = defines.direction.south}' ..
            'character.insert{name = "' .. Armor.name .. '"}'
    }

    --- Agregar la inmunidad
    for damage, _ in pairs(This_MOD.damages) do
        table.insert(Armor.resistances, {
            type = damage,
            decrease = 0,
            percent = 100
        })
    end

    --- Agregar el indicador
    table.insert(Armor.icons, This_MOD.icon.other)

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
    for damage, _ in pairs(This_MOD.damages) do
        --- Duplicar la tecnología
        local Tech = util.copy(This_MOD.tech)
        table.insert(Tech.prerequisites, Tech.name)
        table.insert(Tech.effects, {
            type = "unlock-recipe",
            recipe = This_MOD.recipe.name .. damage
        })
        Tech.name =
            GPrefix.name .. "-" ..
            damage .. "-" ..
            Tech.name

        --- Daño a absorber
        table.insert(Tech.localised_name, " - ")
        table.insert(Tech.localised_name, { "damage-type-name." .. damage })

        --- Indicador del mod
        table.insert(Tech.icons, This_MOD.icon.tech_bg)
        table.insert(Tech.icons, This_MOD.icon.tech)

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

    --- Indicador del mod
    table.insert(Tech.icons, This_MOD.icon.tech_bg)
    table.insert(Tech.icons, This_MOD.icon.tech)

    --- Agregar los prerequisitos
    for damage, _ in pairs(This_MOD.damages) do
        table.insert(
            Tech.prerequisites,
            GPrefix.name .. "-" ..
            damage .. "-" ..
            This_MOD.tech.name
        )
    end

    --- Nombre de la tecnología
    Tech.name = GPrefix.name .. "-all-" .. Tech.name

    --- Daño a absorber
    table.insert(Tech.localised_name, " - ")
    table.insert(Tech.localised_name, { "gui.all" })

    --- Agregar la receta
    table.insert(Tech.effects, {
        type = "unlock-recipe",
        recipe = This_MOD.recipe.name .. "all"
    })

    --- Crear la tecnología
    GPrefix.extend(Tech)

    --- --- --- --- --- --- --- --- --- --- --- --- --- ---
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Iniciar el modulo
This_MOD.start()

---------------------------------------------------------------------------------------------------
