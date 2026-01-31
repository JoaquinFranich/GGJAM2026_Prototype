extends Node2D

## Ejemplo de cómo configurar múltiples FocusItems en test_node_A3
## 
## Este script muestra cómo tener dos FocusItems:
## - Uno que lleva a test_node_A4
## - Otro que lleva a test_node_A5
##
## INSTRUCCIONES:
## 1. Asigna este script al nodo raíz de test_node_A3.tscn
## 2. Ajusta las posiciones según donde quieras los FocusItems
## 3. Ajusta las rutas de las escenas destino

func _ready():
	# Esperar un frame para asegurar que UI_manager esté listo
	await get_tree().process_frame
	
	# Configurar múltiples FocusItems
	# Ajusta las posiciones (Vector2) según donde quieras que aparezcan
	# configure_focus_items_manual([
	# 	{
	# 		"position": Vector2.ZERO,  # Posición del FocusItem que lleva a A4
	# 		"scale": Vector2(1, 1),          # Tamaño normal
	# 		"target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"  # Escena destino
	# 	},
	# 	{
	# 		"position": Vector2.ZERO,  # Posición del FocusItem que lleva a A5
	# 		"scale": Vector2(1, 1),          # Tamaño normal
	# 		"target_scene": "res://Scenes/Sub Scenes/test_node_A5.tscn"  # Escena destino
	# 	}
	# ])
	
	# Configurar botones de dirección visibles
	UI_manager.hide_all_direction_buttons()
	UI_manager.show_direction_button("left", true) # Solo botón izquierdo para volver
