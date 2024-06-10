extends CanvasLayer

var menuOpen = false
@onready var heart = $Heart
@onready var itemsMenu = $Items/menu
@onready var items = $Items
@onready var itemLabel = $menu/ITEM
@onready var statLabel = $menu/STAT
@onready var cellLabel = $menu/CELL

enum selectList{
	ITEMS,
	STAT,
	CELL
}

var menuJustClosed = false

var TextboxExists = false

var scroll = selectList.ITEMS
var selected = null

var menuStage = 0

var scrollinv = 0

func _ready():
	heart.position = Vector2(32.5,102.5)

func _input(event):
	if items.itemArray.size() > 0:
		itemLabel.label_settings.font_color = Color(1,1,1)
	else:
		itemLabel.label_settings.font_color = Color(0.5,0.5,0.5)
	if menuOpen:
		match selected:
			null:
				if Input.is_action_just_pressed("down"):
					if scroll < 2:
						scroll += 1
					else:
						scroll = 0
				if Input.is_action_just_pressed("up"):
					if scroll > 0:
						scroll -= 1
					else:
						scroll = 2
				if scroll == selectList.ITEMS:
					heart.position.y = 102.5
					if items.itemArray.size() > 0:
						itemLabel.label_settings.font_color = Color(1,1,1)
						if Input.is_action_just_pressed("interact"):
							selected = selectList.ITEMS
							menuStage = 1
							scroll = 0
					else:
						itemLabel.label_settings.font_color = Color(0.5,0.5,0.5)
				if scroll == selectList.STAT:
					heart.position.y = 120.5
					if Input.is_action_just_pressed("interact"):
						menuJustClosed = true
						selected = selectList.STAT
						menuStage = 1
				if scroll == selectList.CELL:
					heart.position.y = 138.5
					if Input.is_action_just_pressed("interact"):
						menuJustClosed = true
						selected = selectList.CELL
						menuStage = 1
				
				if Input.is_action_just_pressed("cancel") or Input.is_action_just_pressed("menu"):
					close_menu()
					menuJustClosed = true
				
			selectList.ITEMS:
				itemsMenu.visible = true
				draw_items()
				if menuStage == 1:
					heart.position.x = 108.5
					heart.global_position.y = items.itemsMenuList.get_child(scrollinv).global_position.y + 8.5
					if Input.is_action_just_pressed("down"):
						if scrollinv < items.itemArray.size()-1:
							scrollinv += 1
						else:
							scrollinv = 0
					if Input.is_action_just_pressed("up"):
						if scrollinv > 0:
							scrollinv -= 1
						else:
							scrollinv = items.itemArray.size()-1
				
					if Input.is_action_just_pressed("cancel"):
						scrollinv = 0
						menuStage = 0
						itemsMenu.visible = false
						selected = null
						menuJustClosed = true
						heart.position = Vector2(32.5,102.5)
					
					if Input.is_action_just_pressed("interact"):
						menuJustClosed = true
						menuStage = 2
						scroll = 0
					
				if menuStage == 2 and !menuJustClosed:
					heart.position.y = 188.5
					
					if Input.is_action_just_pressed("right"):
						if scroll < 2:
							scroll += 1
						else:
							scroll = 0
					if Input.is_action_just_pressed("left"):
						if scroll > 0:
							scroll -= 1
						else:
							scroll = 2
					
					if Input.is_action_just_pressed("interact"):
						if scroll == 0:
							items.itemArray[scrollinv].effect()
						if scroll == 1:
							global.CreateTextBox(items.itemArray[scrollinv].Description,self)
							close_menu()
						if scroll == 2:
							pass
					
					if Input.is_action_just_pressed("cancel"):
						scroll = 0
						menuStage = 1
						menuJustClosed = true
					
					if scroll == 0:
						heart.position.x = 107.5
					if scroll == 1:
						heart.position.x = 155.5
					if scroll == 2:
						heart.position.x = 211.5
				
				menuJustClosed = false
	

	if Input.is_action_just_pressed("menu"):
		if !menuOpen:
			if get_parent().canMove:
				if !menuJustClosed:
					open_menu()
	
	menuJustClosed = false

func draw_items():
	if items.itemArray.size() > 0:
		for i in items.MaxItems:
			var j = items.itemArray[clamp(i,0,items.itemArray.size()-1)]
			var h = items.itemsMenuList.get_child(i)
			if j.Amount > 1:
				h.text = j.Name + "   X " + str(j.Amount)
			else:
				h.text = j.Name
			
			if i >= items.itemArray.size()-1:
				break
	else:
		for i in items.itemsMenuList.get_children():
			i.text = ""

func info(_item):
	pass

func open_menu():
	scroll = 0
	heart.position = Vector2(32.5,102.5)
	menuOpen = true
	visible = true
	get_parent().canMove = false

func close_menu():
	itemsMenu.visible = false
	visible = false
	if global.TextboxExists == false:
		get_parent().canMove = true
	scrollinv = 0
	selected = null
	menuStage = 0
	menuOpen = false
