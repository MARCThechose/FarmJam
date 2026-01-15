extends Area2D

@export var maxHP = 100
var currentHP = 100

@onready var hp = $plant/HPlabel
@onready var hp_label = $plant/HPlabel
@onready var health_bar = $healthBar
func _ready():
	Global.plantNode = self
	currentHP = Stats.plant_max_hp
	set_health_bar()
	
	health_bar.max_value = Stats.plant_max_hp
	health_bar.value = currentHP
	
	update_ui()

func update_ui():
	health_bar.value = currentHP
	
func set_health_bar() -> void:
	$healthBar.value = currentHP
func take_damage(damage):
	currentHP -= damage
	print("touchy!")
	set_health_bar()
	if currentHP < 0:
		die()

func defense_turret(delta):
	pass
		
func die():
	Global.arena.emit_signal("game_over")
	queue_free()
