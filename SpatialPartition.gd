# SpatialPartition.gd
extends Node

@export var cell_size: float = 32.0  # Size of each grid cell
var grid: Dictionary = {}

func add_enemy(enemy: CharacterBody2D) -> void:
	var cell_key = get_cell_key(enemy.global_position)
	if not cell_key in grid:
		grid[cell_key] = []
	grid[cell_key].append(enemy)

func remove_enemy(enemy: CharacterBody2D) -> void:
	var cell_key = get_cell_key(enemy.global_position)
	if cell_key in grid:
		grid[cell_key].erase(enemy)
		# Check if the array is empty using size() method
		if grid[cell_key].size() == 0:
			grid.erase(cell_key)

func update_enemy_position(enemy: CharacterBody2D) -> void:
	var current_cell_key = get_cell_key(enemy.global_position)
	if current_cell_key in grid and enemy in grid[current_cell_key]:
		return  # The enemy is still in the same cell

	# Remove from the old cell and add to the new cell
	remove_enemy(enemy)
	add_enemy(enemy)

func get_cell_key(position: Vector2) -> String:
	return str(floor(position.x / cell_size)) + "_" + str(floor(position.y / cell_size))

func get_nearby_enemies(position: Vector2, separation_distance: float) -> Array:
	var nearby_enemies = []
	var cell_key = get_cell_key(position)

	# Calculate the range of cells to check based on separation_distance
	var min_x = floor((position.x - separation_distance) / cell_size)
	var max_x = floor((position.x + separation_distance) / cell_size)
	var min_y = floor((position.y - separation_distance) / cell_size)
	var max_y = floor((position.y + separation_distance) / cell_size)

	# Loop through the relevant cells
	for x_offset in range(min_x, max_x + 1):
		for y_offset in range(min_y, max_y + 1):
			var check_key = str(x_offset) + "_" + str(y_offset)
			if check_key in grid:
				nearby_enemies += grid[check_key]

	return nearby_enemies
