class_name Movable
extends Control

var active_item: Item = null


func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)


func _on_child_entered_tree(child: Node) -> void:
	var slot := child as Slot
	if not slot:
		return

	add_child(slot)
	slot.clicked.connect(_on_slot_clicked.bind(slot))


func _on_slot_clicked(slot: Slot) -> void:
	if not slot.item and active_item:
		slot.accept(active_item)
		active_item = null

	elif slot.item and not active_item:
		_set_active_item(slot.item)
		slot.item = null

	elif slot.item and active_item:
		var new_active_item := slot.item
		slot.accept(active_item)
		_set_active_item(new_active_item)


func _set_active_item(item: Item) -> void:
	active_item = item
	active_item.reparent(self)


func _process(_delta: float) -> void:
	if active_item:
		active_item.global_position = get_global_mouse_position() - active_item.size / 2


class Item extends Control:
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE


class Slot extends Control:
	var item: Item = null

	signal clicked


	func _init(item_init: Item = null) -> void:
		item = item_init


	func _ready() -> void:
		if item:
			accept(item)


	func _gui_input(event: InputEvent) -> void:
		var button_event := event as InputEventMouseButton

		var is_left_mouse_down := (
			button_event and button_event.pressed and button_event.button_index == MOUSE_BUTTON_LEFT
		)

		if is_left_mouse_down:
			clicked.emit()


	func accept(accepted_item: Item) -> void:
		item = accepted_item
		if item.get_parent():
			item.reparent(self)
		else:
			add_child(item)
		item.global_position = (get_global_rect().get_center() - item.size / 2)
