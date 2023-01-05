extends KinematicBody2D
class_name Plataforma

onready var collider:CollisionShape2D = $CollisionShape2D


func _on_Area2D_body_entered(body):
	collider.set_deferred("one_way_collision",true)
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	collider.set_deferred("one_way_collision",false)
	pass # Replace with function body.
