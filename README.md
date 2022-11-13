# Thestral HUD
## _Free HUD created for Helix and configurable_

Colorful HUD created by Jars and fre to use or edit. If you improved you can pull request on
this repository.

## Features

Options allowed for normal users on TAB helix menu:

- Change color for every bar.
- Can automatically hide health bar when is almost full.
- Can automatically hide the rest of the bars when is almost full.
- Allows hide all the HUD for cinematics
- Allow have stamina on the left right corner

## Instalation
- Put file from plugins > thestral_hud.lua into your helixSchema > plugins
- Create new addon with the materials

## Problem
Maybe you have problems if you dont have Hunger and Thrist system.
You can add this to allow you use GetHunger() in your character.
```lua
ix.char.RegisterVar("hunger", {
	field = "hunger",
	fieldType = ix.type.number,
	default = 100,
	isLocal = true,
	bNoDisplay = true
})

ix.char.RegisterVar("thirst", {
	field = "thirst",
	fieldType = ix.type.number,
	default = 100,
	isLocal = true,
	bNoDisplay = true
})
```

![Bars](https://i.imgur.com/ZKVEoXY.png)
![Options on TAB](https://i.imgur.com/kys66jI.png)
