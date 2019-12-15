extends Node2D

onready var dot = preload('res://dot.tscn')

var cell_size = Vector2(64,64)
var grid_size = Vector2(5,5)
var grid_pos = Vector2(10,10)

var colors = {
	WHITE = Color(1.0, 1.0, 1.0),
	YELLOW = Color(1.0, .757, .027),
	GREEN = Color(.282, .757, .255),
	BLUE = Color(.098, .463, .824),
	PINK = Color(.914, .118, .388)
}

var grid = []

func _ready():
	print('Game started')
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(0)

	var green = dot.instance()
	green.position = Vector2(10,10)
	add_child(green)
			
func _draw():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var p = Vector2(x,y)
			draw_rect(Rect2(grid_pos + p * cell_size, cell_size), colors.WHITE, false) 

