extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var size = Vector2(64,64)
var highlight = false


func connect_signal(sig, fun):
	var err = connect(sig, self, fun)
	if (err):
		print("Error connecting {} to {} in {}".format([sig, fun, self]))

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pickable(true)
	connect_signal("mouse_entered", "_on_cell_mouse_entered")
	connect_signal("mouse_exited", "_on_cell_mouse_exited")
	connect_signal("input_event", "_on_cell_input_event")

export var color = Color(1,1,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_color(new_color):
	color = new_color
	update()

func set_size(new_size):
	size = new_size
	get_node("CollisionShape2D").get_shape().set_extents(new_size/2)
	get_node("CollisionShape2D").set_position(new_size/2)
	update()

func _on_cell_mouse_entered():
	highlight = true
	update()


func _on_cell_mouse_exited():
	highlight = false
	update()

func _on_cell_input_event(viewport, event, whatisthis):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("click")
		else:
			print("released")