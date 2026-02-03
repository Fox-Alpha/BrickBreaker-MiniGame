class_name Brick extends StaticBody2D

signal HitByBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HitByBall.connect(_On_Hit_by_ball)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


func _on_brick_area_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	#print("_on_brick_area_body_shape_entered: ", body.name)
	HitByBall.emit()
	pass # Replace with function body.


func _On_Hit_by_ball() -> void:
	#print("Brick %s ist Hitted by Ball", [self.name])
	queue_free()
	pass


func _on_tree_entered() -> void:
	name = "Brick_" +str(get_instance_id())
	add_to_group("Brick", true)
	pass # Replace with function body.
