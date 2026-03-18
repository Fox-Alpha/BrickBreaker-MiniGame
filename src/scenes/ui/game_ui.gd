extends CanvasLayer

@export var ball : RigidBody2D

@onready var label_score: Label = $VBoxContainer/PanelContainer/Panel/HBoxContainer/LabelScore
@onready var label_lives: Label = $VBoxContainer/PanelContainer/Panel/HBoxContainer/LabelLives
@onready var lives_icon_1: TextureRect = $VBoxContainer/PanelContainer/Panel/HBoxContainer/TextureRect
@onready var lives_icon_2: TextureRect = $VBoxContainer/PanelContainer/Panel/HBoxContainer/TextureRect2
@onready var lives_icon_3: TextureRect = $VBoxContainer/PanelContainer/Panel/HBoxContainer/TextureRect3
@onready var reset_button: Button = $VBoxContainer/PanelContainer/Panel/HBoxContainer/ButtonResetGame
@onready var color_rect: ColorRect = $VBoxContainer/ColorRect
@onready var game_over_overlay: ColorRect = $GameOverOverlay
@onready var label_final_score: Label = $GameOverOverlay/CenterContainer/VBoxContainer/LabelFinalScore
@onready var button_restart: Button = $GameOverOverlay/CenterContainer/VBoxContainer/ButtonRestart
@onready var button_quit: Button = $GameOverOverlay/CenterContainer/VBoxContainer/ButtonQuit

var _gamescore : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#color_rect.gui_input.connect(_on_color_rect_gui_input)
	if get_tree().current_scene.has_signal("Player_Score"):
		get_tree().current_scene.Player_Score.connect(_on_player_score)
	if OS.has_feature("editor"):
		reset_button.show()
		reset_button.pressed.connect(func():
			if(get_tree().current_scene.has_signal("Reset_Game")):
				get_tree().current_scene.Reset_Game.emit()
			)
	else:
		reset_button.hide()
	
	# Connect to lives changed signal
	Game.GL_LIVES_CHANGED.connect(_on_lives_changed)
	Game.GL_GAMESTATE_CHANGE.connect(_on_game_state_changed)
	_update_lives_display(Game.lives)
	
	# Connect game over buttons
	if button_restart:
		button_restart.pressed.connect(_on_restart_pressed)
	if button_quit:
		button_quit.pressed.connect(_on_quit_pressed)
	
	if get_tree().current_scene.has_signal("GS_GAME_PAUSED"):
		get_tree().current_scene.GS_GAME_PAUSED.connect(_on_player_score)
		# RECT Einblenden
		pass
	if get_tree().current_scene.has_signal("GS_GAME_UNPAUSED"):
		get_tree().current_scene.GS_GAME_UNPAUSED.connect(_on_game_unpaused)
		# RECT ausblenden
		#
		pass
	label_score.text = "0.000.000"
	pass # Replace with function body.


func _on_player_score(score : int) -> void :
	_gamescore += score
	label_score.text = "{0}".format({0:"%010d" % _gamescore})
	#"Hi, {0} v{version}".format({0:"Godette", "version":"%0.2f" % 3.114})
	#print("User {} is {}.".format([42, "Godot"], "{}"))
	pass


func _on_game_paused() -> void:
	color_rect.show()
	pass


func _on_game_unpaused() -> void:
	color_rect.hide()
	pass


func _on_label_pause_gui_input(event: InputEvent) -> void:
	# Unpause / Start Game
	pass # Replace with function body.


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event.is_action_type():
		if get_tree().paused:
			get_tree().paused = false
			get_tree().current_scene.GS_GAME_UNPAUSED.emit()
	pass # Replace with function body.


## Update lives display when lives change
func _on_lives_changed(lives_remaining: int) -> void:
	_update_lives_display(lives_remaining)


## Update visual representation of lives
func _update_lives_display(lives: int) -> void:
	# Update label
	if label_lives:
		label_lives.text = "Lives: %d" % lives
	
	# Update icons (3 paddle icons for 3 lives)
	if lives_icon_1:
		lives_icon_1.visible = lives >= 1
	if lives_icon_2:
		lives_icon_2.visible = lives >= 2
	if lives_icon_3:
		lives_icon_3.visible = lives >= 3


## Handle game state changes
func _on_game_state_changed(new_state: Game.GameStates) -> void:
	if new_state == Game.GameStates.GAMEOVER:
		_show_game_over()


## Show game over screen
func _show_game_over() -> void:
	if game_over_overlay:
		game_over_overlay.visible = true
	if label_final_score:
		label_final_score.text = "Final Score: %s" % label_score.text
	print("UI: Game Over screen displayed")


## Handle restart button press
func _on_restart_pressed() -> void:
	print("UI: Restart button pressed")
	# TODO: Implement game restart logic
	game_over_overlay.visible = false
	get_tree().reload_current_scene()


## Handle quit to menu button press
func _on_quit_pressed() -> void:
	print("UI: Quit to menu pressed")
	# TODO: Implement menu transition
	get_tree().quit()


