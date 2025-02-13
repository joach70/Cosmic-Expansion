# Add class as Enemy for laser detection
class_name Enemy extends Area2D

# give info about destryed enemy (player get points)
signal killed(points)
signal hit

const laser_scene = preload("res://scenes/laser.tscn")
signal laser_shot(laser_scene, location, start_rotation, y_movement, x_movement)

enum EnemyType {NORMAL=1, SPEED=2, SHOOTING=3, BOSS=4}
var boss_pos_x = [400, 960, 1520]
var boss_pos_y = [700,250]#[-300, -600]
@export var speed = 150
@export var type: EnemyType = EnemyType.NORMAL
@export var level = 1
@export var points = 100
#@export var y_movement := false
@onready var muzzle: Marker2D = $Muzzle
@onready var explode_sound = $SFX/ExpodeSound
@onready var hit_sound = $SFX/HitSound

var is_waiting = true
var is_shooting = false
var move = 100
var wait_value: float = 4
var rate_of_fire = 1.5
var hp: int
var boss: bool
var teleport: bool

func _ready() -> void:
	if type == 1:
		hp = 2
	if type == 2:
		hp = 1
	if type == 3:
		hp = 5
		is_shooting = true
	if type == 4:
		boss = true
		hp = 10
		speed = 0
		is_shooting = true
		teleport = true
	# For all
	hp *= level
	points *= level
	# Routine
	var stop:bool = true
	var loop:int = 1
	if !teleport and !is_shooting:
		stop = false
		pass
	while stop:
		if teleport:
			await get_tree().create_timer(1).timeout
			teleport_func()
		if is_shooting:
			await get_tree().create_timer(rate_of_fire).timeout
			shoot()
		#if teleport==true and loop == 1:
		#	await get_tree().create_timer(1).timeout
		#	print("teleport")
		#	await get_tree().create_timer(1).timeout
		#	teleport_func()
		#if is_shooting:
		#	await get_tree().create_timer(rate_of_fire).timeout
		#	print("fire")
		#	#shoot()
		#loop += 1
		#loop = loop% 6
		

func teleport_func():
	var change:bool = false
	var x:int
	var y:int
	var x_array_size:int = boss_pos_x.size()
	var y_array_size:int = boss_pos_y.size()
	while change == false:
		x = randi_range(0,x_array_size)%x_array_size
		y = randi_range(0,y_array_size)%y_array_size
		if (boss_pos_x[x-1]!= global_position.x or boss_pos_y[y-1]!= global_position.y):
			change = true
		else:
			print("False")
	change = false
	global_position.x = boss_pos_x[x-1]
	global_position.y = boss_pos_y[y-1]

func change_direction(): 
	is_waiting = false
	await get_tree().create_timer(wait_value).timeout
	#if move>0:
	move *= -1
	#else:
		#pass
	is_waiting = true

func shoot():
	#is_shooting = true
	var location = muzzle.global_position + Vector2(0,-10)
	if type==4: # Boss is a little bigger
		laser_shot.emit("enemy", laser_scene, muzzle.global_position+Vector2(0,50),0, -1, 0)
	else:
		laser_shot.emit("enemy", laser_scene, muzzle.global_position+Vector2(0,40),0, -1, 0)
		#is_shooting = false

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta
	#if y_movement:
	#	global_position.x += move * delta
	#	#initiate
	if is_waiting:
		change_direction()
	if !is_shooting:
		shoot()
	
func die():
	# Sound
	# remove enemy
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Colision with player
	if body is Player:
		body.die()
		die()

func take_damage(amount):
	hit_sound.play()
	hp -= amount
	if hp <= 0:
		killed.emit(points)
		die()
	else:
		hit.emit()
		print("got it")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# kill when go outside of screen
	queue_free()
