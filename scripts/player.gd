class_name Player extends CharacterBody2D

signal laser_shot
signal killed
signal shield_changed

@export var speed = 500
@export var rate_of_fire := 0.4
@export var level = 1
@export var autoshot = false
@export var god_mode:bool = false
@export var shield:bool = true

@onready var muzzle = $Muzzle
 
const laser_scene = preload("res://scenes/laser.tscn")
@onready var level_up_sound = $SFX/LevelUp
@onready var shield_up_sound = $SFX/ShieldUp
@onready var shield_down_sound = $SFX/ShieldDown

var shoot_cd := false
var shoot_value:int = 0
var alive := true

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# check if shoot
	if Input.is_action_pressed("shoot") and !autoshot:
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
	elif autoshot:
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

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
		var x
		var angle
		#var wait = 0.001
		if shoot_value%2==0:#or first_shot==true):
			#print("odd")
			x=0
			angle = 0
			laser_shot.emit("player", laser_scene, muzzle.global_position,angle, 1, x)
			shoot_value +=1
		else:
			#print("not odd")
			var y:float
			x=0.5
			y = 0.8 
			angle = -30
			for n in 3:
				laser_shot.emit("player", laser_scene, muzzle.global_position,angle, y, x)
				angle +=30
				x-=0.5
				shoot_value +=3
				if n==0:
					y=1
				if n==1:
					y-=0.2
	if level >= 3:
		var x
		var angle
		if shoot_value%2==0:#or first_shot==true):
			x=0
			angle = 0
			laser_shot.emit("player", laser_scene, muzzle.global_position,angle, 1, x)
			shoot_value +=1
		else:
			var y:float
			x=0.5
			y = 0.8 
			angle = -30
			for n in 3:
				laser_shot.emit("player", laser_scene, muzzle.global_position,angle, y, x)
				angle +=30
				x-=0.5
				shoot_value +=3
				if n==0:
					y=1
				if n==1:
					y-=0.2

func die():
	if god_mode:
		pass
	elif shield:
		shield = false
		shield_changed.emit("Broken")
		shield_down_sound.play()
		await get_tree().create_timer(15).timeout
		shield = true
		shield_changed.emit("Active")
		shield_up_sound.play()
	else:
		alive = false
		killed.emit()
		queue_free()

func level_up():
	if level < 3:
		# Normal
		level +=1
		rate_of_fire -= 0.1
	elif level == 3:
		rate_of_fire /= 2
	level_up_sound.play()
	level +=1
	
	
