tool
class_name Switch
extends Area2D

export(int) var carbs = 2
export(Texture) var img_off setget set_sprite_off_texture
export(Texture) var img_on setget set_sprite_on_texture
export(String) var dialog = ''
export(String) var id=''

# ░░░░ Funciones ░░░░
func _ready() -> void:
	connect('area_entered', self, '_check_collision_in')
	connect('area_exited', self, '_check_collision_out')

func set_sprite_off_texture(tex: Texture) -> void:
	img_off = tex
	$OFF.texture = img_off

func set_sprite_on_texture(tex: Texture) -> void:
	img_on = tex
	$ON.texture = img_on
	
func _check_collision_in(area: Node2D, grab: bool = false) -> void:
	if area.get_class() != 'Pickable': return
	$ON.visible = true
	$OFF.visible = false
	SwitchEvent.emit_signal('switch_on', self.id)
	
func _check_collision_out(area: Node2D, grab: bool = false) -> void:
	if area.get_class() != 'Pickable': return
	$ON.visible = false
	$OFF.visible = true
	SwitchEvent.emit_signal('switch_off', self.id)
