extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " +str(value)
@onready var shield = $Shield:
	set(value):
		shield.text = "Shield: " + value
