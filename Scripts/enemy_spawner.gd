extends Node2D

@export var enemy_scene: PackedScene
@export var direccion_enemigo: int = 1 # 1 para derecha, -1 para izquierda

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	
	# Le pasamos la dirección. El murciélago se encargará de espejarse.
	if enemy.has_method("set_direccion"):
		enemy.set_direccion(direccion_enemigo)
	else:
		enemy.direccion = direccion_enemigo
		
	get_tree().current_scene.add_child(enemy)
