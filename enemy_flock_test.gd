extends CharacterBody2D

# Variables for movement speed and distances
@export var speed := 40.0
@export var avoid_distance := 100.0  # Distance at which enemies avoid each other
@export var cohesion_distance := 200.0  # Distance to move toward the group
@export var alignment_distance := 150.0  # Distance for aligning with other enemies
@export var avoid_strength := 0.5  # Strength of separation
@export var cohesion_strength := 0.1  # Strength of cohesion (how much they group)
@export var alignment_strength := 0.3  # Strength of alignment (how much they match movement)
@onready var player = get_tree().get_first_node_in_group("player")
@export var other_enemies_group := "enemy"  # Group name for enemies

func _physics_process(delta):
	if player == null:
		return  # If no player is assigned, exit the function

	var separation := Vector2.ZERO
	var cohesion := Vector2.ZERO
	var alignment := Vector2.ZERO
	var movement_direction := Vector2.ZERO

	var total_neighbors := 0
	var average_position := Vector2.ZERO  # For cohesion
	var average_velocity := Vector2.ZERO  # For alignment

	# Move toward the player
	var direction_to_player := global_position.direction_to(player.global_position)
	movement_direction += direction_to_player

	# Flocking behavior: Separation, Cohesion, and Alignment
	for enemy in get_tree().get_nodes_in_group(other_enemies_group):
		if enemy != self:
			var distance_to_enemy := global_position.distance_to(enemy.global_position)
			
			# Separation (avoidance) behavior
			if distance_to_enemy < avoid_distance:
				var direction_to_enemy := global_position.direction_to(enemy.global_position)
				separation -= direction_to_enemy / distance_to_enemy  # Inverse distance to create stronger avoidance when closer

			# Cohesion (move toward average position of neighbors)
			if distance_to_enemy < cohesion_distance:
				average_position += enemy.global_position
				total_neighbors += 1

			# Alignment (move in the same direction as nearby enemies)
			if distance_to_enemy < alignment_distance:
				average_velocity += enemy.velocity

	# Apply separation (avoidance)
	separation = separation.normalized() * avoid_strength

	# Apply cohesion (moving toward the average position of neighbors)
	if total_neighbors > 0:
		average_position /= total_neighbors
		cohesion = (average_position - global_position).normalized() * cohesion_strength

	# Apply alignment (matching movement direction of neighbors)
	if total_neighbors > 0:
		alignment = average_velocity.normalized() * alignment_strength

	# Combine flocking behaviors with movement toward the player
	var final_direction := (movement_direction + separation + cohesion + alignment).normalized()

	# Move the enemy based on the final calculated direction
	global_position += final_direction * speed * delta
