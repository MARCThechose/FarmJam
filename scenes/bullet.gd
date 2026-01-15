extends Area2D

var direction = Vector2.ZERO
var speed = 250
var damage = 10

func initialize(dir: Vector2):
	direction = dir
	rotation = direction.angle()
func _process(delta):
	global_position += direction * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("plantb"):
		if area.has_method("take_damage"):
			area.take_damage(damage)
			queue_free() 
