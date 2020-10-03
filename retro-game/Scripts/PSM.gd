extends "res://Scripts/SM.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states_dict.idle)
	
func _logic(delta):
	parent.handle_input()
	parent.apply_input_movement(delta)
	parent.apply_gravity(delta)
	parent.apply_movement()
	if parent.shooting: parent.shoot()

func _handle_current_state():
	match current_state:
		states_dict.idle: 
			if parent.velocity.x: return states_dict.run 
			elif !parent.is_on_floor(): return states_dict.jump if parent.velocity.y < 0 else states_dict.fall
			
		states_dict.run: 
			if !parent.velocity.x: return states_dict.idle
			elif !parent.is_on_floor(): return states_dict.jump if parent.velocity.y < 0 else states_dict.fall
			
		states_dict.jump: 
			if parent.is_on_floor(): return states_dict.idle
			elif parent.velocity.y > 0: return states_dict.fall
		
		states_dict.fall: 
			if parent.is_on_floor(): return states_dict.idle
			elif parent.velocity.y < 0: return states_dict.jump

	return

func _enter_state(new_state):
	match new_state:
		states_dict.idle: parent.animation_player.play("Idle")
		
		states_dict.run: parent.animation_player.play("Run")
		
		states_dict.jump: 
			#parent.jump.play()
			parent.animation_player.play("Jump")
			
		states_dict.fall: 
			parent.animation_player.play("Fall")
			if [states_dict.idle, states_dict.run].has(old_state): parent.coyote_timer.start()

func _exit_state(old_state):
	match old_state:
		states_dict.fall: 
			if parent.is_on_floor(): parent.double_jump = false
		
		states_dict.run: parent.run_sound.stop()

func _input(event):
	if event.is_action_pressed("ui_up"):
		if parent.is_on_floor() or !parent.coyote_timer.is_stopped():
			parent.coyote_timer.stop()
			parent.apply_jump()
		
		elif !parent.double_jump:
			parent.apply_jump()
			parent.ghost_timer.start()
			parent.ghost_timer_timeout.start()
			parent.double_jump = true
			
		else: parent.jump_buffer_timer.start()
