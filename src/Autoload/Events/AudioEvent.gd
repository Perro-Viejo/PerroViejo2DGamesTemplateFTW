extends Node

signal music_requested(stream) # Sólo mientras tanto
signal music_stoped() # Sólo mientras tanto
signal dx_requested(character, emotion)
signal play_requested(source, sound, position)
signal stop_requested(source, sound)
signal pause_requested(source, sound)
signal stream_finished(source, sound)
signal change_volume(source, sound, volume)
signal position_amb(source, sound, position, max_distance)
