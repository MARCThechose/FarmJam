extends Area2D


@export var damage: int = 1
@export var max_hp = 3

var current_hp: int
var imnu: bool = false

const BLOOD_PAR_SCENE = preload("res://scenes//bloodparticles.tscn")

func _ready():
		current_hp = max_hp
		
func take_damage(amount: int):
	if imnu:
		return
	current_hp -= amount
	
	if current_hp <= 0:
		die()
		
func die():
	if Global.node_creation_parent != null:
		
		var bpi = Global.Instance_node(BLOOD_PAR_SCENE, global_position, Global.node_creation_parent)
		bpi.rotation = randf() * 2 * PI	
		
	Global.score += 1
	queue_free()
	
func _on_imnu_timeout():
	modulate = Color.RED
	imnu = false
	
func _physics_process(delta):
	pass
