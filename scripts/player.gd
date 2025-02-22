class_name Player extends CharacterBody2D

signal laser_shot
signal killed
signal shield_changed

@export var speed = 500
@export var rate_of_fire := 0.4
@export var level = 1
@export var autoshot = false
@export var god_mode:bool = false
@export var shield:int = 1
@export var shield_max_value: int = 1
@export var shield_repair_time: int = 10
@export var shield_in_repair = false

@onready var muzzle = $Muzzle
 
const laser_scene = preload("res://scenes/laser.tscn")
@onready var level_up_sound = $SFX/LevelUp
@onready var shield_up_sound = $SFX/ShieldUp
@onready var shield_down_sound = $SFX/ShieldDown
@onready var notes = $Notes
@onready var sheld_sprite = $Shield
@onready var sheld_half_sprite = $HalfShield

var shoot_cd := false
var shoot_value:int = 0
var alive := true

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	info ("to move use arrow keys")
	#await get_tree().create_timer(3).timeout
	#info ("press space to shoot")
	await get_tree().create_timer(3).timeout
	shield_change(shield)
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
	#print(shield)

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
	if level == 3:
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
	if level >= 4:
		var x
		var angle
		if shoot_value%2==0:#or first_shot==true):
			x=0
			angle = 0
			laser_shot.emit("player", laser_scene, muzzle.global_position+Vector2(0,-75),angle, 1, x)
			shoot_value +=3
			# Side shot
			#func _on_laser_shot(type, laser_scene, location, start_rotation, y_movement:float, x_movement:float):
			laser_shot.emit("player", laser_scene, muzzle.global_position+Vector2(-75,0),-73, 0.3, 1)
			laser_shot.emit("player", laser_scene, muzzle.global_position+Vector2(75,0),73, 0.3, -1)
		else:
			laser_shot.emit("player", laser_scene, muzzle.global_position+Vector2(30,-30),30, 0.8, -0.5)
			laser_shot.emit("player", laser_scene, muzzle.global_position+Vector2(0,-50),0, 1, 0)
			laser_shot.emit("player", laser_scene, muzzle.global_position+Vector2(-30,-30),-30, 0.8, 0.5)
			shoot_value +=3

func die():
	if shield>0:
		# Shield damage
		shield-=1
		shield_change(shield)
		shield_repair()
	else:
		if god_mode:
			pass
		info("Critical Damage !!!")
		alive = false
		killed.emit()
		queue_free()

func level_up():
	if level < 3:
		# Normal
		rate_of_fire -= 0.1
	#elif level > 2:
	#	rate_of_fire /= 2
	level_up_sound.play()
	level +=1
	info("Ship upgrade!")
	if level == 4:
		shield_max_value +=1
		await get_tree().create_timer(1).timeout
		info("Shild update!")
		shield = 2
		shield_change(shield)
		shield_repair_time /= 2
	
func shield_change(value:int):
	# 1 active
	# 2 full
	# 0 lack
	if value==0:
		shield = false
		sheld_sprite.visible = false
		sheld_half_sprite.visible = false
		info("Shield is Down")
		#shield_changed.emit("Broken")
		shield_down_sound.play()
	if value==1:
		sheld_half_sprite.visible = true
		sheld_sprite.visible = false
		#shield_changed.emit("Active")
		shield_up_sound.play()
		if shield_max_value == 1:
			info("Shield is Active")
		else: 
			info("Shield in repair (1/2)")
	if value==2:
		sheld_half_sprite.visible = false
		sheld_sprite.visible = true
		shield_up_sound.play()
		info("Shield repaired (2/2)")
	
func info(text:String):
	print("------\nShip Info: ",text,"\n------")
	notes.text = text
	notes.visible = true
	await get_tree().create_timer(2).timeout
	notes.visible = false

func shield_repair():
	if !shield_in_repair:
		shield_in_repair = true
		if shield == shield_max_value:
			pass # is already repaired
		while shield < shield_max_value:
			await get_tree().create_timer(shield_repair_time).timeout
			shield +=1
			# in 4 level shield is immediately equal 2
			if shield > shield_max_value:
				shield = shield_max_value
			shield_change(shield)
		shield_in_repair = false
