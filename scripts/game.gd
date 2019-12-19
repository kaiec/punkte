extends Node2D

const Dot = preload('res://scenes/dot.tscn')
const Pipe = preload('res://scenes/pipe.tscn')
const Line = preload('res://scripts/line.gd')

var cell_size = Vector2(36,36)
var grid_size = Vector2(7,7)
var grid_pos = Vector2(10,100)
var dumpcell = false

var colors = {
	WHITE = Color(1.0, 1.0, 1.0),
	YELLOW = Color(1.0, .757, .027),
	GREEN = Color(.282, .757, .255),
	BLUE = Color(.098, .463, .824),
	PINK = Color(.914, .118, .388)
}

var grid = {}
var grid_rect = Rect2(Vector2(0,0), Vector2(0,0))
var lines = []
var active_line = null
var active_cell = null

func _ready():
	print_debug('Game started')
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid[Vector2(x,y)] = null
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if grid[Vector2(x,y)] == null:
				set_cell(Vector2(x,y), Pipe, colors.YELLOW)
	grid_rect.position = grid_pos
	grid_rect.size = grid_size * cell_size
	
	var touchEvent = InputEventScreenTouch.new()
	var dragEvent = InputEventScreenDrag.new()
	InputMap.add_action('touch')
	InputMap.action_add_event('touch', touchEvent) 
	InputMap.add_action('drag')
	InputMap.action_add_event('drag', dragEvent) 
	

			
func _draw():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var p = Vector2(x,y)
			draw_rect(Rect2(grid_pos + p * cell_size, cell_size), colors.WHITE, false) 
	if active_cell:
		draw_circle(active_cell.position + 0.5 * cell_size, 0.5 * cell_size.x, colors.WHITE)

func game_pos(pos):
	var gp_float = ((pos - grid_pos) / cell_size)
	var gp = gp_float.floor()
	return gp
	
	
func _input(event):
	if event is InputEventScreenDrag:
		var mp = event.position
		if grid_rect.has_point(mp):
			var gp = game_pos(mp)
			if gp != null and grid[gp] != active_cell:
				if not active_cell and not active_line:
					active_cell = grid[gp]
					update()
				else:
					active_cell = grid[gp]
					update()
	elif event is InputEventScreenTouch and not event.pressed:
		if active_line:
			active_line.end()
		active_cell = null	



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
	