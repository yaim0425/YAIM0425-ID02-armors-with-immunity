---------------------------------------------------------------------------------------------------
---> settings-final-fixes.lua <---
---------------------------------------------------------------------------------------------------

--- Contenedor de funciones y datos usados
--- unicamente en este archivo
local This_MOD = {}

---------------------------------------------------------------------------------------------------

--- Cargar las funciones
require("__zzzYAIM0425-0000-lib__.settings-final-fixes")

---------------------------------------------------------------------------------------------------

--- Obtener información desde el nombre de MOD
GPrefix.split_name_folder(This_MOD)

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Opciones
This_MOD.setting = {}

--- Opcion: armor_base
table.insert(This_MOD.setting, {
    type = "string",
    name = "armor_base",
    localised_name = { "gui.armor" },
    default_value = "light-armor",
    allowed_values = {
        "light-armor",
        "heavy-armor",
        "modular-armor",
        "power-armor",
        "power-armor-mk2"
    }
})

--- Renombrar
local Armor_base = This_MOD.setting[#This_MOD.setting]

---------------------------------------------------------------------------------------------------

--- Factorio+
if mods["factorioplus"] then
    table.insert(Armor_base.allowed_values, "backpack")
    table.insert(Armor_base.allowed_values, "backpack-2")
    table.insert(Armor_base.allowed_values, "explosive-armor")
    table.insert(Armor_base.allowed_values, "acid-armor")
end

--- Krastorio 2
if mods["Krastorio2"] then
    table.insert(Armor_base.allowed_values, "kr-power-armor-mk3")
    table.insert(Armor_base.allowed_values, "kr-power-armor-mk4")
end

--- Youki Industries
if mods["Yuoki"] then
    table.insert(Armor_base.allowed_values, "yi_armor_gray")
    table.insert(Armor_base.allowed_values, "yi_armor_red")
    table.insert(Armor_base.allowed_values, "yi_armor_gold")
    table.insert(Armor_base.allowed_values, "yi_walker_a")
    table.insert(Armor_base.allowed_values, "yi_walker_c")
end

--- Space Age
if mods["space-age"] then
    table.insert(Armor_base.allowed_values, "mech-armor")
end

---------------------------------------------------------------------------------------------------

--- Información adicional
for order, setting in pairs(This_MOD.setting) do
	setting.type = setting.type .. "-setting"
	setting.name = This_MOD.prefix .. setting.name
	setting.order = tostring(order)
	setting.setting_type = "startup"
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Cargar la configuración
data:extend(This_MOD.setting)

---------------------------------------------------------------------------------------------------
