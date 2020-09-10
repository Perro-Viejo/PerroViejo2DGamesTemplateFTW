extends Panel
signal Language_choosen
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
onready var button: PackedScene = preload('res://src/GUI/Buttons/OptionsToggle.tscn')
onready var options_container: VBoxContainer = find_node('LanguageOptions')
onready var _close: Button = find_node('Close')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready()->void:
	for language in Settings.Language_list:
		var new_btn: Button = button.instance()
		var language_str: String = Settings.Language_dictionary[language]
		new_btn.text = language
		new_btn.connect('pressed', self, '_on_button_pressed', [language])
		
		if language_str == Settings.Language:
			new_btn.pressed = true

		options_container.add_child(new_btn)
	options_container.move_child(_close, options_container.get_child_count())

	# Reasignar focas
	options_container.get_child(0).focus_previous = _close.get_path()
	options_container.get_child(0).focus_neighbour_top = _close.get_path()
	_close.focus_next = options_container.get_child(0).get_path()
	_close.focus_neighbour_bottom = options_container.get_child(0).get_path()

func focus_active() -> void:
	_get_current_language_btn().grab_focus()

func _on_button_pressed(value:String)->void:
	_uncheck_all()
	Settings.Language = Settings.Language_dictionary[value] #Settings will emit ReTranslate
	_get_current_language_btn().pressed = true

func _get_current_language_btn() -> CheckButton:
	var match_btn: CheckButton = null
	for btn in options_container.get_children():
		if Settings.Language_dictionary.has(btn.text) \
			and Settings.Language_dictionary[btn.text] == Settings.Language:
			match_btn = btn
			break
	return match_btn

func _uncheck_all() -> void:
	for btn in options_container.get_children():
		btn.pressed = false
