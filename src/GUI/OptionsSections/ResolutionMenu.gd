extends Panel
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(Color) var highlight

onready var _scale_down: TextureButton = find_node('ScaleDown')
onready var _scale_down_label: Label = _scale_down.get_node('Label')
onready var _scale_up: TextureButton = find_node('ScaleUp')
onready var _scale_up_label: Label = _scale_up.get_node('Label')
onready var _scale_text: Label = find_node('Scale')
onready var _dflt_color: Color = _scale_text.get_color('font_color')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	_scale_down_label.text = '-'
	_update_focus(false, null)
	
	# Conectarse a señales de los hijos del papá
	_scale_down.connect('pressed', self, '_change_scale', [-1])
	_scale_up.connect('pressed', self, '_change_scale')
	_scale_down.connect(
		'focus_entered', self, '_update_focus', [true, _scale_down_label]
	)
	_scale_up.connect(
		'focus_entered', self, '_update_focus', [true, _scale_up_label]
	)
	_scale_down.connect(
		'focus_exited', self, '_update_focus', [false, _scale_down_label]
	)
	_scale_up.connect(
		'focus_exited', self, '_update_focus', [false, _scale_up_label]
	)

func _change_scale(dir := 1) -> void:
	AudioEvent.emit_signal('play_requested', 'UI', 'Gen_Button')
	Settings.Scale += dir
	_scale_text.text = '%s (x%d)' % [tr('SCALE'), Settings.Scale]

func _update_focus(focus: bool, txt: Label) -> void:
	_scale_text.add_color_override(
		'font_color', highlight if focus else _dflt_color
	)
	if txt:
		txt.add_color_override(
			'font_color', highlight if focus else _dflt_color
		)
	else:
		_scale_down_label.add_color_override(
			'font_color', highlight if focus else _dflt_color
		)
		_scale_up_label.add_color_override(
			'font_color', highlight if focus else _dflt_color
		)
