extends "res://scripts/enemy_base.gd"

enum State {FLOATING, CHARGING}
var current_state = State.FLOATING

var time_passed = 0.0
var attack_target_position = Vector2.ZERO # Target to charge to

func _ready():
	super._ready()
func _physics_process(delta):
	time_passed += delta
	
	if Global.plantNode == null:
		return
		
	var distance_to_plant = global_position.distance_to(Global.plantNode.global_position)
	if enemy_data == null:
		return 
	if current_state == State.FLOATING and distance_to_plant <= enemy_data.charge_range:
		current_state = State.CHARGING
		attack_target_position = Global.plantNode.global_position # Lock the target
		
	elif current_state == State.CHARGING and global_position.distance_squared_to(attack_target_position) < 100:
		current_state = State.FLOATING

	match current_state:
		State.FLOATING:
			_state_floating(delta)
		State.CHARGING:
			_state_charging(delta)
			

func _state_floating(delta):

	var direction_to_plant = global_position.direction_to(Global.plantNode.global_position)
	
	var velocity = direction_to_plant * enemy_data.move_speed
	
	var float_offset = sin(time_passed * enemy_data.float_frequency) * enemy_data.float_amplitude
	velocity.y += float_offset
	global_position += velocity * delta
	
func _state_charging(delta):
	var direction = global_position.direction_to(attack_target_position)
	var velocity = direction * enemy_data.attack_speed
	
	global_position += velocity * delta
		

func _on_area_entered(body):
	if body.is_in_group("plantb"):
		body.take_damage(enemy_data.damage)
		queue_free() # Suicide on hit 
