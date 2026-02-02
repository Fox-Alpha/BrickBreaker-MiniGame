extends StaticBody2D

signal HitByBall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "Brick_" +str(get_instance_id())
	add_to_group("Brick", true)
	HitByBall.connect(_On_Hit_by_ball)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_brick_area_area_entered(area: Area2D) -> void:
	print("_on_brick_area_area_shape_entered: ", area.name)
	pass # Replace with function body.


func _on_brick_area_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	print("_on_brick_area_area_shape_entered: ", area.name)
	pass # Replace with function body.


func _on_brick_area_body_entered(body: Node2D) -> void:
	#print("_on_brick_area_body_entered: ", body.name)
	#HitByBall.emit()
	pass # Replace with function body.


func _on_brick_area_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	print("_on_brick_area_body_shape_entered: ", body.name)
	pass # Replace with function body.


func _On_Hit_by_ball() -> void:
	print("Brick %s ist Hitted by Ball", [self.name])
	queue_free()
	pass
