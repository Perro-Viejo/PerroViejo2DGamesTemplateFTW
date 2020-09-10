extends "res://src/StateMachine/State.gd"

func _ready() -> void:
	pass
	
func enter(msg: Dictionary = {}) -> void:
	.enter(msg)

func play_animation() -> bool:
	$AnimatedSprite.play('Idle')
	return true

func exit() -> void:
	.exit()
