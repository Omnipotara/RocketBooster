extends RigidBody3D

##This controls the speed of player moving upward/forward
@export_range(750.0, 2000.0) var acceleration_speed : float = 1000.0

##This controls the speed of player rotation
@export var rotation_speed : float = 200.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_pressed("action"):
		apply_central_force(basis.y * delta * acceleration_speed)
		
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -rotation_speed * delta))
		
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, rotation_speed * delta))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("goal"):
		print("You won!")
	
	if body.is_in_group("fail"):
		print("You lost!")
		queue_free()
