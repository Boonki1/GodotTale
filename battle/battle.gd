extends Node2D

@onready var statsLabel = $StatsLabel
@onready var hpSprite = $HP
@onready var hpMaxSprite = $HPMax
@onready var hpText = $HPtext
@onready var boxRect = $boxRect
@onready var actSprite = $ActSprite
@onready var itemSprite = $ItemSprite
@onready var mercySprite = $MercySprite
@onready var fightSprite = $FightSprite
@onready var Enemies = $enemies
@onready var battleText = $BattleTextbox
@onready var enemyLabel = $EnemyLabel
@onready var heart = $Heart
@onready var slice = $Slice
@onready var target = $Target
@onready var targetchoice = $Targetchoice

var playerName = global.data["name"]
var MaxHP = global.data["MaxHP"]

var EnemyArray = []

var addedEnemyLabels = false

var scroll = 0

var enemyChosen = null

var LabelArray = []

var AttackMade = false
var AttackDisappear = false

enum BattleState{
	PLAYERTURN,
	ENEMYTURN,
	ENTERENEMYTURN,
	FIGHTCHOOSE,
	FIGHTSLASH,
}

var curBattleState = BattleState.PLAYERTURN 

# Called when the node enters the scene tree for the first time.
func _ready():
	enemyLabel.visible_ratio = 0
	statsLabel.text = statsLabel.text.replace("Chara", playerName)
	hpMaxSprite.size = Vector2(MaxHP, 21)
	hpText.position.x = hpMaxSprite.position.x + hpMaxSprite.size.x + 14
	for i in Enemies.get_children():
		EnemyArray.push_back(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hpSprite.size = Vector2(global.data["HP"], 21)
	hpText.text = str(global.data["HP"]) + " / " + str(global.data["MaxHP"])
	$boxRect/boxRectCollision/right.position.x = boxRect.size.x - 1.5
	$boxRect/boxRectCollision/bottom.position.y = boxRect.size.y - 1.5
	
	match curBattleState:
		BattleState.PLAYERTURN:
			target.visible = false
			target.scale.x = 1
			target.self_modulate.a = 1
			battleText.canSkip = true
			Menu()
			if fightSprite.frame == 1:
				if Input.is_action_just_pressed("interact"):
					curBattleState = BattleState.FIGHTCHOOSE
					scroll = 0
					battleText.visible = false
					battleText.visible_characters = 999
					fightSprite.frame = 0
		
		BattleState.FIGHTCHOOSE:
			if !addedEnemyLabels:
				enemyLabel.visible = true
				for i in EnemyArray.size():
					var Xoffset = 128*(i % 2)
					var Yoffset = 0
					if i > 1:
						Yoffset = 16
					if i > 3:
						Yoffset = 32
					var NameLabel = Label.new()
					NameLabel.text = "* " + EnemyArray[i].Name
					NameLabel.label_settings = enemyLabel.label_settings
					NameLabel.position.x = Xoffset
					NameLabel.position.y = Yoffset
					enemyLabel.add_child(NameLabel)
					LabelArray.push_back(NameLabel)
			
			addedEnemyLabels = true
			
			ChooseEnemyMenu()
			
			if Input.is_action_just_pressed("interact"):
				for i in LabelArray:
					i.visible = false
				targetchoice.position = Vector2(45,320)
				curBattleState = BattleState.FIGHTSLASH
			
			if Input.is_action_just_pressed("cancel"):
				scroll = 0
				battleText.canSkip = false
				battleText.resetLine()
				battleText.visible = true
				for i in enemyLabel.get_children():
					i.queue_free()
				LabelArray = []
				addedEnemyLabels = false
				curBattleState = BattleState.PLAYERTURN
		
		BattleState.FIGHTSLASH:
			heart.visible = false
			target.visible = true
			targetchoice.visible = true
			if !AttackMade:
				targetchoice.position.x += 6
			
			if Input.is_action_just_pressed("interact") and !AttackMade:
				AttackMade = true
				Hit(EnemyArray[scroll])
				await get_tree().create_timer(1.5).timeout
				curBattleState = BattleState.ENTERENEMYTURN
				targetchoice.visible = false
		
		BattleState.ENTERENEMYTURN:
			target.scale.x -= 0.03
			target.self_modulate.a -= 0.05
			await get_tree().create_timer(0.4).timeout
			heart.position = Vector2(300,320)
			curBattleState = BattleState.ENEMYTURN
		
		BattleState.ENEMYTURN:
			heart.visible = true
			
func Menu():
	heart.position.y = 454
	
	if Input.is_action_just_pressed("right"):
		if scroll < 3:
			scroll += 1
		else:
			scroll = 0
	if Input.is_action_just_pressed("left"):
		if scroll > 0:
			scroll -= 1
		else:
			scroll = 3
	
	if scroll == 0:
		heart.position.x = fightSprite.position.x - 38
		fightSprite.frame = 1
	else:
		fightSprite.frame = 0
	if scroll == 1:
		heart.position.x = actSprite.position.x - 38
		actSprite.frame = 1
	else:
		actSprite.frame = 0
	if scroll == 2:
		heart.position.x = itemSprite.position.x - 38
		itemSprite.frame = 1
	else:
		itemSprite.frame = 0
	if scroll == 3:
		heart.position.x = mercySprite.position.x - 38
		mercySprite.frame = 1
	else:
		mercySprite.frame = 0

func ChooseEnemyMenu():
	if LabelArray.size() > 0:
		if Input.is_action_just_pressed("right"):
			if scroll < LabelArray.size()-1:
				scroll += 1
			else:
				scroll = 0
		if Input.is_action_just_pressed("left"):
			if scroll > 0:
				scroll -= 1
			else:
				scroll = LabelArray.size()-1
		if Input.is_action_just_pressed("down"):
			if scroll+2 < LabelArray.size():
				scroll += 2
			else:
				if scroll+2 == LabelArray.size():
					scroll = 1
				if scroll+2 == LabelArray.size()+1:
					scroll = 0
		if Input.is_action_just_pressed("up"):
			if scroll-2 >= 0:
				scroll -= 2
			else:
				if scroll-2 == -1:
					scroll = LabelArray.size()-2
				if scroll-2 == -2:
					scroll = LabelArray.size()-1
		
		heart.global_position.x = LabelArray[scroll].global_position.x - 16
		heart.global_position.y = LabelArray[scroll].global_position.y + 16
	
	if Input.is_action_just_pressed("interact"):
		enemyChosen = EnemyArray[scroll]

func Hit(_enemy):
	slice.frame = 0
	slice.visible = true
	slice.position = _enemy.position

func _on_slice_animation_looped():
	slice.visible = false
