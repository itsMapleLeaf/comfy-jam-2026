@tool
class_name ItemSlot
extends Button

var accepts: Callable = _default_accepts

@onready var sprite: ItemSprite = %ItemSprite


func _ready() -> void:
	refresh()


func refresh() -> void:
	sprite.refresh()


func _default_accepts(_item: ItemState) -> bool:
	return true


func has_item() -> bool:
	return sprite.item != null


func decrement_item_count() -> void:
	var new_item := sprite.item
	new_item.duplicate()
	new_item.count -= 1

	if new_item.count > 0:
		sprite.item = new_item
	else:
		sprite.item = null


func try_place(item: ItemState) -> bool:
	var accepted: bool = accepts.call(item)
	if accepted:
		sprite.item = item
	return accepted
