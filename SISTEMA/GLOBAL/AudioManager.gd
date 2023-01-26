extends Node
class_name AudioManager
"""
CLAE GLOBAL QUE SE ENCARGA DE ADMINISTRAR EL AUDIO
"""
onready var audio_master:AudioStreamPlayer = $AudioStreamPlayer

onready var ecualizador:AudioBusLayout = preload("res://default_bus_layout.tres")

var volumen_music:float = 0 setget set_volumen_music
var volumen_master:float = 0 setget set_volumen_master

func set_volumen_master(valor:float):
	volumen_master = valor
	AudioServer.set_bus_volume_db(0,valor)
	
func set_volumen_music(valor:float):
	volumen_music = valor
	AudioServer.set_bus_volume_db(2,valor)

func _ready():
	pass


func ReproducirAudioAumentarVolumen(stream:AudioStream, tiempo:float = 3.0):
	var bus_music_indx = AudioServer.get_bus_index("Music")
	
	audio_master.stream = stream
	audio_master.play(0.0)
	
	set_volumen_music(-30)
	
	var tw:SceneTreeTween = create_tween()
	tw.tween_property(self,"volumen_music",0.0,tiempo)
	pass

#Baja el master:
func BajarVolumenMaster(tiempo:float = 2.0):
	var tw:SceneTreeTween = create_tween()
	tw.tween_property(self,"volumen_master",-60.0,tiempo)

func SubirVolumenMaster(tiempo:float = 2.0):
	var tw:SceneTreeTween = create_tween()
	tw.tween_property(self,"volumen_master",0.0,tiempo)
