extends KinematicBody2D

export(int) var MAX_SPEED = 30000
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.x = MAX_SPEED
	velocity = move_and_slide(velocity * delta)
	
	if !velocity: queue_free()
	
func _on_Area2D_area_entered(_area):
	queue_free()
