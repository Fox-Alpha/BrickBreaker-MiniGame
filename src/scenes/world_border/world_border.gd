## Sets the World Border Position with the Map Size
class_name WorldBoundarys extends Node2D


## Border Nodes
@export_group("Borders")
## Holds a [StaticBody2D] as the Left Border Node
@export var left_border: StaticBody2D
## Holds a [StaticBody2D] as the Top Border Node
@export var top_border: StaticBody2D
## Holds a [StaticBody2D] as the Right Border Node
@export var right_border: StaticBody2D
## Holds a [StaticBody2D] as the Bottom Border Node
@export var bottom_border: StaticBody2D


func _ready() -> void:
	if bottom_border and bottom_border.has_node("BallLossDetector"):
		var detector = bottom_border.get_node("BallLossDetector")
		if detector is Area2D:
			detector.body_entered.connect(_on_ball_loss_detector_entered)


## Sets the World Border Position with the Map Size [br]
##
# [param maprect] : [Vector2i] Bottom right point from Mapsize[br]
## [param _layer] (unused): Map Layer Index [br]
## [param maprect] [Recti2D] Used Tile Rect
func reset_world_border_positions(margin_to_vwpt: Vector4i = Vector4i.ZERO) -> void:
	print("reset_world_border_positions() with margin to ViewPort: %s" % [margin_to_vwpt])
	var viewport_size = get_viewport_rect()
	viewport_size.size.y -= margin_to_vwpt.x
	viewport_size.position.y += margin_to_vwpt.x

	top_border.global_position.x = viewport_size.size.x / 2.0
	top_border.global_position.y = viewport_size.position.y

	right_border.global_position.x = viewport_size.size.x
	right_border.global_position.y = viewport_size.end.y / 2.0

	bottom_border.global_position.x = viewport_size.size.x / 2.0
	bottom_border.global_position.y = viewport_size.position.y + viewport_size.size.y

	left_border.global_position.x = viewport_size.position.x
	left_border.global_position.y = viewport_size.end.y / 2.0


## Handles ball loss when it passes bottom boundary
func _on_ball_loss_detector_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		print("WorldBorder: Ball lost - fell off bottom edge")
		Game.GL_BALL_LOST.emit()
