extends Node

signal character_spoke(character, message, time_to_disappear, emotion)
signal dialog_event(playing, countdown, duration)
signal dialog_requested(dialog_name)
signal dialog_continued
signal dialog_skipped
signal dialog_finished
signal dialog_paused
signal line_triggered(character_name, text, time, emotion)
signal dialog_menu_requested(options)
signal dialog_option_clicked(option_dic)
signal dialog_menu_updated(cfg)
signal dialog
