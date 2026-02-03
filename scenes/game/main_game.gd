extends Node2D

## signals:
# Brick To Map
# -> GM: Increment Brickcount
# Brick hit by ball
# -> GM: Update Score Counter / (Highscore)
# -> Map: Check Brick Count for == 0
# -> UI: Update Score Label
# Ball hit bottom void
# -> GM: Update Lives
# --> UI: Update Lives
# --> GameState: GameOver if no more lives
# No More Bricks in Map
# -> GM: Update GameState >> Level Won
# -> UI: Show Win Dialog / Next Level

const BALL_BODY = preload("uid://bx7lmlxv60bk7")

signal NoMoreBrickInMap

@export var paddle : PackedScene
@export var brickmap : TileMapLayer
@export var cam : Camera2D

@onready var vps := get_viewport_rect()
@onready var center_marker: Marker2D = $CenterMarker

var worldsize : Vector2i = Vector2i(800,800)
var _brickcount : int = 0 :
	get(): return _brickcount
	set(value):
		_brickcount = value
		if _brickcount == 0:
			NoMoreBrickInMap.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NoMoreBrickInMap.connect(func(): print("Keine Bricks mehr da"))
	cam.position = get_viewport_rect().get_center()
	center_marker.position = get_viewport_rect().get_center()

	var pad := paddle.instantiate()
	var ball := BALL_BODY.instantiate()
	ball.global_position = Vector2(vps.get_center().x, vps.end.y -64)
	add_child(ball)

	add_child(pad)
	var p:= Vector2(vps.get_center().x, vps.end.y -pad.getPaddleSize().y -8)
	pad.position = p
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_brick_map_child_entered_tree(node: Node) -> void:
	if node is Brick:
		print("Brick entered MapTree -> %s" % [node.name])
		_brickcount += 1
	pass # Replace with function body.


func _on_brick_map_child_exiting_tree(node: Node) -> void:
	if node is Brick and _brickcount > 0:
		print("Brick leave MapTree -> %s" % [node.name])
		_brickcount -= 1
	pass # Replace with function body.
