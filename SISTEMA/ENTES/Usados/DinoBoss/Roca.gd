extends RigidBody2D

func _ready():
	linear_velocity = Vector2(rand_range(-80,-180),rand_range(-10,-200))
	angular_velocity = rand_range(10,50)
