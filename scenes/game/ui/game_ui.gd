extends CanvasLayer

@export var ball : RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if(get_tree().current_scene.has_signal("Reset_Game")):
		get_tree().current_scene.Reset_Game.emit()
		pass
	pass # Replace with function body.
