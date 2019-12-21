extends Node2D



func _ready():
	Input.set_use_accumulated_input(false)


var pos = Vector2(0,0)
			
func _draw():
		draw_circle(pos, 15, Color(1,1,1))

	
func _input(event):
	if event is InputEventScreenDrag:
		position = event.position
		update()
