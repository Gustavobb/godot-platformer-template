extends KinematicBody2D

export(int) var ACCELERATION = 1000
export(int) var MAX_SPEED = 120
export(int) var FRICTION = 400
export(int) var GRAVITY = 10
export(int) var JUMP_HEIGHT = -300
const FLOOR = Vector2(0, -1)
const ghost_sprite = preload("res://Player/GhostSprite.tscn")
const bullet_sprite = preload("res://Player/Bullet/Bullet.tscn")

onready var animation_player = $AnimationPlayer
onready var weapon_animation_player = $WeaponPlayer
onready var sprite = $Sprite
onready var shot_sound = $Shot
onready var jump_sound = $Jump
onready var run_sound = $Run
onready var weapon_sprite = $Sprite2
onready var weapon_point = $Sprite2/GunCane
onready var camera_shake = $Camera2D/ScreenShake
onready var coyote_timer = $Coyote
onready var ghost_timer = $GhostTimer
onready var gun_cooldown_timer = $GunCooldown
onready var ghost_timer_timeout = $GhostTimerTimeout
onready var jump_buffer_timer = $JumpBuffer
onready var weapon_pos = weapon_sprite.position

var velocity = Vector2.ZERO
var input_velocity = Vector2.ZERO
var BODY_MASS;

var double_jump = false
var shooting = false
var can_shoot = true

func apply_gravity(delta):
	BODY_MASS = 150
	if velocity.y < 0: BODY_MASS = 100
	velocity.y += GRAVITY * BODY_MASS * delta

func apply_input_movement(delta):
	if input_velocity.x:
		velocity.x += input_velocity.x * ACCELERATION * delta
		velocity.x = clamp(velocity.x, - MAX_SPEED, MAX_SPEED)

	elif velocity.x: velocity = velocity.move_toward(Vector2(0, velocity.y), FRICTION * delta)

func apply_movement():
	velocity = move_and_slide(velocity, FLOOR)

func apply_jump():
	jump_sound.play()
	velocity.y = JUMP_HEIGHT

func handle_input():
	shooting = int(Input.get_action_strength("ui_select"))
	input_velocity = Vector2.ZERO
	input_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_velocity = input_velocity.normalized()

	if input_velocity: 
		sprite.flip_h = true if input_velocity.x < 0 else false
		weapon_sprite.flip_h = sprite.flip_h
		weapon_sprite.position.x = -1 if weapon_sprite.flip_h else 2
		weapon_point.position.x = -5 if weapon_sprite.flip_h else 4
		weapon_pos = weapon_sprite.position

func shoot():
	var _ret = weapon_animation_player.play("ShootLeft") if weapon_sprite.flip_h else weapon_animation_player.play("ShootRight")
	camera_shake.start()
	
	if can_shoot:
		can_shoot = false
		gun_cooldown_timer.start()
		var bullet_sprite_instance = bullet_sprite.instance()
		get_parent().get_parent().add_child(bullet_sprite_instance)
		bullet_sprite_instance.position = position + weapon_sprite.position + weapon_point.position
		bullet_sprite_instance.MAX_SPEED = -bullet_sprite_instance.MAX_SPEED if weapon_point.position.x < 0 else bullet_sprite_instance.MAX_SPEED

func _on_JumpBuffer_timeout():
	if is_on_floor(): apply_jump()

func _on_GhostTimer_timeout():
	var ghost_sprite_instance = ghost_sprite.instance()
	get_parent().add_child(ghost_sprite_instance)
	ghost_sprite_instance.frame = sprite.frame
	ghost_sprite_instance.flip_h = sprite.flip_h
	ghost_sprite_instance.scale.y = sprite.scale.y
	ghost_sprite_instance.position = self.position

func _on_GhostTimerTimeout_timeout():
	ghost_timer.stop()

func _on_GunCooldown_timeout():
	can_shoot = true
