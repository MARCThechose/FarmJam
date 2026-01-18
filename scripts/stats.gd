# res://scripts/Stats.gd
extends Node


var plant_max_hp: float = 100.0
var plant_fire_rate: float = 1.0   
var plant_damage: int = 1
var plant_pierce: int = 1          

var drone_speed: float = 200.0
var drone_collection_radius: float = 50.0
var drone_knockback_power: float = 300.0 

var current_level: int = 1
var current_xp: int = 0
var xp_to_next_level: int = 10

signal leveled_up(new_level)

func add_xp(amount: int):
	current_xp += amount
	if current_xp >= xp_to_next_level:
		level_up()

func level_up():
	current_level += 1
	current_xp -= xp_to_next_level
	xp_to_next_level = int(xp_to_next_level * 1.4) + 5
	
	emit_signal("leveled_up", current_level)
	get_tree().paused = true
