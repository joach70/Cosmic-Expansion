class_name Player extends CharacterBody2D

signal laser_shot()#type, laser_scene, location, start_rotation, y_movement, x_movement)
signal killed

@export var speed = 500
@export var rate_of_fire := 0.4
@export var level = 1

@onready var muzzle = $Muzzle

# add Muzzle - wylot lufy 
const laser_scene = preload("res://scenes/laser.tscn")

var shoot_cd := false

func _ready() -> void:
	if level == 2:
		rate_of_fire /= 1.2

func _process(delta: float) -> void:
	# check if shoot
	if Input.is_action_pressed("shoot"):
		if !shoot_cd: # if shoot stop and press shoot then:
			# set shoot continue
			shoot_cd = true
			# shoot
			shoot()
			# wait a rate of fire
			await get_tree().create_timer(rate_of_fire).timeout
			# set shoot stop
			shoot_cd = false
		# if yes start shoot function

func _physics_process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	#print(direction)
	velocity = direction * speed
	move_and_slide()
	# Limit player movement
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
func shoot():
	# emits shoot signal
	if level == 1:
		laser_shot.emit("player", laser_scene, muzzle.global_position,0, 1, 0)
	if level == 2:
		var y = 1
		var angle = -30
		#var wait = 0.001
		for n in 3:
			#await get_tree().create_timer(wait).timeout
			laser_shot.emit("player", laser_scene, muzzle.global_position,angle, 1, y)
			angle +=30
			y-=1
	if level == 3:
		var multiplayer := 2
		var y = 3
		var angle = -45
		for n in 7:
			#await get_tree().create_timer(0.01).timeout
			laser_shot.emit("player", laser_scene, muzzle.global_position,angle, 1, y)
			angle +=15
			y-=1
		await get_tree().create_timer(rate_of_fire/2).timeout
		laser_shot.emit("player", laser_scene, muzzle.global_position,0, 1, 0)

func die():
	killed.emit()
	queue_free()

func level_up():
	if level == 3:
		pass
	else:
		level +=1
