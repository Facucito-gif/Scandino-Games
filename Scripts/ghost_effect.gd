extends Sprite2D

func _ready():
	z_index = -1 # Esto lo manda ATRÁS del personaje
	modulate = Color(0.0, 0.8, 0.8, 0.6) # Turquesa transparente
	
	var tween = create_tween()
	# Se desvanece y se achica al mismo tiempo
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	tween.parallel().tween_property(self, "scale", Vector2(0.7, 0.7), 0.4)
	
	# Se borra al terminar
	tween.tween_callback(queue_free)

func set_ghost_properties(texture_to_use, flipped, pos):
	texture = texture_to_use
	flip_h = flipped
	global_position = pos
