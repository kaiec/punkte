extends Node2D

onready var dot = preload('res://scenes/dot.tscn')
onready var pipe = preload('res://scenes/pipe.tscn')

var cell_size = Vector2(100,100)
var grid_size = Vector2(5,5)
var grid_pos = Vector2(10,10)
var dumpcell = false

var colors = {
	WHITE = Color(1.0, 1.0, 1.0),
	YELLOW = Color(1.0, .757, .027),
	GREEN = Color(.282, .757, .255),
	BLUE = Color(.098, .463, .824),
	PINK = Color(.914, .118, .388)
}

var grid = {}
var pipe_start = null
var pipe_last = null
var pipe_current = null

func _ready():
	print('Game started')
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid[Vector2(x,y)] = null
	set_dots(Vector2(0,0), Vector2(4,4), colors.GREEN)
	set_dots(Vector2(0,4), Vector2(3,1),  colors.BLUE)
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if grid[Vector2(x,y)] == null:
				set_cell(Vector2(x,y), pipe, colors.YELLOW)

			
func _draw():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var p = Vector2(x,y)
			draw_rect(Rect2(grid_pos + p * cell_size, cell_size), colors.WHITE, false) 

func set_dots(pos1, pos2, color):
	var dot1 = set_cell(pos1, dot, color)
	var dot2 = set_cell(pos2, dot, color)
	dot1.other = dot2
	dot2.other = dot1

func set_cell(pos,cell,color):
	var newcell = cell.instance()
	newcell.set_size(cell_size)
	newcell.set_position(grid_pos + pos * cell_size)
	newcell.game_position = pos
	newcell.game = self
	newcell.color = color
	add_child(newcell)
	grid[pos] = newcell
	return newcell
	
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_R:
			print('refresh')
			for cell in grid.values():
				cell.update()
		if event.pressed and event.scancode == KEY_D:
			print('click on a cell to dump it')
			dumpcell = true
