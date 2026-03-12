extends Node
@onready var sound_menu_accept: AudioStreamPlayer = $sound_menu_accept

func reproducir_click():
	sound_menu_accept.play()
