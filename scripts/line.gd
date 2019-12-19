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

func add(cell):
	var last = get_last()
	if not last.is_neighbour(cell):
		# print_debug('not a neighbour, can not add to line')
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
	elif cell == end_dot:
		cell.upstream = last
		last.downstream = cell
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
