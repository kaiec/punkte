extends Node2D

onready var dot = preload('res://scenes/dot.tscn')
onready var pipe = preload('res://scenes/pipe.tscn')

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
var pipe_start = null
var pipe_last = null
var pipe_current = null

func _ready():
	print_debug('Game started')
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid[Vector2(x,y)] = null
	set_dots(Vector2(0,0), Vector2(4,4), colors.GREEN)
	set_dots(Vector2(0,4), Vector2(3,1),  colors.BLUE)
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if grid[Vector2(x,y)] == null:
				set_cell(Vector2(x,y), pipe, colors.YELLOW)
	grid_rect.position = grid_pos
	grid_rect.size = grid_size * cell_size
			
func _draw():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var p = Vector2(x,y)
			draw_rect(Rect2(grid_pos + p * cell_size, cell_size), colors.WHITE, false) 

func game_pos(pos):
	return ((pos - grid_pos) / cell_size).floor()
	
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mp = get_global_mouse_position()
		if grid_rect.has_point(mp):
			var gp = game_pos(mp)
			if grid[gp] != pipe_current:
				pipe_current = grid[gp]
				if not pipe_start:
					grid[gp].try_start_pipe()
				else:
					grid[gp].try_connect_to_pipe()
	else:
		if pipe_start:
			end_pipe()			

func end_pipe():
	if pipe_last:
		print_debug("end %s" % pipe_last.game_position)
	else:
		print('end with no last pos')
	pipe_start = null
	pipe_last = null
	
func start_pipe():
	pipe_start = find_start(pipe_current)
	pipe_last = pipe_current
	print_debug("start %s" % pipe_current.game_position)

func find_start(cell):
	if not cell.upstream:
		return cell
	return find_start(cell.upstream)


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
			print_debug('click on a cell to dump it')
			dumpcell = true
