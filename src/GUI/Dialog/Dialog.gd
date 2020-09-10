class_name Dialog
extends Control
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var _forced_update := false
var _current_character: Node2D = null
# Cosas del Godot Dialog System ---- {
var _story_reader_class := load('res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd')
var _stories_es = null
var _did := 0
var _nid := 0
var _final_nid := 0
var _options_nid := 0
var _in_dialog_with_options := false
var _wait := false
var _selected_slot := -1
var _current_options := ''
# } ----

onready var _story_reader: EXP_StoryReader = _story_reader_class.new()
onready var _dialog_menu: DialogMenu = find_node('DialogMenu')
onready var _autofill: Autofill = find_node('Autofill')
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	# Configurar el Data manager para que vaya guardando información de los
	# diálogos (eventualmente esto se guardará en un archivo así como se guardan
	# las opciones de configuración)
	Data.set_data(Data.DIALOGS, {})
	
	_dialog_menu.hide()

	match TranslationServer.get_locale():
		_:
			#_story_reader.read(_stories_es)
			pass

	# Conectarse a eventos de los retoños
	_autofill.connect('fill_done', self, '_autofill_completed')

	# Conectarse a eventos de la vida real
	DialogEvent.connect('dialog_requested', self, '_play_dialog')
	DialogEvent.connect('dialog_continued', self, '_continue_dialog')
	DialogEvent.connect('character_spoke', self, '_on_character_spoke')
	DialogEvent.connect('dialog_option_clicked', self, '_option_clicked')
	HudEvent.connect('hud_accept_pressed', _autofill, 'stop')


func _play_dialog(dialog_name: String) -> void:
	_did = _story_reader.get_did_via_record_name(dialog_name)
	_nid = _story_reader.get_nid_via_exact_text(_did, 'start')
	_final_nid = _story_reader.get_nid_via_exact_text(_did, 'end')

	if _story_reader.get_nid_via_exact_text(_did, 'return') > 0:
		_in_dialog_with_options = true
		PlayerEvent.emit_signal('control_toggled')

	_continue_dialog()


func _continue_dialog(slot := 0) -> void:
	# Para la forma de diálogo anterior al plugin ------------------------------
	if _did == 0:
		_finish_dialog()
		return
	# --------------------------------------------------------------------------

	if _autofill.is_visible(): return

	if _selected_slot < 0 and _nid == _options_nid:
		# Para mostrar el menú de opciones de diálogo al final de la línea
		# que este posiblemente dispare
		_dialog_menu.show_options()
		return

	_next_dialog_line(max(0, slot))

	if _nid == _final_nid:
		_finish_dialog()
	else:
		_play_dialog_line()


func _next_dialog_line(slot := 0) -> void:
	_nid = _story_reader.get_nid_from_slot(_did, _nid, slot)

func _play_dialog_line() -> void:
	var line_txt := _story_reader.get_text(_did, _nid)

	if _nid == _final_nid:
		_finish_dialog()
		return

	if _in_dialog_with_options:
		# Verificar si el texto del nodo es la palabra clave para volver al menú
		# de opciones activo
		_selected_slot = -1
		if line_txt == 'return':
			_nid = _options_nid
			_dialog_menu.show_options()
			return

	var line_dic: Dictionary = JSON.parse(line_txt).result

	# ----[ el actor ]----------------------------------------------------------
	# El actor por defecto será el player
	var actor := 'player'
	if line_dic.has('actor'):
		actor = line_dic.actor as String

	# ----[ la línea ]----------------------------------------------------------
	var line := ''
	if line_dic.has('line'):
		line = tr(('dlg_%d_%d_%s' % [_did, _nid, actor]).to_upper())

	# ----[ la emoción ]----------------------------------------------------------
	var emotion := ''
	if line_dic.has('emotion'):
		emotion = line_dic.emotion as String

	_wait = false
	if line_dic.has('wait'):
		_wait = true

	# Por defecto se asume que el diálogo continuará con base en una acción del
	# jugador
	var time_to_disappear := -1.0
	if line_dic.has('time'):
		time_to_disappear = line_dic.time as float

	# ▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮ ON START (event) ▮▮▮▮
	if line_dic.has('on_start'):
		var on_start_dict = line_dic.on_start
		if on_start_dict.params.size() == 1:
			get_node("/root/"+on_start_dict.type).emit_signal(on_start_dict.event, on_start_dict.params[0])
		else:
			get_node("/root/"+on_start_dict.type).emit_signal(on_start_dict.event)

	# ▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮ OPCIONES ▮▮▮▮
	if line_dic.has('options'):
		_options_nid = _nid
		_selected_slot = -1

		var options_state := {}
		var dialogs_state: Dictionary = Data.get_data(Data.DIALOGS)
		if dialogs_state.has(_get_options_id()):
			options_state = dialogs_state[_get_options_id()]

		var id := 0
		for opt in line_dic.options:
			opt.id = id
			opt.tr_code = 'dlg_%d_%d_%s_opt_%d' % [_did, _nid, actor, id]

			if options_state:
				opt.show = options_state[opt.id]

			if not opt.has('actor'):
				opt.actor = 'player'
			if not opt.has('time'):
				opt.time = 3
			if not opt.has('emotion'):
				opt.emotion = ''

			id += 1

		_dialog_menu.create_options(line_dic.options)

	# ▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮▮ APAGAR OPCIONES ▮▮▮▮
	if line_dic.has('off') or line_dic.has('on'):
		# En este nodo se apagarán opciones
		var cfg := {}

		if line_dic.has('off'):
			for opt in line_dic.off:
				cfg[String(opt)] = false

		if line_dic.has('on'):
			for opt in line_dic.on:
				cfg[String(opt)] = true

		_dialog_menu.update_options(cfg)

	# Lo último que se hace es disparar la línea de diálogo
	
	if line:
		DialogEvent.emit_signal(
			'line_triggered',
			actor.to_lower(),
			line,
			time_to_disappear,
			emotion
		)


