extends KinematicBody2D

signal died()

export(Color) var dialog_color
export(int) var health = 0
export(bool) var immortal = false

var _in_dialog := false
export(int) var max_health = 0

onready var inventory = $Inventory
onready var state_machine = $StateMachine

# Called when the node enters the scene tree for the first time.
func speak(text := '', time_to_disappear := 0):
	DialogEvent.emit_signal('character_spoke', self, text, time_to_disappear)

func spoke():
	if _in_dialog:
		DialogEvent.emit_signal('dialog_continued')

func _should_speak(character_name, text, time, emotion) -> void:
	if name.to_lower() == character_name:
		speak(text, time)
		AudioEvent.emit_signal('dx_requested' , character_name, emotion)
