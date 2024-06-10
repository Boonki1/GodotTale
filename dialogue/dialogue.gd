extends Node

var dialogueSelected = 0
var dialogueArray = []
var textEffectArray = []
var dialogueFaceArray = []
var textSoundArray = []

enum dialogueList{
	test,
	MonsterCandyDesc,
}

enum textSound{
	default,
	flowey,
}

enum textEffect{
	NONE,
	GHOST,
}

enum face{
	NONE,
	FLOWEYNICE,
}

func _ready():
	setup()

func setup():
	match dialogueSelected:
		dialogueList.test:
			dialogueArray =[
			"* abcdefghijklmnopqrstuvwxyz" + "/n" + 
			"abcdefghijklmnopqrstuvwxyz"#1
			,
			"* here's a list" + "/n" + 
			"* 1, 2, 3, 4, 5..."#2
			]
		
			textEffectArray =[
			textEffect.NONE,#1
			textEffect.GHOST#2
			]
		
			dialogueFaceArray =[
			face.NONE,#1
			face.FLOWEYNICE#2
			]
		
			textSoundArray =[
			textSound.flowey,#1
			textSound.default,#2
			]
		
		dialogueList.MonsterCandyDesc:
			dialogueArray =[
			"* Has a distinct, non-licorice" + "/n" + "flavor."
			]
		
