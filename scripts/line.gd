extends Node

class_name Line

var game = null
var dots = []
var pipes = []
var start_dot = null
var end_dot = null

func get_last():
	if len(pipes)==0:
		if start_dot:
			return start_dot
		else:
			return null
	else:
		return pipes[-1]
		

func clear(from = null):
	var linepos = 0
	if from and not from.dot:
		linepos = pipes.find(from)
	for i in range(len(pipes) - 1, linepos - 1, -1): # backwards to allow safe deletion
		pipes[i].empty_cell()
		pipes.remove(i)

func walk_grid(p0, p1):
	var dx = p1.x - p0.x
	var dy = p1.y - p0.y
	var nx = abs(dx)
	var ny = abs(dy)
	var sign_x = -1
	if dx > 0:
		sign_x = 1
	elif dx == 0:
		sign_x = 0
	var sign_y = -1
	if dy > 0:
		sign_y = 1
	elif dy == 0:
		sign_y = 0
	# print('points: ', p0, p1)
	# print('n:', nx, ny)
	# print('d:', dx, dy)
	# print('sign:', sign_x, sign_y)
	var p = Vector2(p0.x, p0.y)
	var points = [];
	var ix = 0
	var iy = 0
	var horizontal = true
	while (nx - ix) + (ny - iy) > 1:
		if nx == 0:
			horizontal = true
		elif ny == 0:
			horizontal = false
		else:
			horizontal = (0.5+ix) / nx < (0.5+iy) / ny
		if horizontal:
			# next step is horizontal
			p.x += sign_x
			ix += 1
		else:
			# next step is vertical
			p.y += sign_y
			iy += 1
		points.append(Vector2(p.x, p.y))
	return points



func add(cell):
	var last = get_last()
	if not last.is_neighbour(cell):
		# print_debug('not a neighbour, can not add to line')
		var cell_positions = walk_grid(last.game_position, cell.game_position)
		# print(cell_positions)
		for cell_pos in cell_positions:
			add(game.grid[cell_pos])
		last = get_last()
		if not last.is_neighbour(cell):
			return
	if cell.dot and cell.line != self: # we hit another dot
		return
	if cell.line and cell != end_dot: # clear other line from this cell
		cell.line.clear(cell)
		last = get_last() # if we hit ourselves, we need a new last
	if cell.empty:
		cell.line=self
		cell.upstream = last
		last.downstream = cell
		cell.empty = false
		cell.color = last.color
		pipes.append(cell)
		cell.update()
		cell.upstream.update()
	elif cell == end_dot:
		cell.upstream = last
		last.downstream = cell
		cell.update()
		cell.upstream.update()
		end()
		
func end():
	# print_debug("end %s" % get_last().game_position)
	game.active_line = null
	
func start(cell):
	game.active_line = self
	# print_debug("start %s" % cell.game_position)
	if cell.dot:
		clear()
		start_dot = cell
		end_dot = cell.other
	elif cell.downstream:
		clear(cell.downstream)