func _on_character_spoke(
		character: Node2D = null, message :String = '', time_to_disappear := 0.0
	):
	if _autofill.typing:
		_autofill.stop()
		if not is_inside_tree(): return
		yield(get_tree().create_timer(.3), 'timeout')

	# Definir el color del texto
	var text_color: Color = Color('#222323')
	if character and character.get('dialog_color'):
		text_color = character.dialog_color
	_autofill.set_text_color(text_color)

	if _current_character \
		and _current_character.is_inside_tree() \
		and _current_character.has_method('spoke'):
		# Notificar al personaje que ya terminó de hablar
		_current_character.spoke()

	if message != '':
		_current_character = character

		_autofill.set_text(message)
		_autofill.set_disappear_time(time_to_disappear)
		_autofill.show()
		HudEvent.emit_signal('talking_bubble_requested', _current_character)
	else:
		_current_character = null
		_autofill.finish_and_hide()
		HudEvent.emit_signal('talking_bubble_requested')


func _option_clicked(opt: Dictionary) -> void:
	_selected_slot = opt.id

	if opt.has('say') and opt.say:
		DialogEvent.emit_signal(
			'line_triggered',
			(opt.actor as String).to_lower(),
			opt.line as String,
			opt.time,
			opt.emotion as String
		)
	else:
		_continue_dialog(_selected_slot)


func _autofill_completed() -> void:
	if _current_character:
		HudEvent.emit_signal('talking_bubble_requested')

		var character_copy = _current_character
		_current_character = null

		if character_copy.has_method('spoke'):
			character_copy.spoke()
		character_copy = null

	if _wait:
		# TODO: Puede haber una mejor manera de hacer esto, cosa que la alternación
		# del control del PC suceda en un único lugar dentro del código de esta
		# clase
		PlayerEvent.emit_signal('control_toggled')
		DialogEvent.emit_signal('dialog_paused')
		return

	if not _in_dialog_with_options:
		_continue_dialog(_selected_slot)
	elif not _dialog_menu.visible:
		_continue_dialog(_selected_slot)


func _finish_dialog() -> void:
	# Para la forma de diálogo anterior al plugin ------------------------------
	if _final_nid == 0: return
	# --------------------------------------------------------------------------
	
	if _in_dialog_with_options:
		var options_id := _get_options_id()
		var dialogs_state: Dictionary = Data.get_data(Data.DIALOGS)
		var options_state := {}

		if dialogs_state.has(options_id):
			options_state = dialogs_state[options_id]

		for opt in _dialog_menu.current_options:
			options_state[opt.id] = opt.show
		
		dialogs_state[options_id] = options_state
		Data.set_data(Data.DIALOGS, dialogs_state)

	_did = 0
	_nid = 0
	_final_nid = 0

	if _in_dialog_with_options:
		_options_nid = 0
		_in_dialog_with_options = false
		_dialog_menu.remove_options()
		PlayerEvent.emit_signal('control_toggled')

	DialogEvent.emit_signal('dialog_finished')


func _get_options_id() -> String:
	return '%s-%s' % [_did, _options_nid]
