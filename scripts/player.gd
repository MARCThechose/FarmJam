extends CharacterBody2D

const MAX_SPEED = 200
const ACCELERATION = 1200
const FRICTION = 1000

var can_shoot = true
var bullet_scene = preload("res://scenes/bullet.tscn")

func _ready():
	Global.player = self

func _exit_tree():
	Global.player = null

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		if collider.is_in_group("enemy"):
			die()
	
	if Input.is_action_pressed("click") and Global.node_creation_parent != null and can_shoot:
		var b = bullet_scene.instantiate()
		b.global_position = global_position
		Global.node_creation_parent.add_child(b)
		$reload.start()
		can_shoot = false

func _on_reload_timeout():
	can_shoot = true

func die():
	Global.arena.emit_signal("game_over")
	queue_free()
