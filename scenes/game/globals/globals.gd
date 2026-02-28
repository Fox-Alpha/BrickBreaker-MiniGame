extends Node

#region ScenesAndNodes
#var GameMainScene : PackedScene = preload("res://scenes/game/pong.tscn")
var DebugControl : Control :
	set (value):
		DebugControl = value
	get:
		return DebugControl
#endregion

#region GameStates
#var isMultiplayerGame : bool = false
####
#	BITS		12		11		10	9	8	7	6	5	4	3	2	1	0
#	Values		2048	1024	512	256	128	64	32	16	8	4	2	1	0
# 	0b00000001
#####
enum GameStates {
	NOTDEFINED			= 0b00000000000,	# 0
	NOTUSED				= 0b00000000001,	# 1
	GAMELOADINGERROR	= 0b00000000010,	# 2
	GAMEMAINMENU		= 0b00000000100,	# 4
	GAMEISLOADING		= 0b00000001000,	# 8
	GAMEINITIALIZING	= 0b00000010000,	# 16
	GAMEINITIALIZED		= 0b00000100000,	# 32
	GAMEWAITFORSTART	= 0b00001000000,	# 64
	GAMEISSTARTED		= 0b00010000000,	# 128
	#GAMESTATERESET		= 0b00100000000,	# 256
	#GAMEMAXROUND_NU	= 0b01000000000,	# 512
	GAMEOVER			= 0b10000000000,	# 1024
}
var GameState : GameStates = GameStates.NOTDEFINED :
	set(value):
		GameState = value
		GL_GAMESTATE_CHANGE.emit(GameState)
	get():
		return GameState
#endregion

@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()


#region ##### Beispiel Setter / Getter
#var sprite_offset : Vector2 = Vector2.ZERO :
#	set (value):
#		sprite_offset = on_sprite_offset_change(value)
#	get:
#		return sprite_offset
#
#func on_sprite_offset_change(value: Vector2) -> Vector2:
#	return Vector2.ZERO
#endregion #####

#region Signals
signal Game_Window_Size_Changed
#signal Game_State_Changed(gs : GameStates)
## Gamestate has just changed
signal GL_GAMESTATE_CHANGE(gs : GameStates)
## Change Gamestate to new state
signal GL_CHANGE_GAMESTATE(gs : GameStates)
#signal Game_Max_Score_Reached
#signal Game_Max_Round_Reached

#signal Register_Game_Logic(instanceid : int)
#signal Register_UI_Manager(instanceid : int)
#signal Register_SCORE_Manager(instanceid : int)
#endregion

#region GAMEMANAGER
#var GameLogic : Node
#var Scr_Manager : ManagerBaseClass
#var UI_Manager : ManagerBaseClass
#endregion

#signal Update_Player_Dict(p1:String, p2:String,score:int,rounds:int)

func _ready() -> void:
	print("Global Autoload => _ready()")
	get_tree().get_root().size_changed.connect(func(): Game_Window_Size_Changed.emit())
	get_tree().get_root().tree_exited.connect(_Game_is_closing)
	GL_GAMESTATE_CHANGE.connect(_Game_State_Has_Changed, CONNECT_DEFERRED)
	GL_CHANGE_GAMESTATE.connect(_Game_State_On_Change_State, CONNECT_DEFERRED)
	#Register_SCORE_Manager.connect(_Register_SCORE_Manager, CONNECT_ONE_SHOT)
	#Register_UI_Manager.connect(_Register_UI_Manager, CONNECT_ONE_SHOT)
	#Register_Game_Logic.connect(_Register_Game_Logic, CONNECT_ONE_SHOT)

	rng.seed = 19771202


func _exit_tree() -> void:
	print("Global Autoload => _exit_tree()")


func _Game_is_closing() -> void:
	print("Global Autoload => GameScene::_exiting_tree()")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			print("Global Autoload => _notification()::NOTIFICATION_ENTER_TREE")
			pass
		NOTIFICATION_EXIT_TREE:
			print("Global Autoload => _notification()::NOTIFICATION_EXIT_TREE")
			pass


