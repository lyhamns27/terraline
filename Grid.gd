extends Node2D

const GRID_WIDTH = 10
const GRID_HEIGHT = 10
const CELL_SIZE = 64

var grid = []
var game_manager


func _ready():
	game_manager = get_parent().get_node("GameManager")
	create_grid()
	queue_redraw()


func create_grid():
	grid.clear()
	for y in range(GRID_HEIGHT):
		var row = []
		for x in range(GRID_WIDTH):
			row.append(0)
		grid.append(row)


func _draw():
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			var rect = Rect2(
				x * CELL_SIZE,
				y * CELL_SIZE,
				CELL_SIZE,
				CELL_SIZE
			)
			
			# Dessin des pions
			if grid[y][x] == 1:
				draw_rect(rect, Color.RED)
			elif grid[y][x] == 2:
				draw_rect(rect, Color.BLUE)
			
			# Dessin grille
			draw_rect(rect, Color.WHITE, false, 2)


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_local_mouse_position()
		var x = int(mouse_pos.x / CELL_SIZE)
		var y = int(mouse_pos.y / CELL_SIZE)
		
		if is_valid_position(x, y):
			if grid[y][x] == 0:
				place_piece(x, y)


func is_valid_position(x, y):
	return x >= 0 and x < GRID_WIDTH and y >= 0 and y < GRID_HEIGHT


func place_piece(x, y):
	var player = game_manager.players[game_manager.current_player_id]
	
	if player.current_card == null:
		grid[y][x] = player.id
	else:
		apply_card(player, x, y)
		player.current_card = null
	
	queue_redraw()
	game_manager.end_turn()


func apply_card(player, x, y):
	match player.current_card:
		game_manager.CardType.PLUS_2:
			apply_plus(player, x, y, 2)
		
		game_manager.CardType.PLUS_3:
			apply_plus(player, x, y, 3)
		
		game_manager.CardType.TETROMINO_J:
			apply_tetromino(player, x, y, "J")
		
		game_manager.CardType.TETROMINO_L:
			apply_tetromino(player, x, y, "L")


func apply_plus(player, x, y, amount):
	for i in range(amount):
		var new_x = x + i
		if is_valid_position(new_x, y) and grid[y][new_x] == 0:
			grid[y][new_x] = player.id


func apply_tetromino(player, x, y, type):
	var shape = []
	
	if type == "J":
		shape = [
			Vector2(0,0),
			Vector2(0,1),
			Vector2(0,2),
			Vector2(-1,2)
		]
	elif type == "L":
		shape = [
			Vector2(0,0),
			Vector2(0,1),
			Vector2(0,2),
			Vector2(1,2)
		]
	
	for offset in shape:
		var new_x = x + int(offset.x)
		var new_y = y + int(offset.y)
		
		if is_valid_position(new_x, new_y) and grid[new_y][new_x] == 0:
			grid[new_y][new_x] = player.id
