extends CanvasLayer

## Singleton para gestionar todos los elementos de la interfaz de usuario
## Centraliza botones de dirección, FocusItem, diálogos e inventario (futuro)

@onready var inventory_button: Button = $InventoryButton
@onready var character_portrait: TextureRect = $CharacterPortrait
@onready var abrir: AudioStreamPlayer = $abrir
@onready var cerrar: AudioStreamPlayer = $cerrar

signal focus_item_clicked
signal direction_button_clicked(direction: String)

var activo = true

# Referencias a elementos UI
var _direction_buttons_container: Control
var _button_left: Button
var _button_right: Button
var _button_up: Button
var _button_down: Button

var _focus_item_container: Node2D
var _current_focus_items: Array[Node2D] = [] # Array para múltiples FocusItems
var _focus_item_scene: PackedScene

# Referencias para Mecánica de Máscara
var _mask_button: Button
var _mask_overlay: Control
var _arrow_particles: CPUParticles2D
var _clue_display: TextureRect
var _mask_timer: Timer
var _current_mask_sfx: AudioStreamPlayer

# Referencias para Retrato de Personaje
var _character_portrait: TextureRect
const PORTRAIT_NORMAL = preload("res://Assets/Images/Personaje/policia_normal.png")
const PORTRAIT_MASK = preload("res://Assets/Images/Personaje/policia_máscara.png")


# Referencia al DialogueManager (ya existe como singleton)
# No necesitamos instanciarlo aquí, solo coordinamos

# =============================================================================
# INVENTARIO
# =============================================================================
# =============================================================================
# INVENTARIO
# =============================================================================
var _inventory_button: Button
var _inventory_panel: Control
var _inventory_items_container: Control
var _inventory_data: Inventory
var _inventory_slots: Array = []
const MAX_INVENTORY_SLOTS = 6
const INVENTORY_RESOURCE_PATH = "res://Resource/Inventario.tres"

# Estado de Selección de Item (Drag & Drop)
var _selected_item: InventoryItem = null

