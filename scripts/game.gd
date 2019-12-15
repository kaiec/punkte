extends Node2D

onready var dot = preload('res://scenes/dot.tscn')
onready var pipe = preload('res://scenes/pipe.tscn')

var cell_size = Vector2(100,100)
var grid_size = Vector2(5,5)
var grid_pos = Vector2(10,10)

var colors = {
	WHITE = Color(1.0, 1.0, 1.0),
	YELLOW = Color(1.0, .757, .027),
	GREEN = Color(.282, .757, .255),
	BLUE = Color(.098, .463, .824),
	PINK = Color(.914, .118, .388)
}

var grid = {}

func _ready():
	print('Game started')
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid[Vector2(x,y)] = null
	set_cell(Vector2(0,0), dot, colors.GREEN)
	set_cell(Vector2(4,4), dot,  colors.GREEN)
	set_cell(Vector2(0,4), dot,  colors.BLUE)
	set_cell(Vector2(3,1), dot,  colors.BLUE)
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if grid[Vector2(x,y)] == null:
				set_cell(Vector2(x,y), pipe, colors.YELLOW)
	
			
func _draw():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var p = Vector2(x,y)
			draw_rect(Rect2(grid_pos + p * cell_size, cell_size), colors.WHITE, false) 

func set_cell(pos,cell,color):
	var newcell = cell.instance()
	newcell.set_size(cell_size)
	newcell.set_position(grid_pos + pos * cell_size)
	newcell.color = color
	add_child(newcell)
	grid[pos] = newcell
	return newcell