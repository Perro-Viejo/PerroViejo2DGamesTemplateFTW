extends CheckButton
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(Color) var highligth
export(Color) var normal
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	self_modulate = normal
	connect('focus_entered', self, 'set_self_modulate', [highligth])
	connect('focus_exited', self, 'set_self_modulate', [normal])
