extends Control

func _ready():
	var botones = get_tree().get_nodes_in_group("BotonesMenu")
	for boton in botones:
		if not boton.pressed.is_connected(AudioManager.reproducir_click):
			boton.pressed.connect(AudioManager.reproducir_click)
	
func _on_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://Scenes/icon.tscn")
	

func _on_button_2_pressed() -> void:
	
	get_tree().change_scene_to_file("res://Scenes/optionsmenu.tscn")
	
func _on_button_3_pressed() -> void:

	await AudioManager.sound_menu_accept.finished
	get_tree().quit()
	
