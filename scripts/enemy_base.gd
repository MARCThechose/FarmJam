extends Area2D


@export var damage: int = 1
@export var max_hp = 3
@export var enemy_data: EnemyData 


@onready var death_timer: Timer = $DeathFlair

@export var death_delay: float = 3.0
@onready var visual_sprite: Sprite2D = $visual



var current_hp: int
var imnu: bool = false

const BLOOD_PAR_SCENE = preload("res://scenes//bloodparticles.tscn")

func _ready():
		if max_hp == null:
				max_hp = 3 
		
		current_hp = max_hp
		
func take_damage(amount: int):
	if imnu:
		return
	current_hp -= amount
	
	if current_hp <= 0:
		start_dying_visuals()
		
func die():
	if Global.node_creation_parent != null:
		
		var bpi = Global.Instance_node(BLOOD_PAR_SCENE, global_position, Global.node_creation_parent)
		bpi.rotation = randf() * 2 * PI	
	Global.score += 1
	
	visual_sprite.modulate = Color.WHITE 
	queue_free()
	
func _on_imnu_timeout():
	modulate = Color.RED
	imnu = false
	
func _physics_process(_delta):
	pass
	
func start_dying_visuals():
	set_physics_process(false)
	death_timer.wait_time = death_delay
	death_timer.one_shot = true
	death_timer.start()

	visual_sprite.modulate = Color.WHITE # Clean slate
	var tween = create_tween()
	tween.stop()
	tween.tween_property(visual_sprite, "modulate", Color.RED, death_delay).set_ease(Tween.EASE_OUT)
	tween.play()
	
	if not death_timer.timeout.is_connected(_on_death_timer_timeout):
		death_timer.timeout.connect(_on_death_timer_timeout)


func _on_death_timer_timeout() -> void:
	var flash_tween = create_tween()
	flash_tween.tween_property(visual_sprite, "modulate", Color.WHITE, 0.05)
	flash_tween.finished.connect(die)
