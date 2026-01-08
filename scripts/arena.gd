extends Node2D

var enemy = preload("res://scenes/enemy_walker.tscn")
signal game_over

func _ready():
	Global.node_creation_parent = self
	Global.arena = self
	
	var callable = Callable(self, "_on_game_over")
	if not is_connected("game_over", callable):
		connect("game_over", callable)

func _on_spawner_timeout():
	var new_enemy = enemy.instantiate()
	var path_follow = get_node("Path2D/PathFollow2D")
	path_follow.progress_ratio = randf()
	new_enemy.global_position = path_follow.global_position
	add_child(new_enemy)

func _on_game_over():
	$spawner.stop()
	await get_tree().create_timer(1.25).timeout
	get_tree().reload_current_scene()

func _exit_tree():
	Global.node_creation_parent = null
	Global.arena = null
