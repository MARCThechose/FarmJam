# res://scripts/enemy_shooter.gd
extends "res://scripts/enemy_base.gd" 


enum State {HOVERING, CHARGING_SHOT, DYING}
var current_state = State.HOVERING
var time_passed: float = 0.0

@onready var fire_timer: Timer = $FireTimer 
#@onready var death_timer: Timer =$DeathTimer 
@onready var sprite_shoot: Sprite2D =$visual

@export var death_shake:float = 0.5
#@export var death_delay: float = 3.0

var orig_posi: Vector2 

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
		State.CHARGING_SHOT:
			pass
		State.DYING:
			var shake_offset = Vector2(randf_range(-death_shake, death_shake),
									   randf_range(-death_shake, death_shake))
			global_position = orig_posi + shake_offset
				
	

func _state_hovering(delta):
	var direction_to_plant = global_position.direction_to(Global.plantNode.global_position)
	
	var velocity = direction_to_plant * enemy_data.move_speed
	
	var float_offset = sin(time_passed * enemy_data.float_frequency) * enemy_data.float_amplitude
	velocity.y += float_offset
		
	global_position += velocity * delta

	

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
		
		start_dying_visuals()
		
		
