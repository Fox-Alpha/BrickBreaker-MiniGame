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
@onready var level_complete_overlay: ColorRect = $LevelCompleteOverlay
@onready var label_level_score: Label = $LevelCompleteOverlay/CenterContainer/VBoxContainer/LabelScore
@onready var button_play_again: Button = $LevelCompleteOverlay/CenterContainer/VBoxContainer/ButtonPlayAgain
@onready var button_main_menu: Button = $LevelCompleteOverlay/CenterContainer/VBoxContainer/ButtonMainMenu
@onready var pause_overlay: ColorRect = $PauseOverlay
@onready var button_resume: Button = $PauseOverlay/CenterContainer/VBoxContainer/ButtonResume
@onready var button_restart_pause: Button = $PauseOverlay/CenterContainer/VBoxContainer/ButtonRestart2
@onready var button_menu_pause: Button = $PauseOverlay/CenterContainer/VBoxContainer/ButtonMenu

var _gamescore : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# game_ui
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
	Game.GL_SCORE_CHANGED.connect(_on_score_changed)
	_update_lives_display(Game.lives)

	# Connect game over buttons
	if button_restart:
		button_restart.pressed.connect(_on_restart_pressed)
	if button_quit:
		button_quit.pressed.connect(_on_quit_pressed)

	# Connect level complete buttons
	if button_play_again:
		button_play_again.pressed.connect(_on_play_again_pressed)
	if button_main_menu:
		button_main_menu.pressed.connect(_on_main_menu_pressed)

	# Connect pause buttons
	if button_resume:
		button_resume.pressed.connect(_on_resume_pressed)
	if button_restart_pause:
		button_restart_pause.pressed.connect(_on_restart_pressed)
	if button_menu_pause:
		button_menu_pause.pressed.connect(_on_main_menu_pressed)

	# Connect level complete signal
	Game.GL_LEVEL_COMPLETE.connect(_on_level_complete)

	if get_tree().current_scene.has_signal("GS_GAME_PAUSED"):
		get_tree().current_scene.GS_GAME_PAUSED.connect(_on_game_paused)
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


## Handle score change from game manager
func _on_score_changed(new_score: int) -> void:
	_gamescore = new_score
	label_score.text = "%010d" % _gamescore


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
	match new_state:
		Game.GameStates.GAMEOVER:
			_show_game_over()
		Game.GameStates.PAUSED:
			_show_pause()
		Game.GameStates.RUNNING:
			_hide_pause()


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
	if game_over_overlay:
		game_over_overlay.visible = false
	if pause_overlay:
		pause_overlay.visible = false
	Game.reset_game()


## Handle quit to menu button press
func _on_quit_pressed() -> void:
	print("UI: Quit to menu pressed")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


## Handle level complete signal
func _on_level_complete() -> void:
	_show_level_complete()


## Show level complete screen
func _show_level_complete() -> void:
	if level_complete_overlay:
		level_complete_overlay.visible = true
	if label_level_score:
		label_level_score.text = "Score: %s" % label_score.text
	print("UI: Level Complete screen displayed")


## Handle play again button press
func _on_play_again_pressed() -> void:
	print("UI: Play Again pressed")
	if level_complete_overlay:
		level_complete_overlay.visible = false
	Game.reset_game()


## Handle main menu button press
func _on_main_menu_pressed() -> void:
	print("UI: Main Menu pressed")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


## Show pause overlay and freeze game
func _show_pause() -> void:
	if pause_overlay:
		pause_overlay.visible = true
	get_tree().paused = true
	print("UI: Pause screen displayed")


## Hide pause overlay and resume game
func _hide_pause() -> void:
	if pause_overlay:
		pause_overlay.visible = false
	get_tree().paused = false
	print("UI: Game resumed")


## Handle resume button press
func _on_resume_pressed() -> void:
	print("UI: Resume pressed")
	Game.GameState = Game.GameStates.RUNNING
