extends "res://scripts/cell.gd"
class_name Dot

func _ready():
	dot = true
	empty = false # a dot is by default not empty

func _draw():
	if highlight:
		draw_circle(size / 2, size.x * 0.42, Color(1,1,1))
	draw_circle(size / 2, size.x * 0.4, color)
	if upstream:
		draw_connection(upstream)
	if downstream:
		draw_connection(downstream)
		
func set_empty(new_empty):
	return