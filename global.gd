extends Node

var gameTime = 0.0

var MidTransition = false

var entryPoint = null

var TextboxExists = false

var path = "res://data.json"

@onready var FadeAnim = $CanvasLayer/FadeAnim
@onready var FadeAnimPoly = $CanvasLayer/Polygon2D

var data = {
	"name" : "CHARA",
	"HP" : 20,
	"MaxHP" : 20,
	"LV" : 1,
	"EXP" : 0
}

enum plot {
	MetFloweyAndToriel,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	save(data)
	FadeAnimPoly.visible = true

func save(content):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_var(content)
	file = null
	
func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_as_text()
	return content 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gameTime += 1
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

var scenePath = "res://overworld/rooms/scenes/test.tscn"

func RoomTransition(_scene):
	global.MidTransition = true
	FadeAnim.play("Fadeout")
	scenePath = "res://overworld/rooms/scenes/" + _scene + ".tscn"

func ChangeScene(_scene):
	global.MidTransition = false
	get_tree().change_scene_to_file(scenePath)
	FadeAnim.play("Fadein")

func CreateTextBox(_Dialogue,_parent):
	var Textbox = load("res://dialogue/Textbox.tscn")
	var player = get_tree().get_first_node_in_group("OverworldPlayer")
	var playerCamPosition = player.camera.get_screen_center_position() - player.position
	global.TextboxExists = true
	player.canMove = false
	var TextboxInst = Textbox.instantiate()
	TextboxInst.player = player
	TextboxInst.parent = _parent
	TextboxInst.curDialogue = _Dialogue
	get_parent().add_child(TextboxInst)
	if _parent.get_class() != "CanvasLayer":
		if abs(player.position.x - _parent.position.x) < abs(player.position.y - _parent.position.y):
			if player.position.y > _parent.position.y:
				player.sprite.play("up")
				if player.position.y < _parent.position.y:
					player.sprite.play("down")
				
				if abs(player.position.x - _parent.position.x) > abs(player.position.y - _parent.position.y):
					if player.position.x > _parent.position.x:
						player.sprite.play("left")
					if player.position.x < _parent.position.x:
						player.sprite.play("right")