# Configuración de Animación Inventario
# (Simplificado a Toggle Visible/Invisible)


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
	
	_focus_item_container = get_node_or_null("FocusItemContainer")
	
	# Referencias Máscara
	_mask_button = get_node_or_null("MaskButton")
	_mask_overlay = get_node_or_null("MaskOverlay")
	if _mask_overlay:
		_clue_display = _mask_overlay.get_node_or_null("ClueDisplay")
		_arrow_particles = _mask_overlay.get_node_or_null("ArrowParticles")
	
	_character_portrait = get_node_or_null("CharacterPortrait")
	if _character_portrait:
		_character_portrait.texture = PORTRAIT_NORMAL
		
	# Referencias Inventario
	_inventory_button = get_node_or_null("InventoryButton")
	if _inventory_button:
		if not _inventory_button.pressed.is_connected(toggle_inventory):
			_inventory_button.pressed.connect(toggle_inventory)
		
		# Conectar señales de cursor
		if not _inventory_button.mouse_entered.is_connected(CursorManager.set_hand_cursor):
			_inventory_button.mouse_entered.connect(CursorManager.set_hand_cursor)
		if not _inventory_button.mouse_exited.is_connected(CursorManager.reset_cursor):
			_inventory_button.mouse_exited.connect(CursorManager.reset_cursor)
		if not _inventory_button.button_down.is_connected(CursorManager.set_click_cursor):
			_inventory_button.button_down.connect(CursorManager.set_click_cursor)
		if not _inventory_button.button_up.is_connected(CursorManager.set_hand_cursor):
			_inventory_button.button_up.connect(CursorManager.set_hand_cursor)
			
	_inventory_panel = get_node_or_null("InventoryPanel")
	if _inventory_panel:
		_inventory_items_container = _inventory_panel.get_node_or_null("ItemsContainer")
		if _inventory_items_container:
			_inventory_slots = _inventory_items_container.get_children()
	
	# Inicializar datos de inventario
	_initialize_inventory_data()
	
	# Crear y configurar el Timer para la máscara
	if not _mask_timer:
		_mask_timer = Timer.new()
		_mask_timer.one_shot = true
		_mask_timer.wait_time = 8.0 # Duración de la máscara en segundos (actualizado a 8s)
		_mask_timer.timeout.connect(_on_mask_timer_timeout)
		add_child(_mask_timer)
	
	# Conectar señales de los botones
	_connect_button_signals()
	
	# Conectar señal de botón máscara
	if _mask_button:
		if not _mask_button.pressed.is_connected(_on_mask_button_pressed):
			_mask_button.pressed.connect(_on_mask_button_pressed)
		# Ocultar por defecto
		_mask_button.visible = false
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
## target_scene: Escena destino específica (opcional, "" = navegación automática)
func configure_scene_ui(focus_position: Vector2 = Vector2.ZERO, focus_scale: Vector2 = Vector2.ONE, visible_buttons: Array[String] = [], target_scene: String = ""):
	# Si hay posición, crear un FocusItem (compatibilidad con código antiguo)
	if focus_position != Vector2.ZERO:
		var focus_items_config = [ {
			"position": focus_position,
			"scale": focus_scale,
			"target_scene": target_scene
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
	
	# Asegurar que el overlay de máscara esté oculto al cambiar de escena
	hide_mask_overlay()
	# El botón de máscara se configura separadamente vía set_current_clue
	# Si no se llama a set_current_clue, asumimos que no hay pista y ocultamos el botón
	# Pero esperamos un frame por si la escena lo llama en su _ready
	call_deferred("_check_mask_button_visibility")

func _check_mask_button_visibility():
	# Si se inicia una nueva escena, asegurar que todo esté reseteado
	# Detener timer si estaba corriendo de la escena anterior
	if _mask_timer and not _mask_timer.is_stopped():
		_mask_timer.stop()
		
	# Asegurar botón habilitado (si es visible)
	if _mask_button:
		_mask_button.disabled = false
	pass

## Establece la posición y escala del FocusItem (método legacy - un solo FocusItem)
func set_focus_item_position(position: Vector2, item_scale: Vector2 = Vector2.ONE):
	var focus_items_config = [ {
		"position": position,
		"scale": item_scale,
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
			continue # Saltar si no hay posición
		
		var item_scale = item_config.get("scale", Vector2.ONE)
		var target_scene = item_config.get("target_scene", "")
		
		# Instanciar FocusItem
		var focus_item = _focus_item_scene.instantiate()
		focus_item.position = position
		focus_item.scale = item_scale
		
		# Configurar datos adicionales
		var conversation_text = item_config.get("dialogue", "")
		if conversation_text != "":
			focus_item.set_meta("dialogue", conversation_text)
		
		# Configurar escena destino si se especificó
		if target_scene != "":
			# Necesitamos modificar el script del FocusItem para aceptar target_scene
			# Por ahora, almacenamos la escena destino en una variable del nodo
			focus_item.set_meta("target_scene", target_scene)
			# Conectar señal personalizada para manejar el clic con destino específico
			# YA NO ES NECESARIO: El propio script clickable_focus_item.gd maneja esto leyendo la meta
			# var area = focus_item.get_node_or_null("Area2D")
			# if area:
			# 	if not area.input_event.is_connected(_on_focus_item_with_target_clicked.bind(focus_item)):
			# 		area.input_event.connect(_on_focus_item_with_target_clicked.bind(focus_item))
		
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
func _on_focus_item_with_target_clicked(_viewport: Node, event: InputEvent, _shape_idx: int, focus_item: Node2D):
	if event is InputEventMouseButton:
		var mb = event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			var target_scene = focus_item.get_meta("target_scene", "")
			if target_scene != "" and ResourceLoader.exists(target_scene):
				AudioManager.play_sfx("pasos", 1.0, 0.8)
				SceneManager.change_scene(target_scene)
				focus_item_clicked.emit()
			else:
				push_warning("UI_manager: target_scene no válida para FocusItem: " + target_scene)

# =============================================================================
# BOTONES DE DIRECCIÓN
# =============================================================================

## Muestra u oculta un botón de dirección específico
func show_direction_button(direction: String, should_be_visible: bool):
	var button = _get_direction_button(direction)
	if button:
		button.visible = should_be_visible
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
	# Verificar si el botón tiene configuración personalizada
	if _button_left and "target_scene" in _button_left and _button_left.target_scene != "":
		AudioManager.play_sfx("pasos", 1.0, 0.8)
		SceneManager.change_scene(_button_left.target_scene)
	else:
		# Botón izquierdo: Volver a escena anterior (navegación entre subescenas)
		AudioManager.play_sfx("pasos", 1.0, 0.8)
		SceneManager.on_back_clicked()
	direction_button_clicked.emit("left")

func _on_button_right_pressed():
	# Verificar si el botón tiene configuración personalizada
	if _button_right and "target_scene" in _button_right and _button_right.target_scene != "":
		AudioManager.play_sfx("pasos", 1.0, 0.8)
		SceneManager.change_scene(_button_right.target_scene)
	else:
		# Botón derecho: Avanzar a siguiente subescena
		# Usa la misma lógica que FocusItem
		SceneManager.on_focusitem_clicked()
		# Nota: on_focusitem_clicked puede que no cambie de escena inmediatamente si es un zoom, 
		# pero "pasos" suele implicar movimiento. Si es solo zoom, quizá otro sonido?
		# Por ahora usamos pasos como feedback genérico de navegación.
		AudioManager.play_sfx("pasos", 1.0, 0.8)
	direction_button_clicked.emit("right")

func _on_button_up_pressed():
	# Botón arriba: El botón ya maneja su propia lógica en direction_button_up.gd
	# Solo emitimos la señal para notificar
	# AÑADIDO: Sonido de pasos aquí también por consistencia si navega
	AudioManager.play_sfx("pasos", 1.0, 0.8)
	direction_button_clicked.emit("up")

func _on_button_down_pressed():
	# Verificar si el botón tiene configuración personalizada
	if _button_down and "target_scene" in _button_down and _button_down.target_scene != "":
		AudioManager.play_sfx("pasos", 1.0, 0.8)
		SceneManager.change_scene(_button_down.target_scene)
	else:
		# Botón abajo: Navegar a escena principal anterior (C --> B)
		AudioManager.play_sfx("pasos", 1.0, 0.8)
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
# MECÁNICA DE MÁSCARA (VISIÓN DEL PASADO)
# =============================================================================

## Configura la pista actual y visibilidad del botón de máscara
## Si textura es null, oculta el botón. Si es válida, lo muestra.
func set_current_clue(texture: Texture2D, clue_position: Vector2 = Vector2.ZERO, clue_scale: Vector2 = Vector2.ONE):
	if _mask_button:
		_mask_button.visible = (texture != null)
	
	if _clue_display:
		_clue_display.texture = texture
		if texture:
			_clue_display.position = clue_position
			_clue_display.scale = clue_scale

## Alterna el modo máscara (overlay visible/oculto)
## AHORA CON TIMER: Activa la máscara por un tiempo limitado
func toggle_mask_mode():
	# Si el overlay ya está visible, no hacemos nada (o podríamos apagarlo, pero el diseño es con timer)
	# Si quisiéramos permitir apagar manualmente, aquí iría la lógica.
	# Por ahora, asumimos que solo se activa y el timer lo apaga.
	if _mask_overlay:
		# 1. Mostrar Overlay
		_mask_overlay.visible = true
		_current_mask_sfx = AudioManager.play_sfx("corrupcion")
		
		# 2. Gestionar Partículas (Solo en F1 y F2)
		_update_arrow_particles_state()
		
		# 3. Deshabilitar botón y arrancar timer
		if _mask_button:
			_mask_button.disabled = true
		
		if _mask_timer:
			_mask_timer.start()
			
		# 4. Cambiar retrato
		if _character_portrait:
			_character_portrait.texture = PORTRAIT_MASK

## Actualiza el estado de las partículas según la escena actual
func _update_arrow_particles_state():
	if not _arrow_particles:
		return
		
	var current = SceneManager.current_scene
	# Verificar si es F1 o F2 (usando los nombres de archivo específicos)
	var is_arrow_scene = current.ends_with("test_node_F1.tscn") or current.ends_with("test_node_F2.tscn")
	
	if is_arrow_scene:
		_arrow_particles.visible = true
		_arrow_particles.emitting = true
	else:
		_arrow_particles.visible = false
		_arrow_particles.emitting = false

## Oculta el overlay de máscara (reset)
func hide_mask_overlay():
	if _mask_overlay:
		_mask_overlay.visible = false
	
	# Detener sonido de corrupción si sigue sonando
	if _current_mask_sfx and _current_mask_sfx.playing:
		_current_mask_sfx.stop()
		_current_mask_sfx = null
	
	# Apagar partículas también
	if _arrow_particles:
		_arrow_particles.visible = false
		_arrow_particles.emitting = false
	
	# Restaurar retrato
	if _character_portrait:
		_character_portrait.texture = PORTRAIT_NORMAL
		_arrow_particles.emitting = false

func _on_mask_timer_timeout():
	# Se acabó el tiempo
	hide_mask_overlay()
	
	# Reactivar botón
	if _mask_button:
		_mask_button.disabled = false

func _on_mask_button_pressed():
	toggle_mask_mode()

# =============================================================================
# EVENTOS DE CAMBIO DE ESCENA
# =============================================================================

func _on_scene_transition_completed():
	# Cuando se completa una transición, la escena debe configurar su UI
	# Esto se hace desde cada escena en su _ready()
	pass

# =============================================================================
# LÓGICA DE INVENTARIO
# =============================================================================

func _initialize_inventory_data():
	# Cargar o crear recurso de inventario
	if ResourceLoader.exists(INVENTORY_RESOURCE_PATH):
		_inventory_data = load(INVENTORY_RESOURCE_PATH)
	else:
		_inventory_data = Inventory.new()
		# Opcional: Guardar el nuevo recurso para que persista (si se desea)
		# ResourceSaver.save(_inventory_data, INVENTORY_RESOURCE_PATH)
	
	update_inventory_slots()

## Añade un item al inventario
## Retorna true si se añadió con éxito, false si está lleno
func register_item(item: InventoryItem) -> bool:
	print("UI_manager: register_item solicitado para: ", item.name)
	if not _inventory_data:
		push_error("UI_manager: Datos de inventario no inicializados")
		return false
		
	if _inventory_data.items.size() >= MAX_INVENTORY_SLOTS:
		print("Inventario lleno") # TODO: Feedback visual
		return false
	
	_inventory_data.items.append(item)
	update_inventory_slots()
	AudioManager.play_sfx("item_found")
	return true

## Actualiza la visualización de los slots
func update_inventory_slots():
	if not _inventory_items_container:
		return
		
	var items = _inventory_data.items
	for i in range(_inventory_slots.size()):
		var slot_node = _inventory_slots[i]
		if i < items.size():
			slot_node.update_slot(items[i])
		else:
			slot_node.update_slot(null)

## Alterna la visibilidad del inventario
func toggle_inventory():
	if _inventory_panel:
		_inventory_panel.visible = not _inventory_panel.visible
		if _inventory_panel.visible:
			AudioManager.play_sfx("inv_open")
		else:
			AudioManager.play_sfx("inv_close")

# =============================================================================
# LÓGICA DE SELECCIÓN Y USO DE ITEMS (DRAG & DROP)
# =============================================================================

## Selecciona un item del inventario para su uso
func select_item(item: InventoryItem):
	if not item:
		return
		
	_selected_item = item
	print("UI_manager: Item seleccionado -> ", item.name)
	
	# Cambiar cursor visualmente
	CursorManager.set_custom_icon_cursor(item.texture)
	
	# Opcional: Cerrar inventario para ver mejor la escena
	if _inventory_panel and _inventory_panel.visible:
		toggle_inventory()

## Deselecciona el item actual
func deselect_item():
	if _selected_item:
		print("UI_manager: Item deseleccionado -> ", _selected_item.name)
		_selected_item = null
		CursorManager.reset_cursor()

## Intenta usar el item seleccionado en una zona
## Retorna true si tuvo éxito (era el item correcto)
func try_place_item(required_item_name: String) -> bool:
	if not _selected_item:
		return false
		
	# Comparación por nombre (puedes cambiarlo a ID si prefieres)
	if _selected_item.name == required_item_name:
		print("UI_manager: Item colocado correctamente -> ", _selected_item.name)
		
		# Consumir item
		_inventory_data.items.erase(_selected_item)
		update_inventory_slots()
		
		# Limpiar selección
		deselect_item()
		return true
		
	print("UI_manager: Item incorrecto. Se esperaba: ", required_item_name, " pero se tiene: ", _selected_item.name)
	return false

## Obtener el item actualmente seleccionado
func get_selected_item() -> InventoryItem:
	return _selected_item

func _unhandled_input(event):
	# Cancelar selección con Clic Derecho
	if _selected_item and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			print("UI_manager: Clic Derecho, cancelando selección.")
			deselect_item()
			get_viewport().set_input_as_handled()

func activar():
	if not activo:
		inventory_button.visible = false
		character_portrait.visible = false
		return
	else:
		inventory_button.visible = true
		character_portrait.visible = true
		return
