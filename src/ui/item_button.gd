@tool
class_name ItemButton
extends Button

@export var data: ItemResource:
	set(new_data):
		data = new_data
		_update()

@onready var image: TextureRect = %Image


func _ready() -> void:
	_update()


func _update() -> void:
	if not is_node_ready():
		return

	if data:
		tooltip_text = data.name
		image.texture = data.texture
	else:
		tooltip_text = ""
		image.texture = null
