extends CanvasLayer

onready var fondo:ColorRect = $ColorRect

var cerrando:bool = false #Para saber cuando está cargando partida.
var el_menu

func _unhandled_input(event):
	if event.is_action_released("escape") and not Memoria.juego_terminado and not Memoria.debug:
		$PantallaMenuRapido.MostrarOcultarMenu()


func PonerMenu(menu):
	el_menu = menu
	$AnimationPlayer.play("efecto_d")
	
	

func RetornarPantallas()->Array:
	var a:Array =[]
	for i in get_children():
		if i is Pantalla:
			a.append(i)
	return a
	
func CerrarMenus():
	cerrando = true

func segundo_paso(menu):
	get_node(menu).visible = true
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "efecto_d":
		for i in get_children():
			if i is Pantalla:
				i.visible = false
				
		$AnimationPlayer.play("efecto_inv")
		if cerrando:
			return
		
		get_node(el_menu).visible = true
		
	if anim_name == "efecto_inv":
		cerrando = false
		get_tree().paused = false
		pass
	pass # Replace with function body.
