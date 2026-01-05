extends "res://scenes/enemy_base.gd"

enum State {FLOATING, ATTACKING}
var current_state = State.FLOATING

@export var float_speed = 50.0
@export var attack_speed = 250.0 
@export var hover_distance = 150.0

@export var float_amplitude = 20.0 
@export var float_frequency = 2.0  

var time_passed = 0.0

var attack_target_position = Vector2.ZERO

@onready var attack_timer = $AttackEnemy

func _ready():
	super._ready()
	attack_timer.wait_time = randf_range (2.0, 4.0)
	attack_timer.start()
	

func _physics_process(delta):
	time_passed += delta
	
	if Global.plantNode == null:
		return

	match current_state:
		State.FLOATING:
			_state_floating(delta)
		State.ATTACKING:
			_state_attacking(delta)
			
func _state_floating(delta):
	var direction_to_base = Global.PlantNode.Global_position.direction_to(global_position)
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
		attack_timer.wait_time = randf_range(2.0, 4.0)
		attack_timer.start()
		
	

func 	


func _on_attack_enemy_timeout() -> void:
	pass # Replace with function body.
