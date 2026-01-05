extends Area2D

enum State { FLOATING, ATTACKING }
var current_state = State.FLOATING

@export var float_speed = 50.0 
@export var attack_speed = 250.0 
@export var hover_distance = 150.0

@export var damage = 1
@export var float_amplitude = 20.0 
@export var float_frequency = 2.0  
var time_passed = 0.0


var imnu = false
var hp = 3

var velocity_vector: Vector2 = Vector2.ZERO


var bloodPar = preload("res://scenes/bloodparticles.tscn")
var attack_target_position = Vector2.ZERO

func _ready():
	
	$AttackEnemy.wait_time = randf_range(2.0, 4.0)
	$AttackEnemy.start()

func _physics_process(delta):
	time_passed += delta
	
	if Global.plantNode == null:
		return 
		
	match current_state:
		State.FLOATING:
			_state_floating(delta)
		State.ATTACKING:
			_state_attacking(delta)
			

	if hp <= 0:
		die()

func _state_floating(delta):
	var direction_to_base = Global.plantNode.global_position.direction_to(global_position)
	var ideal_hover_pos = Global.plantNode.global_position + direction_to_base * hover_distance
	
	var velocity = global_position.direction_to(ideal_hover_pos) * float_speed
	
	var float_offset = sin(time_passed * float_frequency) * float_amplitude
	velocity.y += float_offset
	
	global_position += velocity * delta


func _state_attacking(delta):
	var direction = global_position.direction_to(attack_target_position)
	var velocity = direction * attack_speed
	
	global_position += velocity * delta
	
	if global_position.distance_squared_to(attack_target_position) < 100:
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
	if Global.plantNode != null and current_state == State.FLOATING:
		attack_target_position = Global.plantNode.global_position
		current_state = State.ATTACKING


func _on_area_entered(body):
	if body.is_in_group("plantb"):
		body.take_damage(damage)
		queue_free()
