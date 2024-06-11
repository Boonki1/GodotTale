extends Control

var player = null
var parent = null
@onready var text = $CanvasLayer/NinePatchRect/Text
@onready var audio = $AudioStreamPlayer
@onready var commaTimer = $"comma timer"
@onready var dialogueScript = $dialogueScript
@onready var periodTimer = $"period timer"
@onready var sprite = $CanvasLayer/AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

const text_speed = 0.5
const lineSpacing = 18
var ScreenPosition = 0

var playerCamPosition = Vector2.ZERO

var newLinePos = [INF,INF]
var visible_characters = 0.0
var splitLine1 = []
var splitLine2 = []
var splitLine3 = []
var page = 0
var pageMax = 0

var useTextEffect = false
var textEffect = ""
var faceSprite = 0
var useFaceSprite = false
var textSound = null
var xEffectOffset = 0
var yEffectOffset = 0
var effectTimer = 0
var effectSpeed = 0.2

var curDialogue = 0

var line1 = ""
var line2 = ""
var line3 = ""

var line1done = false
var line2done = false
var line3done = false
var lineHeight = 0

var letterWidthArray1 = []
var letterWidthArray2 = []
var letterWidthArray3 = []

var letterWidth1 = 0
var letterWidth2 = 0
var letterWidth3 = 0

var Line1Hash = Label.new()
var Line2Hash = Label.new()
var Line3Hash = Label.new()

func SetTextSound():
	match faceSprite:
		dialogueScript.textSound.default:
			audio.stream = load("res://dialogue/sounds/TXT1.wav")
		dialogueScript.textSound.flowey:
			audio.stream = load("res://dialogue/sounds/floweytalk1.wav")

func SetFaceSprite():
	match faceSprite:
		dialogueScript.face.NONE:
			sprite.sprite_frames = null
		dialogueScript.face.FLOWEYNICE:
			sprite.sprite_frames = $Faces/FloweyNice.sprite_frames

func SetTextEffect(i1,i2,i3,labelX1,labelX2,labelX3,labelY1,labelY2,labelY3):
	match textEffect:
		dialogueScript.textEffect.NONE:
			if line1.length() > 0 and i1 < line1.length():
				splitLine1[i1].position = Vector2(labelX1,labelY1)
			
			if line2.length() > 0 and i2 < line2.length():
				splitLine2[i2].position = Vector2(labelX2,labelY2+lineSpacing)
				
			if line3.length() > 0 and i3 < line3.length():
				splitLine3[i3].position = Vector2(labelX3,labelY3+lineSpacing*2)
		
		dialogueScript.textEffect.GHOST:
			if line1.length() > 0:
				splitLine1[i1].position = Vector2(labelX1,labelY1+sin(effectTimer+i1))
				
			if line2.length() > 0:
				splitLine2[i2].position = Vector2(labelX2,labelY2+lineSpacing+sin(effectTimer+i2))
			
			if line3.length() > 0:
				splitLine3[i3].position = Vector2(labelX3,labelY3+lineSpacing*2+sin(effectTimer+i3))

func _ready():
	global.TextboxExists = true
	set_up_line()

func _draw():
	var top = "Top"
	var bottom = "Bottom"
	if sprite.sprite_frames == null:
		top = "Top"
		bottom = "Bottom"
	else:
		top = "TopFace"
		bottom = "BottomFace"
	
	if ScreenPosition == 1:
		animation_player.play(top)
	if ScreenPosition == 2:
		animation_player.play(bottom)
	if ScreenPosition == 0:
		if playerCamPosition.y < 0:
			animation_player.play(top)
		else:
			animation_player.play(bottom)
	visible = true

