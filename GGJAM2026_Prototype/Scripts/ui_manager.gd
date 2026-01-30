extends CanvasLayer

## Singleton para gestionar todos los elementos de la interfaz de usuario
## Centraliza botones de dirección, FocusItem, diálogos e inventario (futuro)

signal focus_item_clicked
signal direction_button_clicked(direction: String)

# Referencias a elementos UI
var _direction_buttons_container: Control
var _button_left: Button
var _button_right: Button
var _button_up: Button
var _button_down: Button

var _focus_item_container: Node2D
var _current_focus_items: Array[Node2D] = []  # Array para múltiples FocusItems
var _focus_item_scene: PackedScene

# Referencia al DialogueManager (ya existe como singleton)
# No necesitamos instanciarlo aquí, solo coordinamos

# =============================================================================
# INVENTARIO (PREPARADO PARA FUTURO)
# =============================================================================
# TODO: Implementar cuando se necesite
# var _inventory_panel: Control
# var _inventory_items_container: Container
# var _inventory_items: Dictionary = {}  # item_id -> instancia

# =============================================================================
# CONFIGURACIÓN INICIAL
# =============================================================================

func _ready():
	# Cargar escena de FocusItem
	_focus_item_scene = load("res://Scenes/Buttons Scenes/focus_item_scene.tscn") as PackedScene
	if not _focus_item_scene:
		push_error("UI_manager: No se pudo cargar focus_item_scene.tscn")
	
	# Obtener referencias a los nodos (se asignarán desde la escena)
	call_deferred("_initialize_references")
	
	# Conectar señales de SceneManager para actualizar UI al cambiar escena
	SceneManager.transition_completed.connect(_on_scene_transition_completed)

func _initialize_references():
	# Buscar contenedores y botones en la escena
	_direction_buttons_container = get_node_or_null("DirectionButtons")
	if _direction_buttons_container:
		_button_left = _direction_buttons_container.get_node_or_null("ButtonLeft")
		_button_right = _direction_buttons_container.get_node_or_null("ButtonRight")
		_button_up = _direction_buttons_container.get_node_or_null("ButtonUp")
		_button_down = _direction_buttons_container.get_node_or_null("ButtonDown")
	
	_focus_item_container = get_node_or_null("FocusItemContainer")
	
	# Conectar señales de los botones
	_connect_button_signals()
	
	# Ocultar todos los botones por defecto
	hide_all_direction_buttons()

func _connect_button_signals():
	if _button_left:
		if not _button_left.pressed.is_connected(_on_button_left_pressed):
			_button_left.pressed.connect(_on_button_left_pressed)
	if _button_right:
		if not _button_right.pressed.is_connected(_on_button_right_pressed):
			_button_right.pressed.connect(_on_button_right_pressed)
	if _button_up:
		if not _button_up.pressed.is_connected(_on_button_up_pressed):
			_button_up.pressed.connect(_on_button_up_pressed)
	if _button_down:
		if not _button_down.pressed.is_connected(_on_button_down_pressed):
			_button_down.pressed.connect(_on_button_down_pressed)

# =============================================================================
# CONFIGURACIÓN DE ESCENA
# =============================================================================

## Configura la UI para una escena específica (método legacy - un solo FocusItem)
## focus_position: Posición donde aparecerá el FocusItem (Vector2.ZERO para ocultarlo)
## focus_scale: Escala del FocusItem (Vector2.ONE por defecto)
## visible_buttons: Array de direcciones visibles ["left", "right", "up", "down"]
func configure_scene_ui(focus_position: Vector2 = Vector2.ZERO, focus_scale: Vector2 = Vector2.ONE, visible_buttons: Array[String] = []):
	# Si hay posición, crear un FocusItem (compatibilidad con código antiguo)
	if focus_position != Vector2.ZERO:
		var focus_items_config = [{
			"position": focus_position,
			"scale": focus_scale,
			"target_scene": ""  # Usa navegación automática
		}]
		configure_focus_items(focus_items_config)
	else:
		clear_all_focus_items()
	
	# Configurar visibilidad de botones
	hide_all_direction_buttons()
	for direction in visible_buttons:
		show_direction_button(direction, true)

## Configura múltiples FocusItems para una escena
## focus_items_config: Array de diccionarios, cada uno con:
##   - "position": Vector2 (posición del FocusItem)
##   - "scale": Vector2 (escala, opcional, default Vector2.ONE)
##   - "target_scene": String (escena destino, opcional, "" = navegación automática)
## visible_buttons: Array de direcciones visibles ["left", "right", "up", "down"]
func configure_scene_ui_multiple(focus_items_config: Array, visible_buttons: Array[String] = []):
	# Configurar FocusItems
	configure_focus_items(focus_items_config)
	
	# Configurar visibilidad de botones
	hide_all_direction_buttons()
	for direction in visible_buttons:
		show_direction_button(direction, true)

## Establece la posición y escala del FocusItem (método legacy - un solo FocusItem)
func set_focus_item_position(position: Vector2, scale: Vector2 = Vector2.ONE):
	var focus_items_config = [{
		"position": position,
		"scale": scale,
		"target_scene": ""
	}]
	configure_focus_items(focus_items_config)

