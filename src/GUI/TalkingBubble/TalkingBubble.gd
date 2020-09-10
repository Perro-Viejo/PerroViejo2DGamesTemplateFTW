extends Control
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
export var y_offset := 16.0

var _wave := '[wave amp=14 freq=8].[/wave][wave amp=14 freq=9].[/wave][wave amp=14 freq=10].[/wave]'
var _showing := false
var _dflt_pos: Vector2
var _trgt_pos: Vector2
var _current_target: Node
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready() -> void:
	_dflt_pos = self.rect_position
	_trgt_pos = Vector2(_dflt_pos.x, _dflt_pos.y - y_offset)
	modulate.a = 0

	# Conectarse a señales de hijos
	$Tween.connect('tween_completed', self, '_on_Tween_completed')
	
	# Conectarse a señales del cielo de las señales
	HudEvent.connect('talking_bubble_requested', self, '_place_bubble')

	hide()


func _process(delta):
	if _current_target:
		_dflt_pos = Utils.get_screen_coords_for(_current_target)
		_trgt_pos = Vector2(_dflt_pos.x, _dflt_pos.y - y_offset)
		_trgt_pos.x -= (rect_size.x / 2) + 8
		_trgt_pos.y -= rect_size.y / 2
		rect_global_position = _trgt_pos


func appear(_show := true) -> void:
	if _showing == _show: return
	_showing = _show
	if _show:
		show()
		$Tween.remove_all()
		$Sprite/RichTextLabel.clear()
		$Sprite/RichTextLabel.append_bbcode(_wave)

	$Tween.interpolate_property(
		$Sprite,
		'rect_position:y',
		0 if _show else -8,
		-8 if _show else 0,
		0.4 if _show else 0.2,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		self,
		'modulate:a',
		0 if _show else 1,
		1 if _show else 0,
		0.4 if _show else 0.2,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
	$Tween.start()


func _on_Tween_completed(obj: Object, key: NodePath) -> void:
	if not _showing and modulate.a == 0.0:
		$Sprite/RichTextLabel.clear()
		hide()


func _place_bubble(target: Node = null) -> void:
	if target:
		if _showing: return

		_current_target = target
		rect_global_position = Utils.get_screen_coords_for(_current_target)
		_dflt_pos = rect_global_position
		_trgt_pos = Vector2(_dflt_pos.x, _dflt_pos.y - y_offset)
		_trgt_pos.x -= rect_size.x / 2
		_trgt_pos.y -= rect_size.y / 2
		appear()
	else:
		_current_target = null
		appear(false)

