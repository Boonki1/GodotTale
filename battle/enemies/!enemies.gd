extends Node2D

class_name Enemy

var Name = "Froggit"
var MaxHP = 0
var HP = MaxHP

enum enemyTypeList{
	FirstFroggit,
	Froggit,
	Whimsun,
}

@export var enemyType = enemyTypeList.Froggit

# Called when the node enters the scene tree for the first time.
func _ready():
	match enemyType:
		enemyTypeList.FirstFroggit:
			Name = "Froggit"
			MaxHP = 20
		
		enemyTypeList.Froggit:
			Name = "Froggit"
			MaxHP = 30
		
		enemyTypeList.Whimsun:
			Name = "Whimsun"
			MaxHP = 10
	
	HP = MaxHP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