func _Game_State_On_Change_State(new_gs : Game.GameStates) -> void:
	if GameState == new_gs: return

	GameState = new_gs
	pass

func _Game_State_Has_Changed(new_gs : Game.GameStates) -> void:
	#if GameState == new_gs: return

	#GameState = new_gs
	print("Global Autoload => _Game_State_Has_Changed(GS:%s)" % Game.GameStates.keys()[new_gs])
	match new_gs:
		Game.GameStates.GAMEISLOADING:
			pass
		Game.GameStates.GAMEINITIALIZING:
			pass
		Game.GameStates.GAMEINITIALIZED:
			_Connect_Signals()
			pass
		Game.GameStates.GAMEWAITFORSTART:
			pass
		Game.GameStates.GAMEISSTARTED:
			pass
		Game.GameStates.GAMEOVER:
			#TBD Change Scene to Score Table
			pass
		#Game.GameStates.GAMEMAXSCORE:
			##TBD Prepare for next Round
			#pass
		#Game.GameStates.GAMEMAXROUND:
			##TBD maybe Prepare GameOver
			#pass


func _Connect_Signals() -> void:
	#Game_Max_Score_Reached.connect(_Game_Max_Score_Reached)
	#Game_Max_Round_Reached.connect(_Game_Max_Round_Reached)
	pass


func _Register_SCORE_Manager(IID : int) -> void:
	if is_instance_id_valid(IID):
		print("Global => _Register_SCORE_Manager()")
		#Scr_Manager = instance_from_id(IID)
	else:
		GL_GAMESTATE_CHANGE.emit(GameStates.GAMELOADINGERROR)
		print("Global => ERROR: _Register_SCORE_Manager()")


func _Register_UI_Manager(IID : int) -> void:
	if is_instance_id_valid(IID):
		print("Global => _Register_UI_Manager()")
		#UI_Manager = instance_from_id(IID)
	else:
		GL_GAMESTATE_CHANGE.emit(GameStates.GAMELOADINGERROR)
		print("Global => ERROR: _Register_UI_Manager()")


func _Register_Game_Logic(IID : int) -> void:
	if is_instance_id_valid(IID):
		print("Global => _Register_Game_Logic()")
		#GameLogic = instance_from_id(IID)
	else:
		GL_GAMESTATE_CHANGE.emit(GameStates.GAMELOADINGERROR)
		print("Global => ERROR: _Register_Game_Logic()")


func _Game_Max_Score_Reached() -> void:
	#GL_GAMESTATE_CHANGE.emit(GameStates.GAMEMAXSCORE)
	pass


func _Game_Max_Round_Reached() -> void:
	#GL_GAMESTATE_CHANGE.emit(GameStates.GAMEMAXROUND)
	pass


########

#func __ready():
	#get_tree().get_root().size_changed.connect(func(): Game_Window_Size_Changed.emit())
	#Game_State_Changed.connect(_Game_State_Changed)
	#
	#Game_Prepare_Next_Round.connect(_Prepare_Next_Round)
	#Game_Max_Round_Reached.connect(_Game_Is_over, CONNECT_DEFERRED)
	#Game_Is_over.connect(_Game_Is_over, CONNECT_DEFERRED)
	#Left_Player_Scored.connect(_Player_has_Scored)
	#Right_Player_Scored.connect(_Player_has_Scored)
	#
	#New_Game_Started.connect(func(): pass)
	#Next_Round_Started.connect(func(): pass)
	#Game_Reseted.connect(func(): pass)
	#Game_Prepare_Round.connect(func(): pass)


#func _Game_Is_over(ply):
	#var roundname = "round_{rnd}".format({"rnd":str(currentround)})
#
	#playerdic[roundname] = {"p1": p1_score, "p2":p2_score, "won": ply}
	#currentround += 1
	#pass
