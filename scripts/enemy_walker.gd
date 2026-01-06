extends "res://scripts/enemy_base.gd"

enum State {ATTACKING, FLOATING}
var current_state = State.FLOATING

func _ready():
	super._ready()
	
func _physics_process(delta):
	time_passed += delta
	
	if Global.plantNode == null:
		return
		
	var distance_to_plant = global_position.distance_to(Global.plantNode.global_position)

	if current_state == State.FLOATING and distance_to_plant <= enemy_data.charge_range:
		current_state = State.CHARGING
		attack_target_position = Global.plantNode.global_position 	
	
