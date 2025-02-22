extends Area2D

@onready var laser_scene = preload("res://scenes/laser.tscn")
@onready var muzzle = $Muzzle
signal laser_shot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot()
	
func shoot():
	laser_shot.emit("player", laser_scene, muzzle.global_position,0, 1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
