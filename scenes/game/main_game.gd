extends Node2D

@export var borders : WorldBoundarys
@export var paddle : PackedScene
const BALL_BODY = preload("uid://bx7lmlxv60bk7")

@export var brickmap : TileMapLayer
@export var cam : Camera2D

var worldsize : Vector2i = Vector2i(800,800)
@onready var vps := get_viewport_rect()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	borders.ResetWorldBorderPositions(get_viewport_rect().end)
	cam.position = get_viewport_rect().get_center()
	brickmap.position = get_viewport_rect().get_center()

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
