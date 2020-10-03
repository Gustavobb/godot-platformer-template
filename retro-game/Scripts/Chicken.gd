extends KinematicBody2D

export(int) var ACCELERATION = 1000
export(int) var MAX_SPEED = 30
export(int) var FRICTION = 400
export(int) var GRAVITY = 10
const FLOOR = Vector2(0, -1)

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var timer = $Timer
onready var wander_sound = $Wander
onready var rays_hor = $RaysHorizontal
onready var rays_ver = $RaysVertical

var velocity = Vector2.ZERO
var input_velocity = Vector2.ZERO
var input_velocity_cache = Vector2.ZERO
var BODY_MASS = 150;
var time_wander = randi() % 2 + 1
var pocoo_sound_time = 0

var wander = false

func _ready():
	timer.start(time_wander)
	
func _start_wander():
	input_velocity.x = - 1 if input_velocity_cache.x == 1 else 1
	sprite.flip_h = true if input_velocity.x > 0 else false
	wander_sound.play(pocoo_sound_time)
	timer.start(time_wander)

func _stop_wander():
	input_velocity_cache.x = input_velocity.x
	input_velocity.x = 0
	wander_sound.stop()
	pocoo_sound_time = 0 if wander_sound.get_playback_position() > 15 else wander_sound.get_playback_position()
	timer.start(time_wander)
	
func apply_gravity(delta):
	velocity.y += GRAVITY * BODY_MASS * delta

func apply_input_movement(delta):
	if input_velocity.x:
		if _any_horizontal_rays_colliding() or _any_vertical_rays_colliding(): 
			wander = false
			_stop_wander()
			
		velocity.x += input_velocity.x * ACCELERATION * delta
		velocity.x = clamp(velocity.x, - MAX_SPEED, MAX_SPEED)
		
	elif velocity.x: velocity = velocity.move_toward(Vector2(0, velocity.y), FRICTION * delta)

func _any_horizontal_rays_colliding():
	for ray in rays_hor.get_children():
		if ray.is_colliding(): return true
	
	return false

func _any_vertical_rays_colliding():
	for ray in rays_ver.get_children():
		if !ray.is_colliding(): return true
	
	return false
	
func apply_movement():
	velocity = move_and_slide(velocity, FLOOR)

func _on_Timer_timeout():
	wander = !wander
	var _resp = _start_wander() if wander else _stop_wander()
	
