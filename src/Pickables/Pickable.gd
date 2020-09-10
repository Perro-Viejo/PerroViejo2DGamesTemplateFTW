tool
class_name Pickable
extends Area2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export(bool) var is_good = true
export(int) var carbs = 2
export(Texture) var img setget set_sprite_texture
export(String) var on_free = ''
export(String) var tr_code = ''
export(String) var character = ''
export(String) var dialog = ''

var being_grabbed: bool = false setget set_being_grabbed

var _hides: Area2D

onready var _bubble_name := tr('P_' + (tr_code if tr_code else name).to_upper())
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
#	$Bubble/Label.text = 'P_' + (tr_code if tr_code != '' else name).to_upper()

	connect('area_entered', self, '_check_collision', [ true ])
	connect('area_exited', self, '_check_collision')
	
	if character:
		DialogEvent.connect('line_triggered', self, '_should_speak')

	# Si el objeto tiene otro Pickable por dentro, ocultarlo. La idea es que ese
	# que es el hijo sólo se haga visible cuando el jugador agarre el contenedor
	for child in get_children():
		if child.is_in_group('Pickable'):
			_hides = child as Pickable

			_hides.hide() # ja!
			_hides.toggle_collision(false)

	hide_interaction()


func set_sprite_texture(tex: Texture) -> void:
	img = tex
	if has_node('Sprite'): $Sprite.texture = img


func set_being_grabbed(new_val: bool) -> void:
	being_grabbed = new_val
	# Hacer que el objeto no se pueda monitorear mientras está siendo cargado
	# por el jugador... así se asegura que si éste lo suelta estándo dentro del
	# área de comilona de elfuegoquequiereconsumiralmundo, detectará "la caída"
	# del objeto y se lo comerá
	monitorable = !new_val

	hide_interaction()

	# Sacar el objeto ocultiño
	if _hides:
		var dup: Pickable = _hides.duplicate() as Pickable
		dup.global_position = global_position
		dup.visible = true
		dup.toggle_collision()
		dup.connect('ready', self, '_hidden_in_tree', [dup])

		get_parent().call_deferred('add_child', dup)

		_hides.queue_free()

		_hides = null


func toggle_collision(enable: bool = true) -> void:
	$CollisionShape2D.disabled = !enable


func _check_collision(area: Node2D, grab: bool = false) -> void:
	if area.name != 'PlayerArea': return

	var player = area.get_parent()

	if player.grabbing: return

	if grab:
		player.node_to_interact = self
	else:
		player.node_to_interact = null


func _should_speak(character_name, text, time, emotion) -> void:
	if character.to_lower() == character_name:
		DialogEvent.emit_signal('character_spoke', self, text, time)
		AudioEvent.emit_signal('dx_requested' , character_name, emotion)


func _hidden_in_tree(dup: Pickable) -> void:
	if dup.character != '':
		pass
	if dup.on_free != '':
		DialogEvent.emit_signal('dialog_requested', dup.on_free)


func hide_interaction() -> void:
	HudEvent.emit_signal('name_bubble_requested')
#	$Bubble.hide()
	$Outline.hide()


func show_interaction() -> void:
	HudEvent.emit_signal('name_bubble_requested', self, _bubble_name)
#	$Bubble.show()
	$Outline.show()

func get_class() -> String:
	return "Pickable"
