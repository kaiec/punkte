extends KinematicBody2D

export var size = Vector2(64,64) setget set_size
export var color = Color(1,1,1) setget set_color

var game = null
var game_position = null
var highlight = false
var dot = false
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
	connect_signal("mouse_entered", "_on_cell_mouse_entered")
	connect_signal("mouse_exited", "_on_cell_mouse_exited")
	connect_signal("input_event", "_on_cell_input_event")


func set_empty(new_empty):
	empty = new_empty

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

func _on_cell_mouse_entered():
	highlight = true
	if game.pipe_start:
		if not is_neighbour(game.pipe_last):
			game.pipe_start = null
			game.pipe_last = null
			print("end %s" % game_position)
			return
		if dot and color != game.pipe_last.color:
			game.pipe_start = null
			game.pipe_last = null
			print("end %s" % game_position)
			return
		if not empty:
			empty_downstream()
		empty = false
		self.upstream = game.pipe_last
		game.pipe_last.downstream = self
		game.pipe_last = self
		self.color = game.pipe_start.color
		if dot:
			game.pipe_start = null
			game.pipe_last = null
			print("end %s" % game_position)
			return
	update()


func empty_downstream():
	self.empty = true
	if self.upstream:
		self.upstream.downstream = null
		self.upstream = null
	if self.downstream:
		self.downstream.empty_downstream()
		self.downstream = null

func empty_upstream():
	self.empty = true
	if self.upstream:
		self.upstream.empty_upstream()
		self.upstream = null
	if self.downstream:
		self.downstream.upstream = null
		self.downstream = null	

func _on_cell_mouse_exited():
	highlight = false
	update()

func _on_cell_input_event(viewport, event, whatisthis):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if empty:
				return
			if downstream:
				downstream.empty_downstream()
			if dot and upstream:
				upstream.empty_upstream()
			game.pipe_start = self
			game.pipe_last = self
			print("start %s" % game_position)
		else:
			if game.pipe_start:
				game.pipe_start = null
				game.pipe_last = null
				print("end %s" % game_position)
				

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
