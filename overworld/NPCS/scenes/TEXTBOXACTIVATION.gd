extends Area2D

var player = null
var Textbox = load("res://dialogue/Textbox.tscn")
var isTalking = true
var TextboxInst = null
var playerCamPosition = Vector2.ZERO

enum ScreenPositionList{
	AUTO,
	TOP,
	BOTTOM,
}

@export var dialogue = "test"
@export var UseButton = true
@export var OneTimeOnly = false
@export var ScreenPosition = ScreenPositionList.AUTO
@export var OverworldSprite = AnimatedSprite2D.new()

func _process(delta):
	if player != null:
		if UseButton and player.menu.menuOpen == false:
			if Input.is_action_just_pressed("interact") and global.TextboxExists == false:
				global.CreateTextBox(dialogue,self)
		else:
			if global.TextboxExists == false and player.menu.menuOpen == false:
				global.CreateTextBox(dialogue,self)
	
	if TextboxInst != null:
		if !TextboxInst.line3done:
			OverworldSprite.play("talk")
		else:
			OverworldSprite.play("idle")

func _on_area_entered(area):
	if UseButton:
		if area.is_in_group("PlayerInteractionRange"):
			player = area.get_parent()

func _on_area_exited(area):
	if UseButton:
		if area.is_in_group("PlayerInteractionRange"):
			player = null

func _on_body_entered(body):
	if !UseButton:
		if body.is_in_group("OverworldPlayer"):
			player = body

func _on_body_exited(body):
	if !UseButton:
		if body.is_in_group("OverworldPlayer"):
			player = null
