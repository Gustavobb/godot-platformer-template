extends Node
class_name StateMachine

var current_state setget set_state
var old_state
var states_dict = {} 

onready var parent = get_parent()

func _ready():
	pass

func _physics_process(delta):
	_logic(delta)
	var state = _handle_current_state()
	if state != null: set_state(state)
	
func _logic(_delta):
	pass

func _handle_current_state():
	return

func _enter_state(_new_state):
	pass

func _exit_state(_old_state):
	pass

func add_state(state):
	states_dict[state] = states_dict.size()
	
func set_state(new_state):
	old_state = current_state
	current_state = new_state
	_enter_state(current_state)
	_exit_state(old_state)
