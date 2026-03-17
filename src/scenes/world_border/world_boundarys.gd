## Sets the World Border Position with the Map Size
class_name WorldBoundarys extends Node2D



## Border Nodes
@export_group("Borders")
## Holds a [StaticBody2D] as the Left Border Node
@export var LeftBorder : StaticBody2D
## Holds a [StaticBody2D] as the Top Border Node
@export var TopBorder : StaticBody2D
## Holds a [StaticBody2D] as the Right Border Node
@export var RightBorder : StaticBody2D
## Holds a [StaticBody2D] as the Bottom Border Node
@export var BottomBorder : StaticBody2D


func _ready() -> void:
	#Multihelper.terrain_generated.connect(ResetWorldBorderPositions)
	pass


## Sets the World Border Position with the Map Size [br]
##
# [param maprect] : [Vector2i] Bottom right point from Mapsize[br]
## [param _layer] (unused): Map Layer Index [br]
## [param maprect] [Recti2D] Used Tile Rect
func ResetWorldBorderPositions(margin_to_vwpt : Vector4i = Vector4i.ZERO) -> void:
	print("ResetWorldBorderPositions() with margin to ViewPort: %s" % [margin_to_vwpt])
	var VpSz = get_viewport_rect()
	VpSz.size.y -= margin_to_vwpt.x
	VpSz.position.y += margin_to_vwpt.x

	TopBorder.global_position.x = VpSz.size.x / 2.0
	TopBorder.global_position.y = VpSz.position.y

	RightBorder.global_position.x = VpSz.size.x
	RightBorder.global_position.y = VpSz.end.y / 2.0

	BottomBorder.global_position.x = VpSz.size.x / 2.0
	BottomBorder.global_position.y = VpSz.position.y +VpSz.size.y

	LeftBorder.global_position.x = VpSz.position.x
	LeftBorder.global_position.y = VpSz.end.y / 2.0

	pass
