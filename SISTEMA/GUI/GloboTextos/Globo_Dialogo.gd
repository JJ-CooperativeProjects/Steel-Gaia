extends Control


export (String) var texto = "HOla, me llamo James. Estoy buscando a mi hija que se perdio..." 
export (float) var TiempoEntreCaracteres = 0.05
export (float) var MinTiempoEntreCaracteres = 0.005
export (bool) var se_cierra_solo = true #Si es true, cuando termina el dialogo y el tiempo de vida es 0, se cierra solo
export (float) var TiempoVida = 2.0 #Cuando termina el dialogo, este tiempo elimina el dialogo si el usuario no lo ha cerrado antes.
var tiempo_rec = 0
var mi_creador = null #id del nodo que lo creó. Con la intension de moverlo con él.

var texto_animando = false
enum estados{NADA,EXCLAMANDO,DIALOGO_NORMAL,GLOBO_PENSANDO,PROCESANDO_TEXTO,TEXTO_PROCESADO}
var estado = estados.NADA

signal EmpezarAnimacionTexto()
signal TerminaAnimacionTexto()



# Called when the node enters the scene tree for the first time.
func _ready():
	tiempo_rec = TiempoEntreCaracteres
	$Globos/RichTextLabel.percent_visible = 0.0
	$Globos/RichTextLabel.get_v_scroll().value = 0
	mi_creador = Memoria.jugador #Prueba
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#PRUEBAS:
	#print(estado)
#	if Input.is_action_just_pressed("accionA") and estado == estados.NADA:
#		ActivarGLoboPensando()
	#LOGICA:
	if estado == estados.EXCLAMANDO:
		Exclamacion()
	elif estado == estados.PROCESANDO_TEXTO:
		ProcesarDatos()
		$AnimationPlayer.play("GloboPensando")

	if texto == "" and estado == estados.PROCESANDO_TEXTO:
		emit_signal("TerminaAnimacionTexto")

	
		
	#DA LA POSIBILIDAD DE CONTINUAR SI SE TERMINÖ EL GLOBO:
	if estado == estados.TEXTO_PROCESADO:
		if Input.is_action_just_pressed("accionB"):
			mi_creador.id_dialogo = null
			queue_free()
	
func _physics_process(delta):
	#CHEQUEAR SI MI CREADOR EXISTE:
	if mi_creador != null:
		rect_position = Vector2(mi_creador.global_position.x,mi_creador.global_position.y-120)
	
#EJECUTAR UNA EXCLAMASION:
func ActivarExclamasion():
	estado = estados.EXCLAMANDO
	
#GLOBO PENSANDO:
func ActivarGLoboPensando():
	$AnimationPlayer.play("ApareceGloboPensando",-1,2)
	estado = estados.GLOBO_PENSANDO
	
func Exclamacion():
	$AnimationPlayer.play("ApareceGloboExclamacion")
	$Globos/RichTextLabel.visible_characters = -1
	$Globos/RichTextLabel.percent_visible = 1
	$Globos/RichTextLabel.text = texto
	#texto = ""
	yield(get_tree().create_timer(0.22),"timeout")
	$Globos/RichTextLabel.visible = true
	emit_signal("TerminaAnimacionTexto")
	
#DIALOGO NORMAL:
func ActivarDialogoNormal():
	$AnimationPlayer.play("ApareceGloboNormal",-1,3)
	estado = estados.DIALOGO_NORMAL
	
func ProcesarDatos():
	var letra =texto.left(1)
	texto = texto.substr(1,-1)
	$Globos/RichTextLabel.text = $Globos/RichTextLabel.text + letra
	$Globos/RichTextLabel.visible_characters += 1
	QuitarPausaTemporal(TiempoEntreCaracteres)
	#REPRODUCE LOS TEXTOS MAS RAPIDOS:
	if Input.is_action_pressed("accionB"):
		TiempoEntreCaracteres = MinTiempoEntreCaracteres
	if Input.is_action_just_released("accionB"):
		TiempoEntreCaracteres = tiempo_rec
	set_process(false)

func QuitarPausaTemporal(tiempo):
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = tiempo
	timer.start()
	timer.connect("timeout",self,"set_process",[true])

func EliminarGlobo():
	mi_creador.id_dialogo = null
	queue_free()

func _on_Globo_Dialogo_EmpezarAnimacionTexto():
	estado = estados.PROCESANDO_TEXTO
	pass # Replace with function body.

func _on_Globo_Dialogo_TerminaAnimacionTexto():
	#print("termina")
	estado = estados.TEXTO_PROCESADO
	$Globos/GuiaGloboNormal/Icon.visible = true
	$AnimationPlayer.play("AnimarIcono")
	if(se_cierra_solo):
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = TiempoVida
		timer.start()
		timer.connect("timeout",self,"EliminarGlobo")
		
	pass # Replace with function body.
