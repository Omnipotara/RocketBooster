extends AnimatableBody3D

@export var destination : Vector3
@export var duration : float = 3.0
var tween : Tween = create_tween()
@onready var player: RigidBody3D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_property(self, "global_position", global_position, duration)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not player.is_active:
		tween.stop()
