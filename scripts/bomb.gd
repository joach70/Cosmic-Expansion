extends Area2D

@onready var hit_sound = $HitSound
var speed = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y += speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area is Laser: # If laser hit bomb
		if area.type =="player": # Only laser player laser destry enemy bomb
			area.queue_free()
			destroyed()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.die()
		destroyed()

func destroyed():
	hit_sound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.visible = false
	await hit_sound.finished
	queue_free()
