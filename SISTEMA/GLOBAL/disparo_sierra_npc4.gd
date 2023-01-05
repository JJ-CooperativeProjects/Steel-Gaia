extends "res://SISTEMA/OBJETOS/TRAMPAS/disparo_ametralladora.gd"

var t:float = 0.0

var pos_inicio:Vector2
var pos_final:Vector2
var pos_intermedio:Vector2

func _ready():
	$AnimationPlayer.play("giro")
	pass

func mecanica(delta):
	t += delta
	global_position = _quadratic_bezier(pos_inicio,pos_intermedio,pos_final,t)
	pass

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	
	var r = q0.linear_interpolate(q1, t)
	return r

func GirarSierra():
	$Sprite.rotation_degrees += 90

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if viewport == get_tree().root.get_viewport():
		get_parent().queue_free()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	get_parent().queue_free()
	pass # Replace with function body.
