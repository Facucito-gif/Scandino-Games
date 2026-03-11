extends Control

# Referencia a tu nodo OptionButton. Asegurate de que la ruta sea la correcta.
@onready var boton_idioma: OptionButton = $MarginContainer/VBoxContainer/IdiomaSelector/BotonIdioma





func _ready():
	# 1. Agregamos las opciones al menú desplegable
	boton_idioma.add_item("Español") # Índice 0
	boton_idioma.add_item("English") # Índice 1
	
	# 2. Leemos en qué idioma está el juego ahora para que el botón muestre el correcto
	var idioma_actual = TranslationServer.get_locale()
	
	# Si el locale empieza con "en" (inglés), seleccionamos la opción 1, sino la 0
	if idioma_actual.begins_with("en"):
		boton_idioma.select(1)
	else:
		boton_idioma.select(0)
		
	# 3. Conectamos la señal que avisa cuando el jugador elige una opción
	boton_idioma.item_selected.connect(_al_seleccionar_idioma)

# Esta función se ejecuta cada vez que elegís algo en el desplegable
func _al_seleccionar_idioma(indice: int):
	if indice == 0:
		TranslationServer.set_locale("es") # Cambia a español
	elif indice == 1:
		TranslationServer.set_locale("en") # Cambia a inglés


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
