extends Node
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
const DEV_MODE := 'DEV_MODE'
const CURRENT_SCENE := 'CURRENT_SCENE'
const DIALOGS := 'DIALOGS'

enum BAITS {NADA, GUSANO, SANGRE}

var _data := {}
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func get_data(key: String):
	return _data[key] if _data.has(key) else null


func set_data(key: String, data) -> void:
	_data[key] = data


# Suma un valor entero al dato identificado con 'key' en la lista de datos.
func data_sumi(key: String, value: int) -> void:
	if _data.has(key) and _data[key] is int:
		_data[key] += value
	else:
		_error_no_key_no_type(key, 'int')


# Suma un valor flotante al dato identificado con 'key' en la lista de datos.
func data_sumf(key: String, value: float) -> void:
	if _data.has(key) and _data[key] is int:
		_data[key] += value
	else:
		_error_no_key_no_type(key, 'float')


func push_data(key: String, value) -> void:
	if _data.has(key):
		(_data[key] as Array).append(value)
	else:
		_data[key] = [value]


func _error_no_key_no_type(key: String, type: String) -> void:
	print('ERROR: %s no existe o no es %s' % [key, type])


func get_data_size(key: String) -> int:
	return (get_data(key) as Array).size()
