extends Control

@onready var start_options = %StartOptions
#@onready var container_multiplayer_options = %ContainerMultiplayerOptions
#@onready var multiplayer_host = %MultiplayerHost
#@onready var multiplayer_client = %MultiplayerClient

@export_subgroup("SubPanels", "MainMenu")
@export var MainMenuSubViewPanels : Dictionary[String, NodePath] = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	# main_view
	Game.GL_CHANGE_GAMESTATE.emit(Game.GameStates.GAMEMAINMENU)


func _on_button_start_hot_seat_pressed():
	#var err = get_tree().change_scene_to_file(Game.GameMainScene.resource_path)
	#if err != OK:
		#print("Fehler bim laden der Szene: %s" % error_string(err))
		#Game.GL_CHANGE_GAMESTATE.emit(Game.GameStates.GAMELOADINGERROR)
		#return
	#ToDo: Switch to Local Game Options before starting

	pass


func _exit_tree() -> void:
	print("MeinMenu Unloading => _exit_tree()")
	#Game.GL_CHANGE_GAMESTATE.emit(Game.GameStates.GAMEISLOADING)


func _on_button_multiplayer_options_pressed():
	#ToDo: Switch to Multiplayer Game Options before starting
	pass


func _on_button_start_pressed():
	print("MainMenu: Start button pressed - starting game")
	# Change state to LOADING
	Game.GameState = Game.GameStates.LOADING

	# Switch to game scene
	var err = get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	if err != OK:
		print("ERROR: Failed to load game scene - %s" % error_string(err))
		Game.GameState = Game.GameStates.ERROR



func _on_button_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
