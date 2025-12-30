extends Sprite2D

var speed = 10

var velocity = Vector2()
var imnu = false
var hp = 100

func _process(delta):
	if Global.player != null and !imnu:
		velocity = global_position.direction_to(Global.player.global_position)
	
	global_position += velocity * speed * delta
	
	if hp <= 0:
		queue_free()


func _on_hitbox_area_entered(area: Area2D):
	if area.is_in_group("Enemy_damage"):
		modulate = Color.RED
		hp -= 1
		imnu = true
		$Inmu.start()
		area.get_parent().queue_free() 


func _on_inmu_timeout():
	modulate = Color.WHITE
	imnu = false
