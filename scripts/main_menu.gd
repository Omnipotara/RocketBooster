extends Control

@onready var play_button: Button = $PlayButton
@onready var quit_button: Button = $QuitButton
@onready var settings_button: Button = $SettingsButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
const LEVEL_1 = "res://scenes/levels/level1.tscn"
const SETTINGS_MENU = "res://scenes/menus/settings_menu.tscn"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("fade_in")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_1)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file(SETTINGS_MENU)
