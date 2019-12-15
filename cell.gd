extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var size = Vector2(64,64)
var highlight = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pickable(true)
	connect("mouse_entered", self, "_on_cell_mouse_entered")
	connect("mouse_exited", self, "_on_cell_mouse_exited")

export var color = Color(.282, .757, .255)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
