class_name Laser extends Area2D

@export var speed = 600
@export var damage = 1
@export var start_rotation = 0
@export var x_movement:float = 0
@export var y_movement:float = 1

@onready var laser_sound = $SFX/LaserSound
@onready var hit_sound = $SFX/HitSound
@onready var type: String

func _ready() -> void:
	if type == "player":
		laser_sound.volume_db -=15
	laser_sound.play()
 
	rotation_degrees = start_rotation

func _physics_process(delta):
	# go up
	global_position.y += -speed * delta * y_movement
	global_position.x += -speed * delta * x_movement	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		if type=="enemy":
			# If enemy hit enemy
			pass
		else:
			# If enemy hit not enemy (currently nothing)
			area.take_damage(damage)
			queue_free()
	if area is Laser:
		# If laser hit laser
		if (type=="player" and area.type == "enemy") or (type=="enemy" and area.type =="player"):
			# Only laser from diferent team will be explode
			hit_sound.play()
			area.queue_free()
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if type != "player":
			# Hit player
			body.die()
			queue_free()
