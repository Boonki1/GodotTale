extends CharacterBody2D

class_name OverworldPlayer

@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var node_2d = $Camera2D/CanvasLayer/Node2D
@onready var menu = $menu

enum dir{
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var startDir = dir.DOWN

@export var roomSize = Vector2.ONE * 99999

var LockedDir = null

const SPEED = 100.0

var canMove = true

func _ready():
	camera.limit_right = roomSize.x
	camera.limit_bottom = roomSize.y
	camera.limit_top = 0
	camera.limit_left = 0
	
	if global.entryPoint != null:
		position = global.entryPoint
	
	if startDir == dir.DOWN:
		sprite.play("down")
	
	if startDir == dir.UP:
		sprite.play("up")
	
	if startDir == dir.LEFT:
		sprite.play("left")
	
	if startDir == dir.RIGHT:
		sprite.play("right")

func _physics_process(delta):
	if global.MidTransition:
		canMove = false
	
	if canMove:
		Movement()

func _process(delta):
	MoveAnimations()

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

func MoveAnimations():
	if canMove:
		if Input.get_axis("left", "right") == -1 and LockedDir == null:
			sprite.play("left")
			LockedDir = dir.LEFT
		
		if Input.get_axis("left", "right") == 1 and LockedDir == null:
			sprite.play("right")
			LockedDir = dir.RIGHT
		
		if Input.get_axis("up", "down") == -1 and LockedDir == null:
			sprite.play("up")
			LockedDir = dir.UP
		
		if Input.get_axis("up", "down") == 1 and LockedDir == null:
			sprite.play("down")
			LockedDir = dir.DOWN
	
	if velocity == Vector2.ZERO:
		LockedDir = null
		sprite.frame = 0
	
	#When you move a certain direction your sprite will face that direction until you stop pressing the button
	if LockedDir == dir.LEFT and Input.is_action_just_released("left"):
		LockedDir = null
	
	if LockedDir == dir.RIGHT and Input.is_action_just_released("right"):
		LockedDir = null
	
	if LockedDir == dir.UP and Input.is_action_just_released("up"):
		LockedDir = null
	
	if LockedDir == dir.DOWN and Input.is_action_just_released("down"):
		LockedDir = null
	
	if !canMove:
		velocity = Vector2.ZERO
