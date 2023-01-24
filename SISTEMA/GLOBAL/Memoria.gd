extends Node
"""
SCRIPT AUTOLOAD UTILIZADO PARA GUARDAR DATOS IMPORTANTES DURANTE EL JUEGO.
"""
signal modo_cinematica()
signal datos_cargados() #emitida despues de que los datos del nivel estén cagados y listos.

##si el juego fue terminado:
var juego_terminado:bool = false

##Almacena las rutas de las pantallas visitadas. Se usa para los menus:
var historial_pantallas:Array = []


#Activar o desactivar debug:
var debug:bool = false
var consola = null
var consola_debug:DebuggInGame = null

##Valor de la gravedad global:
var gravedad:float = 900

##Modo cinemática: Si se activa, el usuario no podrá controlar al jugador.
var modo_cinematica_activo:bool = false		setget set_modo_cinematica

##La camara actual del juego:
var camara_actual:Camera2D = null

##El nivel actual como referencia:
var nivel_actual:Nivel = null
var juego_pausado:bool = false #solo se pone a true cuando el juego se pausa. no incluye las interfaces graficas.
#aqui se van guardando los datos de los objetos persistentes para cuando se guarde el nivel.
var persistentes_temporales_a_guardar:Dictionary = {
	"persistentes": [],
	"eventos": [],
	"imborrables":[]
}


##Jugador:
var jugador:Jugador = null
var almas_NPC1:int = 0
var almas_NPC2:int = 0
var almas_NPC3:int = 0
var almas_NPC4:int = 0

#Datos tempoarales del jugador para pasar a otros niveles (los otros datos los carga del salve rapido):
var posicion_aparecer:Vector2
var direccion_mira:int
var cambiando:bool = false
var es_nuevo:bool = false #Se pone a true cuando está cargando partida de una salva. Le dice al nivel qué hacer.
var data_save:BaseSaveData #Almacena temporalmente los datos a cargar para una partida.
var spawn_point_id:String = ""

##EL juego:
#var tiene_orbe:bool = true		setget set_tiene_orbe#Si tiene el orbe o no 
#var cubos:int = 10              setget set_cubos#Cuenta los cubos obtenidos.
var punto_escalera:Vector2 = Vector2.ZERO

func set_modo_cinematica(valor:bool):
	modo_cinematica_activo = valor
	emit_signal("modo_cinematica",valor)

func _input(event):
#	if event.is_action_pressed("ui_accept") and NoMenus() and nivel_actual:
#		if consola_debug:
#			consola_debug.PonerEnConsola(["Push!"])
	if event.is_action_pressed("ui_accept") and NoMenus() and nivel_actual:
		consola_debug.PonerEnConsola(["Push!"])
		debug = true if not debug else false


		if debug and consola:
			consola.visible = true
			consola.grab_focus()
		pass

func _ready():
	randomize()
#	set_tiene_orbe(false)
#	set_cubos(0)
	
	connect("datos_cargados",self,"on_datos_cargados")
	
	#Crea los directorios para salvar cargar partidas:
	var dir:Directory = Directory.new()
	
	if not dir.dir_exists("user://SAVES"):
		dir.make_dir("user://SAVES")
	
	if not dir.dir_exists("user://temp"):
		dir.make_dir("user://temp")

#Utilizar para obtener el nombre original de un nodo. (elimina los @)
static func ObtenerNombreOriginal(nodo:Node)->String:
	if nodo.name.find("@") > 0:
		var nombre:String = nodo.name.left(nodo.name.find_last("@"))
		nombre = nombre.right(nombre.find("@")+1)
		return nombre

	return nodo.name

#MEtodo para cargar una imagen PNG de un directorio externo:
static func CargarImagen(ruta:String,scale:Vector2= Vector2(1,1))->Texture:
	var tex_file:File = File.new()
	tex_file.open(ruta,File.READ)
	var buffer = tex_file.get_buffer(tex_file.get_len())
	
	var img = Image.new()
	img.load_png_from_buffer(buffer)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	imgtex.set_size_override(scale)
	tex_file.close()
	
	return imgtex
	
	
static func _movimiento_suavisado_de_A_a_B(posicionA:Vector2, posicionB:Vector2, velocidad:float, distancia_minima:float, tolerancia:float = 5.0)->Dictionary:
	var dicc:Dictionary = {}
	var distancia_actual:float = posicionA.distance_to(posicionB)
	var vector:Vector2 = posicionA.direction_to(posicionB) * clamp(distancia_actual-distancia_minima,0,velocidad)
	
	if distancia_actual < tolerancia:
		dicc.llego_al_objetivo = true
	else:
		dicc.llego_al_objetivo = false

	dicc.vector = vector
	return dicc

