extends Node

@export var stackableItems = true

var itemArray = []
@onready var items = $Items
@onready var menu = $menu
@onready var itemsMenuList = $menu/Items

var MaxItems = 999

func _ready():
	menu.visible = false
	for i in itemsMenuList.get_children():
		i.text = ""
	
	MaxItems = itemsMenuList.get_children().size()

func _input(event):
	if Input.is_action_just_pressed("debug1"):
		AddItem("Monster Candy")
	if Input.is_action_just_pressed("debug2"):
		AddItem("Cider")
	if Input.is_action_just_pressed("debug3"):
		itemArray = []

func AddItem(_item):
	if itemArray.size() < MaxItems:
		var isDuplicate = false
		for i in get_children():
			if _item == i.name:
				for j in itemArray:
					if j.name == _item and stackableItems:
						isDuplicate = true
						break
				if stackableItems:
					i.Amount += 1
				else:
					i.Amount = 1
				if !isDuplicate:
					itemArray.push_back(i)
				break
