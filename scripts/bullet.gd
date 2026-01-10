extends Sprite2D

var direction = Vector2.ZERO
var speed = 250

func initialize(dir: Vector2):
	direction = dir
	rotation = direction.angle()
func _process(delta):
	global_position += direction * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
