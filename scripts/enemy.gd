extends CharacterBody2D

enum State { FLOATING, ATTACKING }
var current_state = State.FLOATING

@export var float_speed = 50.0 
@export var attack_speed = 250.0 # How fast it lunges at the player
@export var hover_distance = 150.0 # How far from the player it tries to stay

# --- Floating (Sine Wave) Parameters ---
@export var float_amplitude = 20.0 # How high and low it bobs
@export var float_frequency = 2.0  # How fast it bobs
var time_passed = 0.0

# --- Health and Immunity ---
var imnu = false
var hp = 3

# --- Other ---
var bloodPar = preload("res://scenes/bloodparticles.tscn")
var attack_target_position = Vector2.ZERO

func _ready():
	# Start the first attack countdown with a random delay
	$AttackEnemy.wait_time = randf_range(2.0, 4.0)
	$AttackEnemy.start()

func _physics_process(delta):
	time_passed += delta
	
	if Global.player == null:
		return # Do nothing if there's no player
		
	# This is our State Machine
	match current_state:
		State.FLOATING:
			_state_floating(delta)
		State.ATTACKING:
			_state_attacking(delta)
			
	# Health and death logic is independent of state
	if hp <= 0:
		die()

func _state_floating(delta):
	var direction_to_player = Global.player.global_position.direction_to(global_position)
	var ideal_hover_pos = Global.player.global_position + direction_to_player * hover_distance
	
	velocity = global_position.direction_to(ideal_hover_pos) * float_speed
	
	var float_offset = sin(time_passed * float_frequency) * float_amplitude
	velocity.y += float_offset
	
	move_and_collide(velocity * delta)


func _state_attacking(delta):
	var direction = global_position.direction_to(attack_target_position)
	velocity = direction * attack_speed
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider == Global.player:
			current_state = State.FLOATING
			$AttackEnemy.wait_time = randf_range(2.0, 4.0)
			$AttackEnemy.start()


func die():
	if Global.node_creation_parent != null: 
		var velocity_for_particles = global_position.direction_to(attack_target_position)
		var bpi = Global.Instance_node(bloodPar, global_position, Global.node_creation_parent)
		bpi.rotation = -(velocity_for_particles.angle())
		Global.score += 1
	queue_free()


func _on_inmu_timeout():
	modulate = Color.WHITE
	imnu = false

func _on_attack_enemy_timeout():
	if Global.player != null and current_state == State.FLOATING:
		attack_target_position = Global.player.global_position
		current_state = State.ATTACKING