#func VerificarCubosOrbe(objeto:String,cantidad):
#	if objeto.find("Orbe") != -1:
#		Memoria.tiene_orbe = true
#	elif objeto.find("Cubo") != -1:
#		if cubos < 10:
#			cubos+= cantidad
		

func NoMenus()->bool:
	var pantallas = MenusGlobales.RetornarPantallas()
	for i in pantallas:
		if i.visible:
			return false
	return true
	
func SacudirCamara(a,b,c,d,e):
	camara_actual.sacudir(a,b,c,d,e)



###CARGAR SALVAR si salva correctamente, retorna true
func SalvarRapido()->bool:

	#verificar si existe el archivo:
	var file:File = File.new()
	var dato_final:BaseSaveData
	
	if not file.file_exists("user://temp/SAVE_auto.tres"):
		dato_final = BaseSaveData.new()
	else:
		dato_final = load("user://temp/SAVE_auto.tres")
	
	#SALVAR MISIONES:
	dato_final.misiones = GestorMisiones_global.GuardarMisiones()
	
	#SSALVAR NIVEL:
	dato_final.ultimo_nivel = Memoria.nivel_actual.filename
	#verificar si ya existe:
	var existe = dato_final.ObtenerNivelEnSalva(nivel_actual.name)
	
	var nivel_salvado:Dictionary = dato_final.SalvarNivel(Memoria.nivel_actual.name,nivel_actual.filename)
	
	if not existe == null:
		dato_final.niveles_visitados.remove(existe)
		dato_final.niveles_visitados.insert(existe,nivel_salvado)
		pass
	else:
		dato_final.AddNuevoNivel(nivel_salvado)
	
	
	var error = ResourceSaver.save("user://temp/SAVE_auto.tres",dato_final)
	if error== OK:
		Memoria.consola_debug.PonerEnConsola(["Se pudo salvar Rápido!"])		
		print("salvado rapido con exito")
		return true
	else:
		Memoria.consola_debug.PonerEnConsola(["ERROR: Al salvar rápido!!"])
		
		print("Error al salvar rapido")
		return false
		
	pass

func SalvarNuevo(nombre:String):
	var dato:BaseSaveData
	var file:File = File.new()
	var dato_final:BaseSaveData = BaseSaveData.new()
	
	#Salva normal:
	if SalvarRapido():
		dato = load("user://temp/SAVE_auto.tres")
		
	#elimina el archivo si existe:
	if file.file_exists("user://SAVES/" + nombre + ".tres"):
		var directorio:Directory = Directory.new()
		directorio.remove("user://SAVES/" + nombre + ".tres")
		
	var error = ResourceSaver.save("user://SAVES/" + nombre + ".tres",dato)
	if error== OK:
		#Salvar el una pantalla:
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("user://SAVES/" + nombre + ".png")
		print("salvado con exito " + nombre)
		Memoria.consola_debug.PonerEnConsola(["Juego Salvado!!"])
	else:
		consola_debug.PonerEnConsola(["ERROR: Al sarvar rápido."])
		print("Error al salvar " + nombre)
	pass

func CargarRapido():
	var dato:BaseSaveData = load("res://SISTEMA/SAVE_SISTEM/temp/SAVE_auto.tres")
	
#Este método intentará cargar la ultima partida guardada. Utilizado cuadno el jugador muere.
func CargarUltimaPartidaGuardada():
	data_save = load("user://temp/SAVE_auto.tres")
	cambiando = true
	CambioSuave.CambiarEscena(data_save.ultimo_nivel)
	
#Este método carga una partida indicando su nombre:
func CargarPartidaNombre(nombre:String):
	#verificar si existe el archivo:
	var file:File = File.new()
	
	if not file.file_exists("user://SAVES/" + nombre + ".tres"):
		consola_debug.PonerEnConsola(["ERROR: No se ha encontrado el archivo en la ruta de usuario."])
		return
	
	#seguir cargando...
	data_save = load("user://SAVES/" + nombre + ".tres")
	es_nuevo = true
	CambioSuave.CambiarEscena(data_save.ultimo_nivel)
	
	
func on_datos_cargados():
	print("Se emite la señal de datos cargados!!!")
	
