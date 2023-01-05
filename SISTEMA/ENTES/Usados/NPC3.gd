extends Enemigo

onready var anim_alt:AnimationPlayer = $Cuerpo/Viewport/Base.get_node("AnimationPlayer")
onready var cabeza:Sprite = $Cuerpo/Viewport/Base.get_node("Pivote/Cuerpo/Cabeza")

var dentro_del_area:bool = false

func ConectarSegnales():
	pass

func DetectarObjetivo()->Dictionary:
	var dic:Dictionary = {}
	dic.colision = false
	dic.col_horizontal = false
	dic.col_vertical = false
	dic.objetivo = null
	var col_horizontal:bool = $Cuerpo/RayCast2D2.is_colliding()
	var col_vertical:bool = $Cuerpo/RayCast2D.is_colliding()
	
	if col_horizontal or col_vertical:
		dic.colision = true
		if col_horizontal:
			dic.col_horizontal = true
			dic.objetivo = $Cuerpo/RayCast2D2.get_collider()
		if col_vertical:
			dic.col_vertical = true
			dic.objetivo = $Cuerpo/RayCast2D.get_collider()
	return dic

func CambiarSentido(sentido_escogido:int):
	match sentido_escogido:
		1,-1:
			if direccion_mira != sentido_escogido:
				Girar()
			pass
			
func Caminar(delta)->Vector2:
	velocidad_actual_x = 0
	if velocidad_actual_x in range(-velocidad_movimiento,velocidad_movimiento):
		if direccion_mira > 0:
			velocidad_actual_x += 6 #if !Input.is_action_pressed("correr") else 2.5

		if direccion_mira < 0:
			velocidad_actual_x -= 6 #if !Input.is_action_pressed("correr") else 2.5
	velocidad_actual_x *= velocidad_movimiento
	movimiento.x = lerp(movimiento.x,velocidad_actual_x,0.05)
	return movimiento


func _on_VisibilityNotifier2D_screen_entered():
	dentro_del_area = true
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	dentro_del_area = false
	pass # Replace with function body.
