extends TileMapLayer

const UI_MARGIN : Vector4i = Vector4i(100, 0, 0, 0)

@onready var MapsizeInPixel	: Vector2i	: get = _get_mapsize_in_pixel
@onready var MapsizeInTile	: Vector2i	: get = _get_mapsize_in_tiles
@onready var MapTilesize		: Vector2i	: get = _get_map_tilesize
@onready var MapsizeRect2i	: Rect2i	: get = _get_mapsizetiles_rect2i
@onready var MapsizePxRect2i	: Rect2i	: get = _get_mapsizetiles_px_rect2i

@onready var world_boundarys: WorldBoundarys = $WorldBoundarys

var _brickcount : int = 0 :
	get(): return _brickcount
	set(value):
		_brickcount = value
		if _brickcount == 0:
			get_tree().current_scene.NoMoreBrickInMap.emit()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_mapposition_to_viewport()
	#global_position = get_viewport_rect().get_center()

	world_boundarys.ResetWorldBorderPositions(UI_MARGIN)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _get_mapsize_in_pixel() -> Vector2i:
	return get_used_rect().end * tile_set.tile_size


func _get_mapsize_in_tiles() -> Vector2i:
	return get_used_rect().end


func _get_mapsizetiles_rect2i() -> Rect2i:
	return get_used_rect()


func _get_mapsizetiles_px_rect2i() -> Rect2i:
	var rect := get_used_rect()
	rect.size *= tile_set.tile_size
	return rect


func _get_map_tilesize() -> Vector2i:
	return tile_set.tile_size


func _set_mapposition_to_viewport() -> void:
	## Viewport Rectangle
	var vprect := get_viewport_rect()

	# Size - Margin: Top=X, Right=Y, Bottom=Z, Left= W
	## Virtuelle(Nutzbare) Größe des ViewPort
	var vrt_vwpt := vprect
	# UI_Margin : [Vector4i]
	vrt_vwpt.size.x -= UI_MARGIN.y-UI_MARGIN.w
	vrt_vwpt.size.y -= UI_MARGIN.x-UI_MARGIN.z

	vrt_vwpt.position.x += UI_MARGIN.w + UI_MARGIN.y
	vrt_vwpt.position.y += UI_MARGIN.x + UI_MARGIN.z

	## Neue Position der BrickMap
	var vrtcp_cent := vrt_vwpt.get_center()
	var msp := MapsizeInPixel
	vrtcp_cent.x -= msp.x / 2.0
	#vrtcp_cent.y = msp.y / 2 + UI_MARGIN.x

	global_position = Vector2(vrtcp_cent.x, msp.y / 2.0 + UI_MARGIN.x)
	pass


func _on_child_entered_tree(node: Node) -> void:
	if node is Brick:
		print("Brick entered MapTree -> %s" % [node.name])
		_brickcount += 1
		randomize()
		node.hit_points = 1 # [1.0,2.0][randi() % 2]
		#velocity.y = [-0.8, 0.8][randi() % 2]
		node.points = 10 #[node.hit_points,50][randi() % 2]


func _on_child_exiting_tree(node: Node) -> void:
	if node is Brick:
		print("Brick leave MapTree -> %s" % [node.name])
		_brickcount -= 1
		get_tree().current_scene.Player_Score.emit( (node as Brick).hit_points)
	pass # Replace with function body.
