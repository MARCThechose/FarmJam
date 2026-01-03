extends Area2D

signal plantimnu

@export var maxHP = 3

func _ready():
	Global.plantNode = self

func damage():
	maxHP -= 1
	print("touchy!")
	
	if maxHP < 0:
		die()
	
		
func die():
	Global.arena.emit_signal("game_over")
	queue_free()
