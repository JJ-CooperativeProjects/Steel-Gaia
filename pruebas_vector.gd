extends KinematicBody2D

var vec:Vector2 = Vector2.ZERO

func _process(delta):
	prints(position, global_position,transform)
	if Input.is_action_pressed("atacar"):
		position += Vector2(100,0).rotated(rotation) * delta
		#transform.origin.x += 100 * delta
		#translate(Vector2(100,0)*delta)
	
	if Input.is_action_pressed("escopeta"):
		rotate(deg2rad(100 * delta))

func _physics_process(delta):
	var direction:Vector2 = get_global_mouse_position() - global_position
	direction = direction.normalized()
	
	var rotateAmount = direction.cross(transform.y)
	
	rotate(rotateAmount * 2 * delta)
	
	vec = -transform.y.normalized() * 200
	vec = move_and_slide(vec)
	
	
