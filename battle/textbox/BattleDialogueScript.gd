extends Node

var dialogueSelected = 0
var dialogueText = ""
var textEffectArray = []

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
			dialogueText = "* You encounter a froggit." + "/n" + "Pretty cool right?"#1
