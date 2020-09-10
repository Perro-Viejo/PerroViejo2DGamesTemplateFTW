extends CanvasLayer

export (String, FILE, "*.tscn") var Main_Menu: String

func _ready()->void:
	GuiEvent.connect("Paused", self, "on_show_paused")
	GuiEvent.connect("Options", self, "on_show_options")
	SectionEvent.Paused = false
	#localization
	Settings.connect("ReTranslate", self, "retranslate")

func on_show_paused(value:bool)->void:
	#Signals allow each module have it's own response logic
	$Control.visible = value
	get_tree().paused = value

func on_show_options(value:bool)->void:
	AudioEvent.emit_signal('play_requested', 'UI', 'Gen_Button')
	if !SectionEvent.MainMenu:
		$Control.visible = !value

func _on_Resume_pressed():
	AudioEvent.emit_signal('play_requested', 'UI', 'Gen_Button')
	SectionEvent.Paused = false #setget triggers signal and responding to it hide GUI

func _on_Restart_pressed():
	GuiEvent.emit_signal('play_requested', 'UI', 'Gen_Button')
	GuiEvent.emit_signal("Restart")
	SectionEvent.Paused = false #setget triggers signal and responding to it hide GUI

func _on_Options_pressed():
	AudioEvent.emit_signal('play_requested', 'UI', 'Gen_Button')
	SectionEvent.Options = true

func _on_MainMenu_pressed():
	AudioEvent.emit_signal('play_requested', 'UI', 'Gen_Button')
	GuiEvent.emit_signal("ChangeScene", Main_Menu)
	SectionEvent.Paused = false

func _on_Exit_pressed():
	AudioEvent.emit_signal('play_requested', 'UI', 'Gen_Button')
	GuiEvent.emit_signal("Exit")

func retranslate()->void:
	find_node("Resume").text = tr("RESUME")
	find_node("Restart").text = tr("RESTART")
	find_node("Options").text = tr("OPTIONS")
	find_node("MainMenu").text = tr("MAIN_MENU")
	find_node("Exit").text = tr("EXIT")









