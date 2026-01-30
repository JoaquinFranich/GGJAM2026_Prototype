extends Node

## Singleton para mostrar paneles de diálogo con efecto máquina de escribir y fade.
## Uso: DialogueManager.show_dialogue([ { "speaker": "main", "text": "Hola." } ])

signal dialogue_started
signal dialogue_finished

# Escena del panel (se instancia al iniciar)
var _panel_scene: PackedScene
var _canvas: CanvasLayer
var _click_overlay: ColorRect
var _panel: PanelContainer
var _portrait: TextureRect
var _text_label: RichTextLabel

# Cola de bloques: cada bloque es { "speaker": "main"|"other", "text": "..." }
var _blocks: Array = []
var _current_index: int = -1

# Efecto máquina de escribir
var _full_text: String = ""
var _visible_chars: int = 0
var _typewriter_timer: float = 0.0
var _chars_per_second: float = 30.0
var _is_typing: bool = false

# Rutas de caras por speaker (preparado para varios personajes)
var _speaker_portraits: Dictionary = {
	"main": "res://Assets/Images/HandCursor.png",   # Placeholder; sustituir por retrato real
	"other": "res://icon.svg",                       # Placeholder para el otro personaje
}

const FADE_DURATION: float = 0.25

func _ready():
	_panel_scene = load("res://Scenes/UI/dialogue_panel.tscn") as PackedScene
	if _panel_scene:
		_canvas = _panel_scene.instantiate()
		add_child(_canvas)
		_click_overlay = _canvas.get_node_or_null("ClickOverlay")
		_panel = _canvas.get_node_or_null("Panel")
		if _panel:
			_portrait = _panel.get_node_or_null("MarginContainer/HBoxContainer/Portrait")
			_text_label = _panel.get_node_or_null("MarginContainer/HBoxContainer/TextLabel")
		if _click_overlay:
			_click_overlay.gui_input.connect(_on_overlay_gui_input)
	else:
		push_error("DialogueManager: No se pudo cargar res://Scenes/UI/dialogue_panel.tscn")

func _process(delta: float):
	if not _is_typing:
		return
	if _text_label == null:
		return
	_typewriter_timer += delta
	var need = int(_typewriter_timer * _chars_per_second)
	if need > _full_text.length():
		need = _full_text.length()
		_is_typing = false
	if need != _visible_chars:
		_visible_chars = need
		_text_label.visible_characters = _visible_chars

## Muestra un diálogo. blocks: Array de { "speaker": "main"|"other", "text": "..." }
func show_dialogue(blocks: Array) -> void:
	if blocks.is_empty():
		return
	_blocks.clear()
	for b in blocks:
		if b is Dictionary and b.has("text"):
			_blocks.append(b)
		elif b is String:
			_blocks.append({ "speaker": "main", "text": b })
	if _blocks.is_empty():
		return
	_current_index = 0
	dialogue_started.emit()
	_show_current_block()

func _show_current_block() -> void:
	if _current_index < 0 or _current_index >= _blocks.size():
		_close_dialogue()
		return
	var block = _blocks[_current_index]
	var speaker: String = block.get("speaker", "main")
	var text: String = block.get("text", "")
	_full_text = text
	_visible_chars = 0
	_is_typing = true
	_typewriter_timer = 0.0
	if _text_label:
		_text_label.text = text
		_text_label.visible_characters = 0
	if _portrait:
		var tex = _get_speaker_texture(speaker)
		_portrait.texture = tex
	_click_overlay.visible = true
	_panel.visible = true
	_panel.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(_panel, "modulate:a", 1.0, FADE_DURATION)

func _close_dialogue() -> void:
	if _panel:
		var tween = create_tween()
		tween.tween_property(_panel, "modulate:a", 0.0, FADE_DURATION)
		await tween.finished
	if _click_overlay:
		_click_overlay.visible = false
	if _panel:
		_panel.visible = false
	_blocks.clear()
	_current_index = -1
	dialogue_finished.emit()

func _on_overlay_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb = event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			if _is_typing:
				# Completar texto
				_is_typing = false
				_visible_chars = _full_text.length()
				if _text_label:
					_text_label.visible_characters = _visible_chars
			else:
				# Siguiente bloque o cerrar
				_current_index += 1
				_show_current_block()

func _get_speaker_texture(speaker_id: String) -> Texture2D:
	if _speaker_portraits.has(speaker_id):
		var path: String = _speaker_portraits[speaker_id]
		if ResourceLoader.exists(path):
			return load(path) as Texture2D
	return null

## Define la textura del retrato para un speaker (para varios personajes)
func set_speaker_portrait(speaker_id: String, texture_path: String) -> void:
	_speaker_portraits[speaker_id] = texture_path

## Velocidad del efecto máquina de escribir (caracteres por segundo)
func set_typewriter_speed(chars_per_second: float) -> void:
	_chars_per_second = chars_per_second
