extends Node2D

var enemy_scenes: Array[PackedScene] = [
	preload("res://scenes/diver_enemy.tscn"),
	preload("res://scenes/enemy.tscn"),
	preload("res://scenes/enemy_shooting.tscn")]
	
var enemy_boss: Array[PackedScene] = [preload("res://scenes/boss.tscn")]

# Export
@export var turn1 = 1 # enemy before first boss
@export var wait_boss = 5 # time how long wait boss
@export var wait_enemy = 2.5 # time between enemy respawn

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
var score := 0:
	set(value):
		score = value
		hud.score = score
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
	#enemy_boss.laser_shot.connect(_on_laser_shot)
	#enemy_shooting.laser_shot.connect(_on_laser_shot)
	#enemy.laser_shot.connect(_on_enemy_laser_shot)
	# connect player killed signal
	player.killed.connect(_on_player_killed)
	spawner()

func spawner():
	var x:int = 1;
	while x>0:
		for n in turn1:
			var enemy = choose_random_enemy()
			spawn_enemy(enemy.instantiate())
			await get_tree().create_timer(wait_enemy).timeout
		spawn_enemy(enemy_boss[0].instantiate())
		x-=2

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

func _on_laser_shot(type, laser_scene, location, start_rotation, y_movement, x_movement):
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
	# sound
	#laser_sound.play()

#func _on_enemy_laser_shot(laser_scene, location, start_rotation, y_movement, x_movement):
		# create laser
	#var laser = laser_scene.instantiate()
		# set laser position
	#laser.global_position = location
	#laser.start_rotation = start_rotation
	#laser.x_movement = x_movement
	#laser.y_movement = y_movement
		# add as child of laser_container
	#laser_container.add_child(laser)
		# sound
		#laser_sound.play()

func choose_random_enemy() -> PackedScene:
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
	if enemy.type ==3 or enemy.type ==4:
		enemy.laser_shot.connect(_on_laser_shot)
		if enemy.type == 4:
			pass
			enemy.boss_dead.connect(_on_boss_killed)

func _on_boss_killed():
	print("Boss Desktroyed")
	spawner()

func _on_enemy_killed(points):
	score += points
	hit_sound.play()
	if score > high_score:
		high_score = score
	if score == 500 or score == 1000:
		player.level_up()

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
