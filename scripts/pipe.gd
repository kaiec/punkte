extends "res://scripts/cell.gd"


func _ready():
	pass



func _draw():
	if empty:
		return
	if highlight:
		draw_circle(size / 2, size.x * 0.22, Color(1,1,1))
	draw_circle(size / 2, size.x * 0.2, color)
	# draw connections
	if upstream:
		draw_connection(upstream)
	if downstream:
		draw_connection(downstream)

