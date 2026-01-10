# res://scripts/enemy_shooter.gd
extends "res://scripts/enemy_base.gd" 


enum State {HOVERING, CHARGING_SHOT}
var current_state = State.HOVERING
var time_passed: float = 0.0

@onready var fire_timer: Timer = $FireTimer 

func _ready():
	super._ready()
	fire_timer.wait_time = enemy_data.charge_up_time
	fire_timer.one_shot = true # It only fires ONCE, then we move on
	if not fire_timer.timeout.is_connected(_on_fire_timer_timeout):
			fire_timer.timeout.connect(_on_fire_timer_timeout)

func _physics_process(delta: float):
	time_passed += delta
	
	if Global.plantNode == null:
		return 
		
	var distance_to_plant = global_position.distance_to(Global.plantNode.global_position)

	match current_state:
		State.HOVERING:
			_state_hovering(delta)		
			if distance_to_plant <= enemy_data.charge_range:
				current_state = State.CHARGING_SHOT
				fire_timer.start() 
				
	

func _state_hovering(delta):
	# The goal of a shooter in this state is simply to APPROACH the plant
	
	# 1. Calculate the direction directly towards the plant/base
	var direction_to_plant = global_position.direction_to(Global.plantNode.global_position)
	
	# 2. Calculate velocity to move directly towards the plant
	var velocity = direction_to_plant * enemy_data.move_speed
	
	# 3. Keep the "floating" offset for visual wiggle (Optional)
	var float_offset = sin(time_passed * enemy_data.float_frequency) * enemy_data.float_amplitude
	velocity.y += float_offset
		
	# 4. Apply movement
	global_position += velocity * delta

	# NOTE: DELETE ALL CODE LINES that reference 'direction_to_base' and 'ideal_hover_pos'

func fire_bullet():
	if Global.plantNode == null: return
		
	var bullet_instance = enemy_data.bullet_scene.instantiate()
	var direction_to_plant = global_position.direction_to(Global.plantNode.global_position).normalized()
	
	bullet_instance.global_position = global_position
	bullet_instance.direction = direction_to_plant 
	bullet_instance.initialize(direction_to_plant)
	
	if Global.node_creation_parent:
		Global.node_creation_parent.add_child(bullet_instance)
	else:
		get_parent().add_child(bullet_instance)

func _on_fire_timer_timeout():
	if current_state == State.CHARGING_SHOT:
		fire_bullet()
		
		die()
