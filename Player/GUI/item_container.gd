extends TextureRect

var upgrade = null
var itemName = null

@onready var player = get_tree().get_first_node_in_group("player")
@onready var shotgun = preload("res://Textures/Items/Weapons/gun_ult_outline.png")

func _ready() -> void:
	
	if upgrade != null:
		$ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])
		$Label.text = UpgradeDb.UPGRADES[upgrade]["level"].substr(7,-1)
		itemName = UpgradeDb.UPGRADES[upgrade]["name"]
		
func update():
	match itemName:
		"Pistol":
			if player.ice_spear_level <= 8:
				$Label.text = str(player.ice_spear_level)
			if player.ice_spear_level >= 9:
				$Label.text = "U"
				$ItemTexture.texture = load("res://Textures/Items/Weapons/gun_ult_outline.png")
		"Flail":
			$Label.text = str(player.flail_level)
		"Sword":
			$Label.text = str(player.sword_level)
		"Grenades":
			$Label.text = str(player.grenade_level)
		"Magnet":
			$Label.text = str(player.orb_level)
		"Ammo Box":
			$Label.text = str(player.ring_level)
		"Boots":
			$Label.text = str(player.speed_level)
		"Armor":
			$Label.text = str(player.armor_level)

func _on_timer_timeout() -> void:
	update()
