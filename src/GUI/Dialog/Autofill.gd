class_name Autofill
extends Label
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
signal fill_done

export(float) var animation_time = 0.01
export(int) var character_speed = 2
export(bool) var animate_on_set_text = true
export(bool) var animate_on_start = false
export(bool) var typing = true
export(float) var disappear_wait = 3.0

var default_position
var default_size

var _current_disappear: = 0.0
var _chars: = []
var _count: = 0
var _text: String
var _forced_update := false
var _is_disappearing := false
var _time_to_dissapear := 0.0
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	hide()

	default_position = get_position()
	default_size = get_size()

	$Timer.set_wait_time(animation_time)
	$Timer.connect('timeout', self, '_write_character')


func _process(delta: float) -> void:
	if _forced_update:
		_forced_update = false
		rect_position.x = 160 - (rect_size.x / 2)

	if _is_disappearing:
		_time_to_dissapear -= delta
		if _time_to_dissapear < 0:
			_hide_and_emit()


func start_animation():
	if not is_inside_tree(): return
	if has_node('Timer'): $Timer.start()
	typing = true


func set_text(text):
	set_defaults()

	if text != '':
		_text = text
		AudioEvent.emit_signal('play_requested', 'UI', 'Dialogue')
		if animate_on_set_text:
			start_animation()
		else:
			.set_text(text)
	else:
		_text = ''
		_count = 0
		_current_disappear = 0.0
		_is_disappearing = false
		_time_to_dissapear = 0.0

		hide()


func set_defaults():
	self.text = ''
	rect_size = default_size
	_is_disappearing = false
	_time_to_dissapear = 0.0

	$Timer.stop()


func stop(auto_complete: bool = true) -> void:
	# Ignorar el skip si el texto ya está en su estado final
	if not visible: return

	if text == _text:
		_hide_and_emit()
		return

	if auto_complete:
		text = _text
		_forced_update = true

	_finish()
	_disappear()


func set_disappear_time(time := 0.0) -> void:
	_current_disappear = time


func set_text_color(color: Color) -> void:
	add_color_override("font_color", color)


func finish_and_hide() -> void:
	_finish()
	_hide()


func _write_character():
	if text.length() < _text.length():
		text += _text[_count]
		_count += 1
		# Reposicionar el elemento porque el texto va creciendo
		rect_position.x = 160 - (rect_size.x / 2)
	else:
		# El texto ya tiene todos los caracteres
		_finish()
		_disappear()


# Detiene el temporizador y resetea el contador de caracteres escritos a cero
# pues el texto ya se está mostrando completo.
func _finish() -> void:
	_count = 0
	$Timer.stop()

	if typing:
		typing = false


func _disappear(forced_wait := 0.0) -> void:
	if _current_disappear > 0:
		_time_to_dissapear = _current_disappear
	elif _current_disappear == 0.0:
		_time_to_dissapear = disappear_wait
	else:
		# El texto no desaparecerá sólo, sino que se espera una señal que lo
		# haga desaparecer
		HudEvent.emit_signal('continue_requested')
		return

	_is_disappearing = true


func _hide() -> void:
	set_text('')


func _hide_and_emit() -> void:
	if visible and not typing:
		_hide()
		emit_signal('fill_done')
