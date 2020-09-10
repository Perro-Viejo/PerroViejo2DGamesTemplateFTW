extends GridContainer
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var _current_target: Node

onready var _original_parent: Control = get_parent()
onready var _label: Label = find_node('Label')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	hide()
	HudEvent.connect('name_bubble_requested', self, '_place_bubble')


func _process(delta):
	if _current_target:
		rect_global_position = Utils.get_screen_coords_for(_current_target)
		rect_position.x -= rect_size.x / 2
		rect_position.y -= rect_size.y + 8


func _place_bubble(target: Node2D = null, text: String = '') -> void:
	if target:
		_label.text = text
		_current_target = target
		show()
	else:
		_label.text = ''
		_current_target = null
		hide()
