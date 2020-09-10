extends Node

var MainMenu:bool = false setget set_main_menu
var Options:bool = false setget set_options
var Controls:bool = false setget set_controls
var Languages:bool = false setget set_languages
var Paused: bool = false setget set_paused
var dialog: bool = false

func set_main_menu(value:bool)->void:
	MainMenu = value
	GuiEvent.emit_signal("MainMenu", MainMenu)

func set_options(value:bool)->void:
	Options = value
	GuiEvent.emit_signal("Options", Options)

func set_controls(value:bool)->void:
	Controls = value
	GuiEvent.emit_signal("Controls", Controls)

func set_languages(value:bool)->void:
	Languages = value
	GuiEvent.emit_signal("Languages", Languages)

func set_paused(value:bool)->void:
	Paused = value
	GuiEvent.emit_signal("Paused", Paused)
