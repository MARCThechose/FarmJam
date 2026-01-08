extends Resource
class_name EnemyData


@export var max_health: int = 10
@export var damage: int = 10
@export var score_value: int = 1

# --- MOVEMENT STATS 
@export var move_speed: float = 100.0
@export var hover_distance: float = 200.0
@export var float_amplitude: float = 20.0
@export var float_frequency: float = 2.0

# --- WALKER-SPECIFIC STATS 
@export var attack_speed: float = 300.0 

# --- SHOOTER-SPECIFIC STATS
@export var fire_rate: float = 300
@export var charge_range: float = 100.0
@export var bullet_scene: PackedScene
