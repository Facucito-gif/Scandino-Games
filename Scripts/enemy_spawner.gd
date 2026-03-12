extends Node2D

@export var enemy_scene: PackedScene
@export var direccion_enemigo: int = 1 # Setealo en el Inspector (1 o -1)

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	enemy.direccion = direccion_enemigo
	
	if direccion_enemigo == 1:
		enemy.scale.x = -1
		
	get_tree().current_scene.add_child(enemy)
