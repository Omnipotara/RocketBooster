extends Control

@onready var volume_slider: HSlider = $VolumeSlider
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const MAIN_MENU : String = "res://scenes/menus/main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fade_in")
	_load_settings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_slider_value_changed(value: float) -> void:
	var db : float = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)
	_save_settings()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
	
func _save_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	config.set_value("audio", "master_volume", volume_slider.value)
	config.save("user://settings.cfg")
	
func _load_settings() -> void:
	var config : ConfigFile = ConfigFile.new()
	var err : Error = config.load("user://settings.cfg")
	if err == OK:
		var vol : Variant = config.get_value("audio", "master_volume", 100.0)
		volume_slider.value = vol
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(vol / 100.0))
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0) # 0 dB
