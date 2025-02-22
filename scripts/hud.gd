extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " +str(value)
@onready var shield = $Shield:
	set(value):
		#$Shield.add_theme_color_override("font_color", color)
		shield.text = "Shield: " + value
		#shield.add_theme_color_override("font_color", Color(0.918, 0.514, 0.682))
	

func color(color:Color):
	$Shield.add_theme_color_override("font_color", color)
