extends KinematicBody2D

export var size = Vector2(64,64) setget set_size
export var color = Color(1,1,1) setget set_color

var game = null
var game_position = null
var highlight = false
var dot = false
var other = null
var empty = true setget set_empty
var upstream = null setget set_upstream
var downstream = null setget set_downstream


func connect_signal(sig, fun):
	var err = connect(sig, self, fun)
	if (err):
		print("Error connecting %s to %s in %s" % [sig, fun, self])

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pickable(true)
#	connect_signal("mouse_entered", "_on_cell_mouse_entered")
#	connect_signal("mouse_exited", "_on_cell_mouse_exited")
#	connect_signal("input_event", "_on_cell_input_event")


func set_empty(new_empty):
	empty = new_empty
	update()

func set_upstream(new_upstream):
	upstream = new_upstream
	update()

func set_downstream(new_downstream):
	downstream = new_downstream
	update()

func set_color(new_color):
	color = new_color
	update()

func set_size(new_size):
	size = new_size
	get_node("CollisionShape2D").get_shape().set_extents(new_size/2)
	get_node("CollisionShape2D").set_position(new_size/2)
	update()

func empty_cell():
	if self.upstream:
		self.upstream.downstream = null
	if self.downstream:
		self.downstream.upstream = null
	self.upstream = null
	self.downstream = null
	if not dot:
		self.empty = true
		self.color = Color(1,1,1)

func empty_downstream(origin=null):
	if origin == self:
		return;
	var o = origin
	if not o:
		o = self
	if self.downstream:
		self.downstream.empty_downstream(o)
	if origin != null:
		empty_cell()

func empty_upstream(origin=null):
	if origin == self:
		return;
	var o = origin
	if not o:
		o = self
	if self.upstream:
		self.upstream.empty_upstream(o)
	if origin != null:
		empty_cell()




func try_start_pipe():
	game.pipe_current = self
	if empty:
		return
	if downstream:
		empty_downstream()
	if dot:
		empty_upstream()
		other.empty_upstream()
		other.empty_downstream()
	game.start_pipe()


func try_connect_to_pipe():
	if not is_neighbour(game.pipe_last): # we accidently skipped a cell
		return game.end_pipe()
	if dot and color != game.pipe_last.color: # we hit a foreign dot
		return game.end_pipe()
	if not empty and color != game.pipe_start.color: # we hit other pipe
		print_debug('hit other pipe')
		empty_downstream()
		empty_cell()
		self.upstream = game.pipe_last
		game.pipe_last.downstream = self
	elif not empty: # we hit ourself or draw backwards or reached a dot
		if not dot:  # we continue from here and do not reconnect upstream
			print_debug('hit ourselves, restart from here')
			empty_downstream()
		else: 
			# if it is our own starting point, do not connect and end
			if game.find_start(game.pipe_last) == self:
				print_debug('reached starting dot')
				if downstream and game.pipe_last == downstream: # we came backwards
					empty_downstream()
				return game.end_pipe()
		    # everything ok, we properly connect it to the pipe
			print_debug('reached other dot')
			self.upstream = game.pipe_last
			game.pipe_last.downstream = self
	else: # we have an empty cell
		game.pipe_last.downstream = self
		self.upstream = game.pipe_last
	empty = false
	game.pipe_last = self
	self.color = game.pipe_start.color
	if dot:
		game.end_pipe()



func _on_cell_mouse_entered():
	highlight = true
	game.pipe_current = self
	if game.pipe_start:
		try_connect_to_pipe()
	update()


func _on_cell_mouse_exited():
	highlight = false
	update()

func _on_cell_input_event(viewport, event, whatisthis):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if game.dumpcell:
				dump_cell()
				game.dumpcell = false
				return
			try_start_pipe()
		else:
			game.pipe_current = self
			if game.pipe_start:
				game.end_pipe()

func dump_cell():
	print("game pos %s" % game_position)
	print("empty %s" % empty)
	if upstream:
		print("upstream %s" % upstream.game_position)
	else:
		print("no upstream")
	if downstream:
		print("downstream %s" % downstream.game_position)
	else:
		print("no downstream")
	print("dot %s" % dot)
	print("color %s" % color)

func is_neighbour(cell):
	return abs(game_position.x - cell.game_position.x) == 1 and \
				abs(game_position.y - cell.game_position.y) == 0 or \
		  		abs(game_position.x - cell.game_position.x) == 0 and \
				abs(game_position.y - cell.game_position.y) == 1


func draw_connection(cell):
	# a rectangle with same thickness as internal dot that connects seamlessly to the dot.
	# from left:
	if cell.position.x < position.x:
		draw_rect(Rect2(Vector2(0, size.y / 2 - 0.22 * size.y), Vector2(size.x/2, 2*(size.y * 0.22))), color)
	elif cell.position.x > position.x:
		draw_rect(Rect2(Vector2(size.x / 2, size.y / 2 - 0.22 * size.y), Vector2(size.x/2, 2*(size.y * 0.22))), color)
	elif cell.position.y < position.y:
		draw_rect(Rect2(Vector2(size.x / 2 - 0.22 * size.x, 0), Vector2(2*(size.x * 0.22), size.y/2)), color)
	elif cell.position.y > position.y:
		draw_rect(Rect2(Vector2(size.x / 2 - 0.22 * size.x, size.y / 2), Vector2(2*(size.x * 0.22), size.y/2)), color)

