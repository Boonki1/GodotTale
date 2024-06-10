extends Area2D

var player = null
@export var scene = "test"
@export var entryPoint = Vector2.ZERO

func _process(delta):
	if player != null:
		global.entryPoint = entryPoint
		global.RoomTransition(scene)

func _on_body_entered(body):
	if body.is_in_group("OverworldPlayer"):
		player = body

func _on_body_exited(body):
	if body.is_in_group("OverworldPlayer"):
		player = null
