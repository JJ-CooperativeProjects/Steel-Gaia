extends Node
"""
SCRIPT AUTOLOAD UTILIZADO PARA GUARDAR DATOS IMPORTANTES DURANTE EL JUEGO.
"""
signal modo_cinematica()

##si el juego fue terminado:
var juego_terminado:bool = false

##Almacena las rutas de las pantallas visitadas. Se usa para los menus:
var historial_pantallas:Array = []

#Activar o desactivar debug:
var debug:bool = false
var consola = null

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
var persistentes_temporales_a_guardar:Array = []


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
var spawn_point_id:String = ""

##EL juego:
var tiene_orbe:bool = true		setget set_tiene_orbe#Si tiene el orbe o no 
var cubos:int = 10              setget set_cubos#Cuenta los cubos obtenidos.


func set_modo_cinematica(valor:bool):
	modo_cinematica_activo = valor
	emit_signal("modo_cinematica",valor)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and NoMenus():
		debug = true if not debug else false

		if debug and consola:
			consola.visible = true
			consola.grab_focus()
			

func _ready():
	randomize()
	set_tiene_orbe(false)
	set_cubos(0)

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
func NoMenus()->bool:
	for i in MenusGlobales.get_children():
		var t:= i as Pantalla
		if t:
			if t.visible:
				return false
	return true
	
func SacudirCamara(a,b,c,d,e):
	camara_actual.sacudir(a,b,c,d,e)


func set_tiene_orbe(valor:bool):
	tiene_orbe = valor
	
	GuiJugador.get_node("GUI/Orbe").visible = tiene_orbe

func set_cubos(valor:int):
	cubos = valor
	
	GuiJugador.get_node("GUI/Cubos").visible = true if cubos > 0 else false
	GuiJugador.get_node("GUI/Cubos/Label").text = "x " + str(cubos) 


###CARGAR SALVAR
func SalvarRapido():
	#verificar si existe el archivo:
	var file:File = File.new()
	var dato_final:BaseSaveData
	
	if not file.file_exists("res://SISTEMA/GLOBAL/RESOURCES/SAVE_DATA/Saves/SAVE_auto.tres"):
		dato_final = BaseSaveData.new()
	else:
		dato_final = load("res://SISTEMA/GLOBAL/RESOURCES/SAVE_DATA/Saves/SAVE_auto.tres")
	
	#Salvar globales:
	dato_final.tiene_orbe = tiene_orbe
	dato_final.cubos = cubos
	dato_final.almas_NPC1 = almas_NPC1
	dato_final.almas_NPC2 = almas_NPC2
	dato_final.almas_NPC3 = almas_NPC3
	dato_final.almas_NPC4 = almas_NPC4
	
	#SALVAR JUGADOR:
	dato_final.vida_actual = Memoria.jugador.vitalidad
	dato_final.vida_max = Memoria.jugador.max_vitalidad
	dato_final.damage = Memoria.jugador.damage
	dato_final.direccion_mira = Memoria.jugador.direccion_mira
	dato_final.energia_actual = Memoria.jugador.energia
	dato_final.max_energia = Memoria.jugador.max_energia
	dato_final.posicion_actual = Memoria.jugador.global_position
	
	#SSALVAR NIVEL:
	#verificar si ya existe:
	var existe = dato_final.ObtenerNivelEnSalva(nivel_actual.name)
	
	var nivel_salvado:Dictionary = dato_final.SalvarNivel(Memoria.nivel_actual.name,nivel_actual.filename)
	
	if not existe == null:
		dato_final.niveles_visitados.remove(existe)
		dato_final.niveles_visitados.insert(existe,nivel_salvado)
		pass
	else:
		dato_final.AddNuevoNivel(nivel_salvado)
	
	
	var error = ResourceSaver.save("res://SISTEMA/GLOBAL/RESOURCES/SAVE_DATA/Saves/SAVE_auto.tres",dato_final)
	if error== OK:
		print("salvado con exito")
	else:
		print("Error al salvar")
	pass

func SalvarNuevo(nombre:String):
	var dato:BaseSaveData = load("res://SISTEMA/GLOBAL/RESOURCES/SAVE_DATA/BaseSaveData.tres")
	var file:File = File.new()
	var dato_final:BaseSaveData = BaseSaveData.new()
	#Salvar globales:
	dato_final.tiene_orbe = tiene_orbe
	dato_final.cubos = cubos
	dato_final.almas_NPC1 = almas_NPC1
	dato_final.almas_NPC2 = almas_NPC2
	dato_final.almas_NPC3 = almas_NPC3
	dato_final.almas_NPC4 = almas_NPC4
	
	#Salvar jugador:
	dato_final.vida_actual = Memoria.jugador.vitalidad
	dato_final.vida_max = Memoria.jugador.max_vitalidad
	dato_final.damage = Memoria.jugador.damage
	dato_final.direccion_mira = Memoria.jugador.direccion_mira
	dato_final.energia_actual = Memoria.jugador.energia
	dato_final.max_energia = Memoria.jugador.max_energia
	dato_final.posicion_actual = Memoria.jugador.global_position
	
	#Salvar datos del nivel:
	
	
	var error = ResourceSaver.save("res://SISTEMA/GLOBAL/RESOURCES/SAVE_DATA/Saves/" + nombre,dato_final)
	if error== OK:
		print("salvado con exito")
	else:
		print("Error al salvar")
	pass

func CargarRapido():
	var dato:BaseSaveData = load("res://SISTEMA/GLOBAL/RESOURCES/SAVE_DATA/Saves/SAVE_auto.tres")
	
#Este método intentará cargar la ultima partida guardada. Utilizado cuadno el jugador muere.
func CargarUltimaPartidaGuardada():
	historial_pantallas.clear()
	CambioSuave.CambiarEscena("res://SISTEMA/NIVELES/Usados/Nivel_pruebas.tscn")
