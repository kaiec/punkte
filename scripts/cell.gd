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
var line = null setget set_line

func _ready():
	pass

func set_empty(value):
	empty = value

func set_upstream(value):
	upstream = value

func set_downstream(value):
	downstream = value

func set_color(value):
	color = value
	
func set_line(value):
	line = value

func set_size(new_size):
	size = new_size
	get_node("CollisionShape2D").get_shape().set_extents(new_size/2)
	get_node("CollisionShape2D").set_position(new_size/2)
	update()

func empty_cell():
	if self.upstream:
		self.upstream.downstream = null
		self.upstream.update()
	if self.downstream:
		self.downstream.upstream = null
		self.downstream.update()
	self.upstream = null
	self.downstream = null
	if not dot:
		self.empty = true
		self.color = Color(1,1,1)
		self.line = null
	self.update()

func try_start_pipe():
	if not line: # can only start on an existing line
		return
	else:
		line.start(self)


		
func try_connect_to_pipe():
	if game.active_line:
		game.active_line.add(self)
		
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

