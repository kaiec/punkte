extends "res://scripts/cell.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _draw():
	if highlight:
		draw_circle(size / 2, size.x * 0.42, Color(1,1,1))
	draw_circle(size / 2, size.x * 0.4, color)