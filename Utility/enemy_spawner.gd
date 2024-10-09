extends Node2D

@export var enemy_cap = 500
var enemy_softcap = 1500
var enemies_to_spawn = []

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

@onready var get_points: PathFollow2D = %SpawnPathFollow

@export var time = 0

signal changetime(time)

func _ready():
	connect("changetime", Callable(player, "change_time"))

func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	var my_children = get_children()
	print("Total Enemies: ", my_children.size())
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					#For every child of EnemySpawner, check if they are 500 or more distance away from player. If they are, remove them from scene and append to enemies_to_spawn to respawn them, and increment counter +1.
					for e in get_children():
						#Separation Delay
						var separationDelay: float = randf_range(1.0,2.0)
						var separationTime: float = 0.0
						
						#Separation counter
						separationTime += randf_range(0.8,1.2)
						if separationTime >= separationDelay:
						#	check_separation(e)
							separationTime = 0.0
						
							var separation: int = (player.position - e.position).length()
							if separation >= 500:
								e.queue_free()
								#e.PROCESS_MODE_DISABLED
								enemies_to_spawn.append(new_enemy)
								counter += 1
													
						#If total enemies is larger than set softcap, send signal. (Signal triggers disabling of collisions)
					if my_children.size() > enemy_softcap:
						GlobalSignals.enemy_softcap.emit()
					#If total enemies is below set enemy_cap, get a random point on the SpawnPath of the Player, instantiate a new Node, set its position, and add it as a child to this scene.
					#If total is at or above enemy cap, append to enemies_to_spawn for later.
					if my_children.size() < enemy_cap:
						get_points.progress_ratio = randf()
						var enemy_spawn = new_enemy.instantiate()
						enemy_spawn.global_position = get_points.global_position
						#Wait between 0 and 2 frames to add new child, might not be necessary.
						#await get_tree().create_timer(randf_range(0.0, 0.033333)).timeout
						add_child(enemy_spawn)
					else:
						enemies_to_spawn.append(new_enemy)
					counter += 1
					
	if my_children.size() <= enemy_cap and enemies_to_spawn.size() > 0:
		var spawn_number = clamp(enemies_to_spawn.size(),1 , 50) -1
		var counter = 0
		while counter < spawn_number:
			var new_enemy = enemies_to_spawn[0].instantiate()
			get_points.progress_ratio = randf()
			new_enemy.global_position = get_points.global_position
			add_child(new_enemy)
			enemies_to_spawn.remove_at(0)
			counter += 1
	emit_signal("changetime", time)
