extends Node


const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
const UPGRADES = {
	"icespear1": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "A semi-automatic pistol. Fires piercing bullets. Point and shoot!",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"icespear2": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "Fire an additional bullet",
		"level": "Level: 2",
		"prerequisite": ["icespear1"],
		"type": "weapon"
	},
	"icespear3": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "Bullets now pierce another enemy, and do more damage",
		"level": "Level: 3",
		"prerequisite": ["icespear2"],
		"type": "weapon"
	},
	"icespear4": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "Fire two more bullets",
		"level": "Level: 4",
		"prerequisite": ["icespear3"],
		"type": "weapon"
	},
		"icespear5": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "Placeholder text",
		"level": "Level: 5",
		"prerequisite": ["icespear4"],
		"type": "weapon"
	},
	"icespear6": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "Placeholder text",
		"level": "Level: 6",
		"prerequisite": ["icespear5"],
		"type": "weapon"
	},
	"icespear7": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "Placeholder text",
		"level": "Level: 7",
		"prerequisite": ["icespear6"],
		"type": "weapon"
	},
	"icespear8": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "Placeholder text",
		"level": "Level: 8",
		"prerequisite": ["icespear7"],
		"type": "weapon"
	},
	"icespear9": {
		"icon": WEAPON_PATH + "gun.png",
		"displayname": "Pistol",
		"details": "Placeholder text",
		"level": "Ultimate",
		"prerequisite": ["icespear8"],
		"type": "weapon"
	},
	
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"armor5": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 5",
		"prerequisite": ["armor4"],
		"type": "upgrade"
	},
	"armor6": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 6",
		"prerequisite": ["armor5"],
		"type": "upgrade"
	},
	"armor7": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 7",
		"prerequisite": ["armor6"],
		"type": "upgrade"
	},
	"armor8": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 8",
		"prerequisite": ["armor7"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"speed5": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 5",
		"prerequisite": ["speed4"],
		"type": "upgrade"
	},
	"speed6": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 6",
		"prerequisite": ["speed5"],
		"type": "upgrade"
	},
	"speed7": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 7",
		"prerequisite": ["speed6"],
		"type": "upgrade"
	},
	"speed8": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 8",
		"prerequisite": ["speed7"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"ring3": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 3",
		"prerequisite": ["ring2"],
		"type": "upgrade"
	},
	"ring4": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 4",
		"prerequisite": ["ring3"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	},
	"orb1": {
		"icon": ICON_PATH + "orb_ph.png",
		"displayname": "Orb",
		"details": "Increase gem pickup range by 50%",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
		"orb2": {
		"icon": ICON_PATH + "orb_ph.png",
		"displayname": "Orb",
		"details": "Increase gem pickup range by 100%",
		"level": "Level: 2",
		"prerequisite": ["orb1"],
		"type": "upgrade"
	},
		"orb3": {
		"icon": ICON_PATH + "orb_ph.png",
		"displayname": "Orb",
		"details": "Increase gem pickup range by 200%",
		"level": "Level: 3",
		"prerequisite": ["orb2"],
		"type": "upgrade"
	},
		"orb4": {
		"icon": ICON_PATH + "orb_ph.png",
		"displayname": "Orb",
		"details": "Increase gem pickup range by 400%",
		"level": "Level: 4",
		"prerequisite": ["orb3"],
		"type": "upgrade"
	},
	"sword1": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Sword slashes in front of you",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"sword2": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Sword slashes in front of you",
		"level": "Level: 2",
		"prerequisite": ["sword1"],
		"type": "weapon"
	},
	"sword3": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Sword slashes in front of you",
		"level": "Level: 3",
		"prerequisite": ["sword2"],
		"type": "weapon"
	},
	"sword4": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Sword slashes in front of you",
		"level": "Level: 4",
		"prerequisite": ["sword3"],
		"type": "weapon"
	},
	"sword5": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Sword slashes in front of you",
		"level": "Level: 5",
		"prerequisite": ["sword4"],
		"type": "weapon"
	},
	"sword6": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Sword slashes in front of you",
		"level": "Level: 6",
		"prerequisite": ["sword5"],
		"type": "weapon"
	},
	"sword7": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Sword slashes in front of you",
		"level": "Level: 7",
		"prerequisite": ["sword6"],
		"type": "weapon"
	},
	"sword8": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Sword slashes in front of you",
		"level": "Level: 8",
		"prerequisite": ["sword7"],
		"type": "weapon"
	},
	"sword9": {
		"icon": WEAPON_PATH + "sword_ph.png",
		"displayname": "Sword",
		"details": "Ultimate Sword. Slash now travels.",
		"level": "Ultimate",
		"prerequisite": ["sword8"],
		"type": "weapon"
	},
	"flail1": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Flail swings around you for a short time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"flail2": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Flail swings around you for a short time",
		"level": "Level: 2",
		"prerequisite": ["flail1"],
		"type": "weapon"
	},
	"flail3": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Flail swings around you for a short time",
		"level": "Level: 3",
		"prerequisite": ["flail2"],
		"type": "weapon"
	},
	"flail4": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Flail swings around you for a short time",
		"level": "Level: 4",
		"prerequisite": ["flail3"],
		"type": "weapon"
	},
	"flail5": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Flail swings around you for a short time",
		"level": "Level: 5",
		"prerequisite": ["flail4"],
		"type": "weapon"
	},
	"flail6": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Flail swings around you for a short time",
		"level": "Level: 6",
		"prerequisite": ["flail5"],
		"type": "weapon"
	},
	"flail7": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Flail swings around you for a short time",
		"level": "Level: 7",
		"prerequisite": ["flail6"],
		"type": "weapon"
	},
	"flail8": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Flail swings around you for a short time",
		"level": "Level: 8",
		"prerequisite": ["flail7"],
		"type": "weapon"
	},
	"flail9": {
		"icon": WEAPON_PATH + "flail.png",
		"displayname": "Flail",
		"details": "Ultimate Flail. Now swings around you for a short time",
		"level": "Ultimate",
		"prerequisite": ["flail8"],
		"type": "weapon"
	},
	"grenade1": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Throw a grenade at a random enemy target",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"grenade2": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Throw an additional grenade at a random enemy target",
		"level": "Level: 2",
		"prerequisite": ["grenade1"],
		"type": "weapon"
	},
	"grenade3": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Throw stronger grenades at a random enemy target",
		"level": "Level: 3",
		"prerequisite": ["grenade2"],
		"type": "weapon"
	},
	"grenade4": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Throw even stronger grenades at a random enemy target",
		"level": "Level: 4",
		"prerequisite": ["grenade3"],
		"type": "weapon"
},
	"grenade5": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Throw a grenade at a random enemy target",
		"level": "Level: 5",
		"prerequisite": ["grenade4"],
		"type": "weapon"
	},
	"grenade6": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Throw an additional grenade at a random enemy target",
		"level": "Level: 6",
		"prerequisite": ["grenade5"],
		"type": "weapon"
	},
	"grenade7": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Throw stronger grenades at a random enemy target",
		"level": "Level: 7",
		"prerequisite": ["grenade6"],
		"type": "weapon"
	},
	"grenade8": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Throw even stronger grenades at a random enemy target",
		"level": "Level: 8",
		"prerequisite": ["grenade7"],
		"type": "weapon"
	},
	"grenade9": {
		"icon": WEAPON_PATH + "grenade.png",
		"displayname": "Grenade",
		"details": "Ultimate Grenade. Throw even stronger grenades at a random enemy target",
		"level": "Ultimate",
		"prerequisite": ["grenade8"],
		"type": "weapon"
},
}