## Configura múltiples FocusItems
## focus_items_config: Array de diccionarios con "position", "scale" (opcional), "target_scene" (opcional)
func configure_focus_items(focus_items_config: Array):
	if not _focus_item_scene or not _focus_item_container:
		push_warning("UI_manager: No se puede posicionar FocusItem, faltan referencias")
		return
	
	# Limpiar FocusItems anteriores
	clear_all_focus_items()
	
	# Crear cada FocusItem
	for item_config in focus_items_config:
		if not item_config is Dictionary:
			push_warning("UI_manager: Configuración de FocusItem inválida, debe ser un Dictionary")
			continue
		
		var position = item_config.get("position", Vector2.ZERO)
		if position == Vector2.ZERO:
			continue  # Saltar si no hay posición
		
		var scale = item_config.get("scale", Vector2.ONE)
		var target_scene = item_config.get("target_scene", "")
		
		# Instanciar FocusItem
		var focus_item = _focus_item_scene.instantiate()
		focus_item.position = position
		focus_item.scale = scale
		
		# Configurar escena destino si se especificó
		if target_scene != "":
			# Necesitamos modificar el script del FocusItem para aceptar target_scene
			# Por ahora, almacenamos la escena destino en una variable del nodo
			focus_item.set_meta("target_scene", target_scene)
			# Conectar señal personalizada para manejar el clic con destino específico
			var area = focus_item.get_node_or_null("Area2D")
			if area:
				if not area.input_event.is_connected(_on_focus_item_with_target_clicked.bind(focus_item)):
					area.input_event.connect(_on_focus_item_with_target_clicked.bind(focus_item))
		
		_focus_item_container.add_child(focus_item)
		_current_focus_items.append(focus_item)

## Limpia todos los FocusItems
func clear_all_focus_items():
	for item in _current_focus_items:
		if is_instance_valid(item):
			item.queue_free()
	_current_focus_items.clear()

## Limpia el FocusItem actual (método legacy)
func clear_focus_item():
	clear_all_focus_items()

## Maneja el clic en un FocusItem con escena destino específica
func _on_focus_item_with_target_clicked(viewport: Node, event: InputEvent, shape_idx: int, focus_item: Node2D):
	if event is InputEventMouseButton:
		var mb = event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			var target_scene = focus_item.get_meta("target_scene", "")
			if target_scene != "" and ResourceLoader.exists(target_scene):
				SceneManager.change_scene(target_scene)
				focus_item_clicked.emit()
			else:
				push_warning("UI_manager: target_scene no válida para FocusItem: " + target_scene)

# =============================================================================
# BOTONES DE DIRECCIÓN
# =============================================================================

## Muestra u oculta un botón de dirección específico
func show_direction_button(direction: String, visible: bool):
	var button = _get_direction_button(direction)
	if button:
		button.visible = visible
	else:
		push_warning("UI_manager: Botón de dirección no encontrado: " + direction)

## Oculta todos los botones de dirección
func hide_all_direction_buttons():
	show_direction_button("left", false)
	show_direction_button("right", false)
	show_direction_button("up", false)
	show_direction_button("down", false)

## Obtiene la referencia al botón de dirección (método público)
func get_direction_button(direction: String) -> Button:
	return _get_direction_button(direction)

## Obtiene la referencia al botón de dirección (método interno)
func _get_direction_button(direction: String) -> Button:
	match direction.to_lower():
		"left":
			return _button_left
		"right":
			return _button_right
		"up":
			return _button_up
		"down":
			return _button_down
		_:
			return null

# =============================================================================
# MANEJADORES DE EVENTOS DE BOTONES
# =============================================================================

func _on_button_left_pressed():
	# Botón izquierdo: Volver a escena anterior (navegación entre subescenas)
	SceneManager.on_back_clicked()
	direction_button_clicked.emit("left")

func _on_button_right_pressed():
	# Botón derecho: Avanzar a siguiente subescena
	# Usa la misma lógica que FocusItem
	SceneManager.on_focusitem_clicked()
	direction_button_clicked.emit("right")

func _on_button_up_pressed():
	# Botón arriba: El botón ya maneja su propia lógica en direction_button_up.gd
	# Solo emitimos la señal para notificar
	direction_button_clicked.emit("up")

func _on_button_down_pressed():
	# Botón abajo: Navegar a escena principal anterior (C --> B)
	var main_scenes = SceneManager.main_scenes
	var current = SceneManager.current_scene
	var current_idx = main_scenes.find(current)
	
	if current_idx > 0:
		SceneManager.change_scene(main_scenes[current_idx - 1])
	else:
		# Si no estamos en una main scene, intentar volver a la main scene padre
		var back = SceneManager.get_back_scene()
		if back != "":
			SceneManager.change_scene(back)
	direction_button_clicked.emit("down")

# El FocusItem maneja su propio clic a través de clickable_focus_item.gd
# Si necesitas detectar cuando se hace clic, puedes escuchar la señal de SceneManager
# o conectar la señal focus_item_clicked desde fuera

# =============================================================================
# EVENTOS DE CAMBIO DE ESCENA
# =============================================================================

func _on_scene_transition_completed():
	# Cuando se completa una transición, la escena debe configurar su UI
	# Esto se hace desde cada escena en su _ready()
	pass

# =============================================================================
# INVENTARIO (PREPARADO PARA FUTURO)
# =============================================================================

## TODO: Implementar cuando se necesite el inventario
## Agrega un item al inventario
# func add_item_to_inventory(item_id: String, icon_path: String) -> void:
# 	pass

## Remueve un item del inventario
# func remove_item_from_inventory(item_id: String) -> void:
# 	pass

## Valida si un item puede ser colocado en la posición dada
# func validate_item_placement(item_id: String, position: Vector2) -> bool:
# 	return false

## Muestra un mensaje de feedback al jugador
# func show_feedback_message(message: String, duration: float = 2.0) -> void:
# 	pass
