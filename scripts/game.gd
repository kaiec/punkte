extends Node2D

var icon = preload("res://assets/icon.png")

func _ready():
	Input.set_use_accumulated_input(false)


var pos = Vector2(0,0)
			
func _draw():
		draw_texture(icon, get_local_mouse_position()-Vector2(32,32))

	
func _process(delta):
	update()
