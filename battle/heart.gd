extends CharacterBody2D

enum dir{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var state = 0
var Battle = null

var scroll = 0

const SPEED = 150.0

func _ready():
	Battle = get_parent()

func _physics_process(delta):
	if Battle.curBattleState == Battle.BattleState.PLAYERTURN:
		Menu()
	if Battle.curBattleState == Battle.BattleState.ENEMYTURN:
		Movement()

func Movement():
	var HorisDir = Input.get_axis("left", "right")
	if HorisDir:
		velocity.x = HorisDir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var VerticDir = Input.get_axis("up", "down")
	if VerticDir:
		velocity.y = VerticDir * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func Menu():
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
		position.x = Battle.fightSprite.position.x - 38
		Battle.fightSprite.frame = 1
	else:
		Battle.fightSprite.frame = 0
	if scroll == 1:
		position.x = Battle.actSprite.position.x - 38
		Battle.actSprite.frame = 1
	else:
		Battle.actSprite.frame = 0
	if scroll == 2:
		position.x = Battle.itemSprite.position.x - 38
		Battle.itemSprite.frame = 1
	else:
		Battle.itemSprite.frame = 0
	if scroll == 3:
		position.x = Battle.mercySprite.position.x - 38
		Battle.mercySprite.frame = 1
	else:
		Battle.mercySprite.frame = 0
