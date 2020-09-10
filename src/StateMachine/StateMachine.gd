class_name StateMachine
extends Node2D

onready var state: State = null
onready var _current_state_name
onready var _previous_state

var STATES = {}

func _init() -> void:
	add_to_group('state_machine')

func _ready() -> void:
	yield(owner, 'ready')
	
	for child in get_children():
		self.STATES[child.name.to_upper()] = child as State

	state = self.STATES["IDLE"]
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)

func _physics_process(delta: float) -> void:
	state.physics_process(delta)

func transition_to_key(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		print('ERROR: State not found: ' + target_state_path)
		return

	var target_state: = get_node(target_state_path)

	if target_state.has_animation:
		state.exit()

	_previous_state = state.name
	self.state = target_state
	_current_state_name = target_state.name
	state.enter(msg)

func transition_to_state(target_state: State, msg: Dictionary = {}) -> void:
	if target_state.has_animation:
		state.exit()
		state.visible = false
		target_state.visible = true
		self.state = target_state
		_previous_state = state.name	
		_current_state_name = target_state.name
	
	target_state.enter()
	
func set_state(value: State) -> void:
	state = value
