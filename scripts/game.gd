extends Node2D



func _ready():
	Input.set_use_accumulated_input(false)


var pos = Vector2(0,0)
var time := 0.0
			
func _draw():
		draw_circle(pos, 15, Color(1,1,1))

	
func _physics_process(delta):
	time += delta
	if time > 0.1:
		update()
		time = 0
	
func _input(event):
	if event is InputEventScreenDrag:
		pos = event.position
