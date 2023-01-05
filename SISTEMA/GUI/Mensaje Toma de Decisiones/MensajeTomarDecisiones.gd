extends Control
class_name MensajeTomaDecisiones

signal esta_listo() #emitida cuando el dialogo está totalmente visible.

"""
PARA IMPLEMENTAR MENSAJES QUE PERMITAN AL JUGADOR TOMAR DECISIONES.
"""
onready var texto:TextEdit = $Mensaje/Mensaje


func _ready():
	$AnimationPlayer.play("aparecer")


#Metodo que crea un cuadro de dialogo. Especificar en un arreglo los nombres de los botones que se van a crear.
#Retorna un Arreglo con los Botones creados, para luego crear vinculos.
func CrearDialogo(texto:String, imagen:Texture, botones:Array = [])->Array:
	var data:Array = []
	if not botones.empty():
		for i in botones:
			var boton:Button = load("res://SISTEMA/GUI/Mensaje Toma de Decisiones/BotonPixelArt.tscn").instance()
			boton.text = i
			$Mensaje/HBoxContenedorBotones.add_child(boton)
			data.append(boton)
	
	$Mensaje/Mensaje.text = texto
	$Mensaje/Imagen.texture = imagen
	
	return data

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"aparecer":
			Memoria.juego_pausado = true
			get_tree().paused = true
			$TextureRect.visible = true
			
			#GuiJugador.visible = false
	pass # Replace with function body.
