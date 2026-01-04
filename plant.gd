extends Area2D

signal plantimnu

@export var maxHP = 100
var currentHP = 100

@onready var hp = $plant/HPlabel

func _ready():
	Global.plantNode = self
	update_hp_disc()
	
func update_hp_disc():
	hp.text = "HP:" + str(currentHP)

func take_damage(damage):
	currentHP -= damage
	print("touchy!")
	update_hp_disc()
	if currentHP < 0:
		die()

func defense_turret(delta):
	pass
		
func die():
	Global.arena.emit_signal("game_over")
	queue_free()
