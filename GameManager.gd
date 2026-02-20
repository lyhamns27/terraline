extends Node

@export var card_label : Label


class Player:
	var id : int
	var turns_played : int = 0
	var current_card = null
	
	func _init(player_id):
		id = player_id


const CARD_INTERVAL = 5

enum CardType {
	PLUS_2,
	PLUS_3,
	TETROMINO_J,
	TETROMINO_L
}


var players = {}
var current_player_id = 1


func _ready():
	players[1] = Player.new(1)
	players[2] = Player.new(2)
	
	update_ui()


func update_ui():
	if card_label == null:
		print("CardLabel not assigned in Inspector!")
		return
	
	var player = players[current_player_id]
	
	if player.current_card == null:
		card_label.text = "Player " + str(player.id) + " - No Card"
	else:
		card_label.text = "Player " + str(player.id) + " - Card: " + CardType.keys()[player.current_card]


func end_turn():
	var player = players[current_player_id]
	player.turns_played += 1
	
	print("Player", player.id, "played turn", player.turns_played)
	
	if player.turns_played % CARD_INTERVAL == 0:
		draw_card(player)
	
	switch_player()


func switch_player():
	current_player_id = 2 if current_player_id == 1 else 1
	update_ui()
	print("Now it's player", current_player_id)


func draw_card(player):
	if player.current_card != null:
		print("Player", player.id, "already has a card")
		return
	
	var card = CardType.values().pick_random()
	player.current_card = card
	
	print("Player", player.id, "drew card:", CardType.keys()[card])

