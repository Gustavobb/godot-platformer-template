extends "res://Scripts/SM.gd"

func _ready():
	add_state("idle")
	add_state("run")
	call_deferred("set_state", states_dict.idle)

func _logic(delta):
	parent.apply_input_movement(delta)
	parent.apply_gravity(delta)
	parent.apply_movement()

func _handle_current_state():
	match current_state:
		states_dict.idle: 
			if parent.velocity.x: return states_dict.run 
			
		states_dict.run: 
			if !parent.velocity.x: return states_dict.idle

	return

func _enter_state(new_state):
	match new_state:
		states_dict.idle: parent.animation_player.play("Idle")
		
		states_dict.run: parent.animation_player.play("Run")

func _exit_state(_old_state):
	pass
