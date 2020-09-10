extends CanvasLayer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready()->void:
	#show main section and hide controls
	GuiEvent.connect('Options', self, 'on_show_options')
	SectionEvent.Controls = false

func on_show_options(value:bool)->void:
	AudioEvent.emit_signal('play_requested', 'UI', 'Gen_Button')
	$Control.visible = value
	SectionEvent.Controls = false


