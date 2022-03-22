local PLUGIN = PLUGIN
PLUGIN.name = "Thestral HUD"
PLUGIN.author = "Jars"
PLUGIN.description = "HUD de thestral."

ix.option.Add("ocultarHUD", ix.type.bool, false, {
	category = "Thestral HUD"
})

ix.option.Add("ocultarAutomaticamenteHUD", ix.type.bool, true, {
	category = "Thestral HUD"
})

ix.option.Add("ocultarAutomaticamenteVida", ix.type.bool, false, {
	category = "Thestral HUD"
})

ix.option.Add("estaminaDerecha", ix.type.bool, false, {
	category = "Thestral HUD"
})

ix.option.Add("colorVida", ix.type.color, Color(255,75,66), {
	category = "Thestral HUD"
})

ix.option.Add("colorEscudo", ix.type.color, Color(255,132,187), {
	category = "Thestral HUD"
})

ix.option.Add("colorHambre", ix.type.color, Color(250,168,35), {
	category = "Thestral HUD"
})

ix.option.Add("colorSed", ix.type.color, Color(70,153,255), {
	category = "Thestral HUD"
})

ix.option.Add("colorEstamina", ix.type.color, Color(67,223,67), {
	category = "Thestral HUD"
})


if CLIENT then
    local color_white = Color(255, 255, 255)

    local scrw, scrh = ScrW(), ScrH()
    local barW = scrw*.06
    local barH = scrh*.031
    local healthicon = Material("thestral/hud/healthicon.png")
    local shieldicon = Material("thestral/hud/shieldicon.png")
    local hungericon = Material("thestral/hud/hungericon.png")
    local thirsticon = Material("thestral/hud/watericon.png")
    local staminaicon = Material("thestral/hud/staminaicon.png")

    surface.CreateFont( "jars_hud_indicators", {
        font = "Roboto",
        size = 25,
        weight = 400,
        antialias = true,
    } )

    function PLUGIN.DrawTextRect(mat, x, y, w, h)
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( mat ) 
        surface.DrawTexturedRect( x, y, w, h ) 
    end

    hook.Add("HUDPaint", "hogwarts_hud", function()
        if not ix.option.Get("ocultarHUD", false) then
            local ply = LocalPlayer()
            local char = ply:GetCharacter()
            if !char then return end 
            if(!IsValid(ply)) then return end
            if(!ply:Alive()) then return end
            if(ply:GetNoDraw()) then return end
            
            local hp = ply:Health()
            local armor = ply:Armor()
            local hunger = math.ceil(char:GetHunger()) or 0
            local thirst = math.ceil(char:GetThirst()) or 0
            local stamina = ply:GetLocalVar("stm", 0)

            local hpbarchange = barW*  math.Clamp((hp / ply:GetMaxHealth()) , 0, 1 )
            local armorbarchange = barW*  math.Clamp((armor / 100) , 0, 1 )
            local hungerbarchange =  barH * (hunger / 100)
            local thirstbarchange = barH * (thirst / 100)
            local staminabarchange = scrw*.04*  math.Clamp((stamina / 100) , 0, 1 )
            local offsetHidden = 0.0
            
            // hp
            if not ix.option.Get("ocultarAutomaticamenteVida", false) then // Hide automatically the health bar when bar is almost full
                draw.RoundedBox(8, scrw*.006, scrh*.958, scrw*.062, scrh*.034, Color(0,0,0,200))
                draw.RoundedBox(8, scrw*.007, scrh*.96, hpbarchange, scrh*.031, ix.option.Get("colorVida", Color(255,75,66)))
                draw.SimpleText(hp, "jars_hud_indicators", scrw*.036,scrh*.975, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                PLUGIN.DrawTextRect(healthicon,scrw*.01,scrh*.964, scrw*.015, scrh*.025)
                offsetHidden = offsetHidden + 0.063
            else
                if hp < ply:GetMaxHealth() then
                    draw.RoundedBox(8, scrw*.006, scrh*.958, scrw*.062, scrh*.034, Color(0,0,0,200))
                    draw.RoundedBox(8, scrw*.007, scrh*.96, hpbarchange, scrh*.031, ix.option.Get("colorVida", Color(255,75,66)))
                    draw.SimpleText(hp, "jars_hud_indicators", scrw*.036,scrh*.975, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    PLUGIN.DrawTextRect(healthicon,scrw*.01,scrh*.964, scrw*.015, scrh*.025)
                    offsetHidden = offsetHidden + 0.063
                end
            end

            if ix.option.Get("ocultarAutomaticamenteHUD", true) then // Hide automatically the HUD when bars are almost full
                // armor 
                if armor > 0 then 
                    draw.RoundedBox(8, scrw*(.006 + offsetHidden), scrh*.958, scrw*.062, scrh*.034, Color(0,0,0,200))
                    draw.RoundedBox(8, scrw*(.006 + offsetHidden + 0.001), scrh*.96, armorbarchange, scrh*.031, ix.option.Get("colorEscudo", Color(255,132,187)))
                    draw.SimpleText(armor, "jars_hud_indicators", scrw*(.006 + offsetHidden + 0.035),scrh*.975, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    PLUGIN.DrawTextRect(shieldicon,scrw*(.006 + offsetHidden + 0.004),scrh*.963, scrw*.015, scrh*.025)
                    offsetHidden = offsetHidden + 0.063
                end

                // hunger
                if math.floor(hunger) < 90 then
                    draw.RoundedBox(8, scrw*(.007 + offsetHidden), scrh*.958, scrw*.022, scrh*.034, Color(0,0,0,200))
                    draw.RoundedBox(8, scrw*(.007 + offsetHidden + 0.001), scrh*.991 - hungerbarchange, scrw*.02, hungerbarchange, ix.option.Get("colorHambre", Color(250,168,35)))
                    PLUGIN.DrawTextRect(hungericon,scrw*(.007 + offsetHidden + 0.004),scrh*.965, scrw*.015, scrh*.024)
                    offsetHidden = offsetHidden + 0.023
                end

                // thirst
                if math.floor(thirst) < 90 then
                    draw.RoundedBox(8, scrw*(.007 + offsetHidden), scrh*.958, scrw*.022, scrh*.034, Color(0,0,0,200))
                    draw.RoundedBox(8, scrw*(.007 + offsetHidden + 0.001), scrh*.991 - thirstbarchange, scrw*.02, thirstbarchange, ix.option.Get("colorSed", Color(70,153,255)))
                    PLUGIN.DrawTextRect(thirsticon,scrw*(.007 + offsetHidden + 0.004),scrh*.965, scrw*.015, scrh*.024)
                    offsetHidden = offsetHidden + 0.023
                end

                //stamina 
                if math.floor(stamina) < 100 then
                    local estaminaOffset = 0
                    local estaminaText = 0
                    local estaminaIcon = 0
                    if ix.option.Get("estaminaDerecha", false) then // Check if user prefer the stamina bar on the right corner
                        estaminaOffset = scrw - scrw*.050
                        estaminaText = scrw - scrw*0.028
                        estaminaIcon = estaminaOffset
                    else
                        estaminaOffset = scrw*(.007 + offsetHidden)
                        estaminaText = scrw*(.007 + offsetHidden + 0.028)
                        estaminaIcon = scrw*(.007 + offsetHidden + 0.003)
                    end
            
                    //stamina 
                    draw.RoundedBox(8, estaminaOffset, scrh*.958, scrw*.042, scrh*.034, Color(0,0,0,200))
                    draw.RoundedBox(8, estaminaOffset + .001, scrh*.96, staminabarchange, scrh*.031, ix.option.Get("colorEstamina", Color(67,223,67)))
                    draw.SimpleText(math.floor(stamina), "jars_hud_indicators", estaminaText,scrh*.975, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    PLUGIN.DrawTextRect(staminaicon,estaminaIcon,scrh*.966, scrw*.013, scrh*.020)
                end
            else
                // armor 
                draw.RoundedBox(8, scrw*(.006 + offsetHidden), scrh*.958, scrw*.062, scrh*.034, Color(0,0,0,200))
                draw.RoundedBox(8, scrw*(.006 + offsetHidden + 0.001), scrh*.96, armorbarchange, scrh*.031, ix.option.Get("colorEscudo", Color(255,132,187)))
                draw.SimpleText(armor, "jars_hud_indicators", scrw*(.006 + offsetHidden + 0.035),scrh*.975, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                PLUGIN.DrawTextRect(shieldicon,scrw*(.006 + offsetHidden + 0.004),scrh*.963, scrw*.015, scrh*.025)
                offsetHidden = offsetHidden + 0.063

                // hunger
                draw.RoundedBox(8, scrw*(.007 + offsetHidden), scrh*.958, scrw*.022, scrh*.034, Color(0,0,0,200))
                draw.RoundedBox(8, scrw*(.007 + offsetHidden + 0.001), scrh*.991 - hungerbarchange, scrw*.02, hungerbarchange, ix.option.Get("colorHambre", Color(250,168,35)))
                PLUGIN.DrawTextRect(hungericon,scrw*(.007 + offsetHidden + 0.004),scrh*.965, scrw*.015, scrh*.024)
                offsetHidden = offsetHidden + 0.023

                // thirst
                draw.RoundedBox(8, scrw*(.007 + offsetHidden), scrh*.958, scrw*.022, scrh*.034, Color(0,0,0,200))
                draw.RoundedBox(8, scrw*(.007 + offsetHidden + 0.001), scrh*.991 - thirstbarchange, scrw*.02, thirstbarchange, ix.option.Get("colorSed", Color(70,153,255)))
                PLUGIN.DrawTextRect(thirsticon,scrw*(.007 + offsetHidden + 0.004),scrh*.965, scrw*.015, scrh*.024)
                offsetHidden = offsetHidden + 0.023

                // stamina
                local estaminaOffset = 0
                local estaminaText = 0
                local estaminaIcon = 0
                if ix.option.Get("estaminaDerecha", false) then // Check if user prefer the stamina bar on the right corner
                    estaminaOffset = scrw - scrw*.050
                    estaminaText = scrw - scrw*0.028
                    estaminaIcon = estaminaOffset
                else
                    estaminaOffset = scrw*(.007 + offsetHidden)
                    estaminaText = scrw*(.007 + offsetHidden + 0.028)
                    estaminaIcon = scrw*(.007 + offsetHidden + 0.003)
                end
        
                //stamina 
                draw.RoundedBox(8, estaminaOffset, scrh*.958, scrw*.042, scrh*.034, Color(0,0,0,200))
                draw.RoundedBox(8, estaminaOffset + .001, scrh*.96, staminabarchange, scrh*.031, ix.option.Get("colorEstamina", Color(67,223,67)))
                draw.SimpleText(math.floor(stamina), "jars_hud_indicators", estaminaText,scrh*.975, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                PLUGIN.DrawTextRect(staminaicon,estaminaIcon,scrh*.966, scrw*.013, scrh*.020)
            end
        end
    end)
end

function PLUGIN:ShouldHideBars()
    return true
end