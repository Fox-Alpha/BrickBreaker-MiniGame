extends CanvasLayer

@export var ball : RigidBody2D

@onready var label_score: Label = $PanelContainer/Panel/HBoxContainer/LabelScore
@onready var reset_button: Button = $PanelContainer/Panel/HBoxContainer/ButtonResetGame
@onready var color_rect: ColorRect = $VBoxContainer/ColorRect

var _gamescore : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	if get_tree().current_scene.has_signal("GS_GAME_PAUSED"):
		get_tree().current_scene.Player_Score.connect(_on_player_score)
		# RECT Einblenden
		pass
	if get_tree().current_scene.has_signal("GS_GAME_UNPAUSED"):
		get_tree().current_scene.Player_Score.connect(_on_game_unpaused)
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
