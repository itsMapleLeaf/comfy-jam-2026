class_name Inventory

var items: Array[Item] = []


func add_item(item: Item, count := 1) -> void:
	for _i in count:
		items.append(item)


func remove_item(item: Item) -> void:
	items.erase(item)


func get_item_counts() -> Dictionary[Item, int]:
	var counts: Dictionary[Item, int] = { }
	for item in items:
		counts[item] = (counts[item] if item in counts else 0) + 1
	return counts


class Item:
	var name: String
	var tooltip: String


	func _init(name_init: String, tooltip_init: String) -> void:
		name = name_init
		tooltip = tooltip_init


	func use() -> void:
		pass
