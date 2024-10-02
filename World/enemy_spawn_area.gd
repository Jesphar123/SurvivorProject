extends Node2D

var enemy_cap = 300
var enemies_to_spawn = []

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

@onready var spawnArea = $"../SpawnArea".shape.extents
@onready var origin = $"../SpawnArea".global_position - spawnArea

func get_random_pos():
	var x_pos = randf_range(origin.x, spawnArea.x)
	var y_pos = randf_range(origin.y, spawnArea.y)
	
	return Vector2(x_pos, y_pos)

@export var time = 0

signal changetime(time)

func _ready():
	connect("changetime", Callable(player, "change_time"))

func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	var my_children = get_children()
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					if my_children.size() < enemy_cap:
						var enemy_spawn = new_enemy.instantiate()
						enemy_spawn.global_position = get_random_pos()
						add_child(enemy_spawn)
					else:
						enemies_to_spawn.append(new_enemy)
					counter += 1
	if my_children.size() <= enemy_cap and enemies_to_spawn.size() > 0:
		var spawn_number = clamp(enemies_to_spawn.size(),1 , 50) -1
		var counter = 0
		while counter < spawn_number:
			var new_enemy = enemies_to_spawn[0].instantiate()
			new_enemy.global_position = get_random_pos()
			add_child(new_enemy)
			enemies_to_spawn.remove_at(0)
			counter += 1
	emit_signal("changetime", time)
