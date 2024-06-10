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

var playerName = global.data["name"]
var MaxHP = global.data["MaxHP"]

var EnemyArray = []

enum BattleState{
	PLAYERTURN,
	ENEMYTURN,
}

var curBattleState = BattleState.PLAYERTURN

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Enemies.get_children():
		EnemyArray.push_front(i)
	statsLabel.text = statsLabel.text.replace("Chara", playerName)
	hpMaxSprite.size = Vector2(MaxHP, 21)
	hpText.position.x = hpMaxSprite.position.x + hpMaxSprite.size.x + 14
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hpSprite.size = Vector2(global.data["HP"], 21)
	hpText.text = str(global.data["HP"]) + " / " + str(global.data["MaxHP"])
	$boxRect/boxRectCollision/right.position.x = boxRect.size.x - 1.5
	$boxRect/boxRectCollision/bottom.position.y = boxRect.size.y - 1.5
