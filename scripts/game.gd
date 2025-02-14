extends Node2D

var enemy_scenes1: Array[PackedScene] = [
	preload("res://scenes/diver_enemy.tscn"),
	preload("res://scenes/enemy.tscn"),
	preload("res://scenes/enemy_shooting.tscn")]
var enemy_scenes2: Array[PackedScene] = [
	preload("res://scenes/diver_enemy_2.tscn"),
	preload("res://scenes/enemy_2.tscn"),
	preload("res://scenes/enemy_shooting_2.tscn")]
var enemy_scenes3: Array[PackedScene] = [
	preload("res://scenes/diver_enemy_3.tscn"),
	preload("res://scenes/enemy_3.tscn"),
	preload("res://scenes/enemy_shooting_3.tscn")]
var enemy_boss: Array[PackedScene] = [
	preload("res://scenes/boss.tscn"),
	preload("res://scenes/boss_2.tscn"),
	preload("res://scenes/boss_3.tscn")]

# Export
# 1
@export var turn1:int = 20 # enemy before first boss
@export var wait_enemy1 = 2.5
# 2
@export var turn2 = 30 # enemy before first boss
@export var wait_enemy2 = 1.75
# 3
@export var turn3 = 60 # enemy before first boss
@export var wait_enemy3 = 1.5
# 4
@export var turn4 = 60 # enemy before first boss
@export var wait_enemy4 = 1
# All
@export var wait_boss = 10 # time how long wait boss
@export var turn = 1 # start level

# On ready
@onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $LaserContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen #gos = game over screen
@onready var pb = $ParallaxBackground

@onready var laser_sound = $SFX/LaserSound
@onready var hit_sound = $SFX/HitSound
@onready var explode_sound = $SFX/ExpodeSound

var player = null
var score: int = 0:
	set(value):
		score = value
		hud.score = score
var shield: String = "Active":
	set(value):
		shield = value
		hud.shield = shield
var high_score
var scroll_speed = 100

func _ready():
	# load hi-score
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!=null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
	# set score for start as 0
	score = 0
	# get player
	player = get_tree().get_first_node_in_group("player")
	# show error when player don't exist
	assert(player!=null)
	# set player location to player_spawner
	player.global_position = player_spawn_pos.global_position
	# connect player laser shoot signal to function
	player.laser_shot.connect(_on_laser_shot)
	player.shield_changed.connect(_player_shield)
	#enemy_boss.laser_shot.connect(_on_laser_shot)
	#enemy_shooting.laser_shot.connect(_on_laser_shot)
	#enemy.laser_shot.connect(_on_enemy_laser_shot)
	# connect player killed signal
	# ---
	# Command line setup
	var args = OS.get_cmdline_args()
	for arg in args:
		if arg.find("--turn=") == 0:
			turn = int(arg.split("=")[1])
	# ---
	if turn != 1:
		for n in turn-1:
			player.level_up()
	player.killed.connect(_on_player_killed)
	spawner()

func _player_shield(text:String):
	shield = text

func spawner():
	# Repeat Break
	await get_tree().create_timer(2).timeout
	var x:int = 1;
	var repeat_value: int = 1
	var wait_enemy: int
	if turn == 1:#while x>0:
		repeat_value = turn1
		wait_enemy = wait_enemy1
	elif turn == 2:
		repeat_value = turn2
		wait_enemy = wait_enemy2
	elif turn == 3:
		repeat_value = turn3
		wait_enemy = wait_enemy3
	elif turn >= 3:
		repeat_value = turn4
		wait_enemy = wait_enemy4
	for n in repeat_value:
		var enemy = choose_random_enemy(turn)
		spawn_enemy(enemy.instantiate())
		await get_tree().create_timer(wait_enemy).timeout
	if turn >=4:
		spawn_enemy(enemy_boss[2].instantiate())
	else:
		spawn_enemy(enemy_boss[turn-1].instantiate())

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)

func _process(delta: float):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		print("Quit")
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		print("Reload")
	if timer.wait_time > 0.5:
		timer.wait_time -= delta*0.01
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5
	#print(timer.wait_time)
	pb.scroll_offset.y += delta*scroll_speed
	#if pb.scroll_offset.y >= 1080:
	#	pb.scroll_offset.y = 0
	#print(pb.scroll_offset.y)

func _on_laser_shot(type, laser_scene, location, start_rotation, y_movement:float, x_movement:float):
	# create laser
	var laser = laser_scene.instantiate()
	# set laser position
	laser.global_position = location
	laser.start_rotation = start_rotation
	laser.x_movement = x_movement
	laser.y_movement = y_movement
	# add as child of laser_container
	laser_container.add_child(laser)
	if type == "player":
		laser.type = "player"
	if type == "enemy":
		laser.type = "enemy"

func choose_random_enemy(turn:int) -> PackedScene:
	var enemy_scenes
	if turn == 1: enemy_scenes = enemy_scenes1
	elif turn == 2: enemy_scenes = enemy_scenes2
	elif turn == 3: enemy_scenes = enemy_scenes3
	elif turn >= 4: enemy_scenes = enemy_scenes3
	else:
		print("Error while spawning")
		enemy_scenes = enemy_scenes1
	var size = enemy_scenes.size()
	var random = randi_range(0,size-1)
	return enemy_scenes[random]

func spawn_enemy(enemy) -> void:
	var margin: int = 100
	enemy.global_position = Vector2(randf_range(margin, 1920-margin), -50)
	# connect killed signal from enemy script -> run function
	enemy.killed.connect(_on_enemy_killed)
	enemy.hit.connect(_on_enemy_hit)
	#e.laser_shot.connect(_on_enemy_laser_shot)
	enemy_container.add_child(enemy)
	#await get_tree().create_timer(1).timeout
	# Shooting
	if enemy.type ==3 or enemy.type ==4:
		enemy.laser_shot.connect(_on_laser_shot)
		# Teleport
		if enemy.type == 4:
			enemy.boss_dead.connect(_on_boss_killed)

func _on_boss_killed():
	print("Boss Desktroyed")
	turn+=1
	if player.alive:
		player.level_up()
	spawner()

func _on_enemy_killed(points):
	score += points
	hit_sound.play()
	if score > high_score:
		high_score = score

func _on_enemy_hit():
	pass
	#hit_sound.play()

func _on_player_killed():
	# sound
	explode_sound.play()
	# set score
	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(1.5).timeout
	gos.visible = true
