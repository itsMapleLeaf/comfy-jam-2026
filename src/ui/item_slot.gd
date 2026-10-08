@tool
class_name ItemSlot
extends Button

@onready var sprite: ItemSprite = %ItemSprite


func _ready() -> void:
	refresh()


func refresh() -> void:
	sprite.refresh()


func transfer(transferred_count: int, other: ItemSlot) -> void:
	#if other.item_data != null and other.item_data != item_data:
	#return
	#
	#transferred_count = [transferred_count, count, max_count if max_count > 0 else INT64_MAX].min()
	#other.item_data = item_data
	#other.count += transferred_count
	#count -= transferred_count
	pass
