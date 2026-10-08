@tool
class_name ItemSprite
extends PanelContainer

@export var item: ItemState = null:
	set(new_item):
		item = new_item
		refresh()

@onready var image: TextureRect = %Image
@onready var count_label: Label = %CountLabel


func _ready() -> void:
	refresh.call_deferred()


func _notification(what: int) -> void:
	if what == NOTIFICATION_EDITOR_PRE_SAVE:
		refresh()


func refresh() -> void:
	if not is_node_ready():
		return

	if item and item.spec:
		tooltip_text = item.spec.name
		image.texture = item.spec.texture
	else:
		tooltip_text = ""
		image.texture = null

	count_label.text = str(item.count) if item and item.count != 1 else ""
