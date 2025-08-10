---------------------------------------------------------------------------------------------------
---> settings-final-fixes.lua <---
---------------------------------------------------------------------------------------------------

--- Cargar las funciones
require("__zzzYAIM0425-0000-lib__.settings-final-fixes")

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Configuración inicial
local settings = {
    type = "string-setting",
    name = GPrefix.name .. "-0200-armor-base",
    localised_name = { "gui.armor" },
    order = "1",
    setting_type = "startup",
    default_value = "light-armor",
    allowed_values = {
        "light-armor",
        "heavy-armor",
        "modular-armor",
        "power-armor",
        "power-armor-mk2"
    }
}

---------------------------------------------------------------------------------------------------

--- Factorio+
if mods["factorioplus"] then
    table.insert(settings.allowed_values, "backpack")
    table.insert(settings.allowed_values, "backpack-2")
    table.insert(settings.allowed_values, "explosive-armor")
    table.insert(settings.allowed_values, "acid-armor")
end

--- Krastorio 2
if mods["Krastorio2"] then
    table.insert(settings.allowed_values, "kr-power-armor-mk3")
    table.insert(settings.allowed_values, "kr-power-armor-mk4")
end

--- Youki Industries
if mods["Yuoki"] then
    table.insert(settings.allowed_values, "yi_armor_gray")
    table.insert(settings.allowed_values, "yi_armor_red")
    table.insert(settings.allowed_values, "yi_armor_gold")
    table.insert(settings.allowed_values, "yi_walker_a")
    table.insert(settings.allowed_values, "yi_walker_c")
end

--- Space Age
if mods["space-age"] then
    table.insert(settings.allowed_values, "mech-armor")
end

---------------------------------------------------------------------------------------------------





---------------------------------------------------------------------------------------------------

--- Cargar la configuración
data:extend({ settings })

---------------------------------------------------------------------------------------------------
