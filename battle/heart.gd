extends CharacterBody2D

enum dir{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var state = 0
var Battle = null

const SPEED = 150.0

func _ready():
	Battle = get_parent()

func _physics_process(delta):
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
