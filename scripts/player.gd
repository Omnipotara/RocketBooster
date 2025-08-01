extends RigidBody3D

##This controls the speed of player moving upward/forward
@export_range(750.0, 2000.0) var acceleration_speed : float = 1000.0

##This controls the speed of player rotation
@export var rotation_speed : float = 200.0

##How much delay is between crashing/winning and it's sequence
@export var tween_wait_time : float = 2.0

#VFX imports
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles

#SFX imports
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer = $RocketAudio

#Variables
var is_active : bool = true
var rng : RandomNumberGenerator = RandomNumberGenerator.new()



func _process(delta: float) -> void:

	if Input.is_action_pressed("action"):
		apply_central_force(basis.y * delta * acceleration_speed)
		booster_particles.emitting = true
		if not rocket_audio.playing:
			_play_pitch_audio(rocket_audio)
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
		
	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -rotation_speed * delta))
		
	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, rotation_speed * delta))

func _on_body_entered(body: Node) -> void:
	if is_active:
		if body.is_in_group("goal"):
			win_sequence(body.file_path)

		if body.is_in_group("fail"):
			booster_particles.emitting = false
			rocket_audio.stop()
			crash_sequence()
		
func win_sequence(next_level_file : String) -> void:
	booster_particles.emitting = false
	rocket_audio.stop()
	is_active = false
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	var tween : Tween = create_tween()
	tween.tween_interval(tween_wait_time)
	tween.tween_callback(Callable(self, "_change_scene").bind(next_level_file))
 		
func crash_sequence() -> void:
	is_active = false
	explosion_particles.emitting = true    
	explosion_audio.play()
	set_process(false)
	var tween : Tween = create_tween()
	tween.tween_interval(tween_wait_time)
	tween.tween_callback(Callable(self, "_restart_scene"))
	
func _change_scene(next_level_file : String) -> void:
	get_tree().change_scene_to_file(next_level_file)
	
func _restart_scene() -> void:
	get_tree().reload_current_scene()
	
func _play_pitch_audio(audio : AudioStreamPlayer) -> void:
	audio.pitch_scale = rng.randf_range(0.8, 1.2)
	audio.play()
