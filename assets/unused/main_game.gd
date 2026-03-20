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

#region Global_Signals
@warning_ignore_start("unused_signal")
signal Reset_Game
signal Player_Score
signal GS_GAME_PAUSED
signal GS_GAME_UNPAUSED
#signal GL_GAMESTATE_CHANGE
@warning_ignore_restore("unused_signal")
#endregion

@export var paddle : PackedScene
@export var brickmap : TileMapLayer
@export var cam : Camera2D
@export var canvas_layer: CanvasLayer

@onready var vps := get_viewport_rect()
@onready var center_marker: Marker2D = $CenterMarker

var ball : Node


var worldsize : Vector2i = Vector2i(800,800)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Game Main
	NoMoreBrickInMap.connect(func(): print("Keine Bricks mehr da"))
	cam.position = get_viewport_rect().get_center()
	center_marker.position = get_viewport_rect().get_center()
	GS_GAME_UNPAUSED.connect(startgame)
	#get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func startgame() -> void:
	var pad := paddle.instantiate()
	ball = BALL_BODY.instantiate()
	ball.global_position = Vector2(vps.get_center().x, vps.end.y -164)
	add_child(ball)
	canvas_layer.ball = ball
	add_child(pad)
	var p:= Vector2(vps.get_center().x, vps.end.y -pad.getPaddleSize().y *2)
	pad.position = p
