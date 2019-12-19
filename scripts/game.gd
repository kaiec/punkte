extends Node2D



func _ready():
	pass	


var pos = Vector2(0,0)
			
func _draw():
		draw_circle(get_local_mouse_position(), 15, Color(1,1,1))

	
func _physics_process(delta):
	update()
