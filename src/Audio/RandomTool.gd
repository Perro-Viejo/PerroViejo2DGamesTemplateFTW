extends Node2D
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var index_sound = -1
var select_sound
var canplay

export (float) var weight = 100

export (float) var volume = 0
export (float) var Pitch = 0

export (bool) var random_volume
export (float) var min_volume
export (float) var max_volume

export (bool) var random_pitch
export (float) var min_pitch
export (float) var max_pitch

var avvolume
var avPitch
var dflt_values: Dictionary
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	Pitch = Pitch/24

	# Crear el diccionario de valores por defecto para los efectos de sonido
	# hijos
	for sfx in get_children():
		dflt_values[sfx.name] = {
			'pitch': sfx.get_pitch_scale(),
			'volume': sfx.get_volume_db()
		}


func play():
	randomize()

	index_sound = randi()%get_child_count()
	select_sound = get_child(index_sound)
	avvolume = dflt_values[select_sound.name].volume + volume
#
	if random_volume == true:
		randomizeVol(avvolume, min_volume, max_volume)
	else:
		select_sound.set_volume_db(avvolume)
#
#
	if randi()%100 <= weight:
		select_sound.play()
		if random_pitch == true:
			randomizePitch(dflt_values[select_sound.name].pitch, min_pitch, max_pitch)
		else:
			select_sound.set_pitch_scale(dflt_values[select_sound.name].pitch + Pitch)


func stop():
	if select_sound:
		select_sound.stop()
	else:
		pass


func randomizeVol(_volume, _min_volume, _max_volume):
	var rnd_vol = (rand_range( _min_volume, (_max_volume + 1)))
	select_sound.set_volume_db(_volume + rnd_vol)


func randomizePitch(_pitch, _min_pitch, _max_pitch):
		var rnd_pitch = (rand_range( _min_pitch + 1, (_max_pitch + 1)) / 24)
		if (_pitch + rnd_pitch > 0):
			select_sound.set_pitch_scale((_pitch + rnd_pitch))

