extends CanvasLayer

@export var ball : RigidBody2D

@onready var label_score: Label = $PanelContainer/Panel/HBoxContainer/LabelScore

var _gamescore : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene.has_signal("Player_Score"):
		get_tree().current_scene.Player_Score.connect(_on_player_score)
	label_score.text = "0.000.000"
	pass # Replace with function body.


func _on_button_pressed() -> void:
	if(get_tree().current_scene.has_signal("Reset_Game")):
		get_tree().current_scene.Reset_Game.emit()
		pass
	pass # Replace with function body.


func _on_player_score(score : int) -> void :
	_gamescore += score
	label_score.text = "{0}".format({0:"%010d" % _gamescore})
	#"Hi, {0} v{version}".format({0:"Godette", "version":"%0.2f" % 3.114})
	#print("User {} is {}.".format([42, "Godot"], "{}"))
	pass
