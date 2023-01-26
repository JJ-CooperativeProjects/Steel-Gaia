extends Pantalla


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var audio := load("res://RECURSOS/SONIDOS/MUSICA/untitled2.mp3") as AudioStream
	
	if AudioManagerGlobal.audio_master.stream != audio:
		AudioManagerGlobal.ReproducirAudioAumentarVolumen(audio)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
