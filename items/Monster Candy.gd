extends Node

@onready var items = get_parent()
@onready var menu = items.get_parent()

var Name = "Monster Candy"
var Description = dialogue.dialogueList.MonsterCandyDesc
var Amount = 0

func effect():
	menu.close_menu()
