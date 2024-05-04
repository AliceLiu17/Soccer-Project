extends Control

@export var server_ip = "127.0.0.1"
@export var server_port = 8910
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	if "--server" in OS.get_cmdline_args():
		hostGame()
		
func _process(delta):
	pass

# the gets called on the server and clients
func peer_connected(id):
	print("Player Connected " + str(id))
	
func peer_disconnected(id):
	print("Player Disconnected " + str(id))

func connected_to_server():
	print("Connected to server")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
func connection_failed():
	print("Connection failed!")

# allow users to change their name
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : name,
			"id" : id, 
			"score" : 0
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

func hostGame():
	peer = ENetMultiplayerPeer.new()
	# create a server
	var error = peer.create_server(server_port, 2) # 2 player
	if error != OK:
		print("Cannot Host : " + str(error))
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	# SET multiplayer peer
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for Players....")
	
	
	
func _on_alice_button_button_down():
	hostGame()
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())

func _on_emily_button_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(server_ip, server_port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

@rpc("any_peer", "call_local")
func startGame():
	var scene = load("res://main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_start_game_button_down():
	startGame.rpc()