func set_up_line():
	dialogueScript.dialogueSelected = curDialogue
	
	dialogueScript.setup()
	
	print(dialogueScript.dialogueArray)
	
	text.text = dialogueScript.dialogueArray[page]
	
	pageMax = dialogueScript.dialogueArray.size() - 1
	
	if parent.get_class() != "CanvasLayer":
		ScreenPosition = parent.ScreenPosition
		playerCamPosition = parent.playerCamPosition
	
	sprite.z_index = z_index + 1
	
	if dialogueScript.textEffectArray.size() > 0:
		useTextEffect = true
		textEffect = dialogueScript.textEffectArray[page]
	else:
		useTextEffect = false
	
	if dialogueScript.dialogueFaceArray.size() > 0:
		useFaceSprite = true
		faceSprite = dialogueScript.dialogueFaceArray[page]
	else:
		useFaceSprite = false
	
	if !useFaceSprite:
		faceSprite = dialogueScript.face.NONE
	
	SetFaceSprite()
	
	if dialogueScript.textSoundArray.size() == 0:
		textSound = dialogueScript.textSound.default
	else:
		textSound = dialogueScript.textSoundArray[page]
	
	SetTextSound()
	
	_draw()
	
	#seperate text to 3 lines
	if text.text.find("/n") >= -1:
		line1 = text.text.get_slice("/n", 0)
	if text.text.find("/n") > 0:
		line2 = text.text.get_slice("/n", 1)
	if text.text.find("/n") > 1:
		line3 = text.text.get_slice("/n", 2)
	
	#add hashes at start of lines when needed
	if line1.length() > 0:
		if line1[0] == "*" and line1[1] == " ":
			line1 = line1.erase(0,2)
			Line1Hash.text = "*"
			Line1Hash.label_settings = text.label_settings
			Line1Hash.position.x = - 16
			text.add_child(Line1Hash)
	if line2.length() > 0:
		if line2[0] == "*" and line2[1] == " ":
			line2 = line2.erase(0,2)
			Line2Hash.text = "*"
			Line2Hash.label_settings = text.label_settings
			Line2Hash.position.x = - 16
			Line2Hash.position.y = lineSpacing
			Line2Hash.visible = false
			text.add_child(Line2Hash)
	if line3.length() > 0:
		if line3[0] == "*" and line3[1] == " ":
			line3 = line3.erase(0,2)
			Line3Hash.text = "*"
			Line3Hash.label_settings = text.label_settings
			Line3Hash.position.x = - 16
			Line3Hash.position.y = lineSpacing * 2
			Line3Hash.visible = false
			text.add_child(Line3Hash)
	
	#convert text to array with label objects so every character can be animated seperatly
	for i in line1.length():
		var characterLabel = Label.new()
		characterLabel.visible = false
		characterLabel.text = line1[i]
		characterLabel.label_settings = text.label_settings
		line1[i]
		text.add_child(characterLabel)
		splitLine1.push_back(characterLabel)
	for i in line2.length():
		var characterLabel = Label.new()
		characterLabel.visible = false
		characterLabel.text = line2[i]
		characterLabel.label_settings = text.label_settings
		line2[i]
		text.add_child(characterLabel)
		splitLine2.push_back(characterLabel)
	for i in line3.length():
		var characterLabel = Label.new()
		characterLabel.visible = false
		characterLabel.text = line3[i]
		characterLabel.label_settings = text.label_settings
		line3[i]
		text.add_child(characterLabel)
		splitLine3.push_back(characterLabel)
	
	var linewidth = 0.0
	for i in (line1).length():
			
			var letterWidth = 8
			match (line1)[i]:
				"'": letterWidth = 4
			
			letterWidthArray1.push_back(linewidth)
			
			linewidth += letterWidth
	linewidth = 0.0
	for i in (line2).length():
			
			var letterWidth = 8
			match (line2)[i]:
				"'": letterWidth = 4
			
			letterWidthArray2.push_back(linewidth)
			
			linewidth += letterWidth
	linewidth = 0.0
	for i in (line3).length():
			
			var letterWidth = 8
			match (line3)[i]:
				"'": letterWidth = 4
			
			letterWidthArray3.push_back(linewidth)
			
			linewidth += letterWidth
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in (line1+line2+line3).length():
		if !useTextEffect:
			textEffect = dialogueScript.textEffect.NONE
		
		var labelX1 = 0
		var labelX2 = 0
		var labelX3 = 0
		
		var labelY1 = 0	
		var labelY2 = 0
		var labelY3 = 0
		
		var iclamped1 = clamp(0,i,line1.length()-1)
		var iclamped2 = clamp(0,i-line1.length(),line2.length())
		var iclamped3 = clamp(0,i-(line1+line2).length(),line3.length())
		
		if line1.length() > 0 and iclamped1 < line1.length():
			labelX1 = letterWidthArray1[iclamped1]
		
		if line2.length() > 0 and iclamped2 < line2.length():
			labelX2 = letterWidthArray2[iclamped2]
		
		if line3.length() > 0 and iclamped3 < line3.length():
			labelX3 = letterWidthArray3[iclamped3]
		
		SetTextEffect(iclamped1,iclamped2,iclamped3,labelX1,labelX2,labelX3,labelY1,labelY2,labelY3)
		
	effectTimer += effectSpeed
	var old_visible_characters = visible_characters
	
	if periodTimer.is_stopped() and commaTimer.is_stopped():
		visible_characters += text_speed
		
		if Input.is_action_just_pressed("interact") and splitLine1.size() <= visible_characters:
			if page < pageMax:
				page += 1
				if dialogueScript.textEffectArray.size() < page:
					textEffect = dialogueScript.textEffectArray[page]
				else:
					useTextEffect = false
				for i in text.get_children():
					i.queue_free()
				splitLine1 = []
				splitLine2 = []
				splitLine3 = []
				Line1Hash = Label.new()
				Line2Hash = Label.new()
				Line3Hash = Label.new()
				letterWidthArray1 = []
				letterWidthArray2 = []
				letterWidthArray3 = []
				line1done = false
				line2done = false
				line3done = false
				effectTimer = 0
				visible_characters = 0
				set_up_line()
			else:
				close()
		
		if floor(visible_characters) == floor(old_visible_characters):
			if splitLine1.size() > visible_characters:
				splitLine1[visible_characters].visible = true
			if splitLine1.size() < visible_characters:
				line1done = true
			
			var visible_characters2 = visible_characters-splitLine1.size()
			
			if splitLine2.size() > visible_characters2 and line1done:
				splitLine2[visible_characters2].visible = true
			if splitLine2.size() < visible_characters2:
				line2done = true
			
			var visible_characters3 = visible_characters2-splitLine2.size()
			
			if splitLine3.size() > 0 and splitLine3.size() > visible_characters3 and line2done:
				splitLine3[visible_characters3].visible = true
			if splitLine3.size() < visible_characters3:
				line3done = true
			
			if splitLine1.size() > 0:
				if splitLine1[0].visible:
					Line1Hash.visible = true
			if splitLine2.size() > 0:
				if splitLine2[0].visible:
					Line2Hash.visible = true
			if splitLine3.size() > 0:
				if splitLine3[0].visible:
					Line3Hash.visible = true
			
			var last_character = (line1+line2+line3)[clamp(visible_characters-1, 0, (line1+line2+line3).length()-1)]
			var cur_character = (line1+line2+line3)[clamp(visible_characters, 0, (line1+line2+line3).length()-1)]
			var next_character = (line1+line2+line3)[clamp(visible_characters+1, 0 ,(line1+line2+line3).length()-1)]
			
			if cur_character != " " and !line3done:
				audio.play()
			
			if line3done and parent.get_class() != "CanvasLayer":
				parent.isTalking = false
			
			if (cur_character == "." or cur_character == "!" or cur_character == "?" or cur_character == ":") and !(next_character == "." or next_character == "!" or next_character == "?" or next_character == ":"):
				periodTimer.start()
			
			if cur_character == "," and next_character != ",":
				commaTimer.start()
			
			if sprite.sprite_frames != null:
				if !line3done:
					sprite.play("talk")
	
	if Input.is_action_just_pressed("cancel"):
			for i in splitLine1:
				i.visible = true
			for i in splitLine2:
				i.visible = true
			for i in splitLine3:
				i.visible = true
			visible_characters = 999
			periodTimer.stop()
			commaTimer.stop()

func close():
	if player != null:
		player.canMove = true
	global.TextboxExists = false
	if parent.get_class() != "CanvasLayer":
		if parent.OneTimeOnly == true:
			parent.queue_free()
	queue_free()


func _on_animated_sprite_2d_animation_looped():
	if sprite.sprite_frames != null:
		if line3done:
			if sprite.animation == "talk":
				sprite.play("idle")
