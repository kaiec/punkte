extends "res://scripts/cell.gd"



func _ready():
	empty = false # a dot is by default not empty

func _draw():
	if highlight:
		draw_circle(size / 2, size.x * 0.42, Color(1,1,1))
	draw_circle(size / 2, size.x * 0.4, color)