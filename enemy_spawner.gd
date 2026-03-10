extends Node2D

@export var enemy_scene: PackedScene # Aquí arrastrarás tu archivo Bat.tscn
@onready var timer = $Timer

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	# Moneda al aire: 0 = Izquierda, 1 = Derecha
	var lado = randi() % 2 
	
	if lado == 0:
		enemy.position = Vector2(-50, 450) # Aparece a la izq
		enemy.direccion = 1
	else:
		enemy.position = Vector2(1200, 450)
		enemy.direccion = -1
		# Esto busca cualquier nodo que sea un Sprite y lo voltea
		for child in enemy.get_children():
			if child is Sprite2D or child is AnimatedSprite2D:
				child.flip_h = true
	
	get_tree().current_scene.add_child(enemy)
