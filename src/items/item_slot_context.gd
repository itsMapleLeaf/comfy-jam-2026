class_name ItemSlotContext
extends Node

signal slot_changed

const ITEM_SPRITE = preload("uid://bko34xbjepf62")

var registered_slots: Array[ItemSlot] = []

@onready var active_sprite: ItemSprite = ITEM_SPRITE.instantiate()


func _ready() -> void:
	add_child(active_sprite)


func register(slot: ItemSlot) -> void:
	registered_slots.append(slot)
	slot.pressed.connect(_on_slot_pressed.bind(slot))


func _on_slot_pressed(slot: ItemSlot) -> void:
	if Input.is_action_pressed("quick_transfer_modifier"):
		_move_to_first_open_slot_in_next_zone(slot)
		return

	# picking up an item
	if slot.sprite.item and not active_sprite.item:
		active_sprite.item = slot.sprite.item
		slot.sprite.item = null

		slot_changed.emit()

	# placing an item
	elif not slot.sprite.item and active_sprite.item:
		if slot.set_item_if_empty_and_accepted(active_sprite.item):
			active_sprite.item = null
			slot_changed.emit()

	# swapping the item
	elif slot.sprite.item and active_sprite.item:
		var slot_item := slot.sprite.item
		if slot.set_item_if_empty_and_accepted(active_sprite.item):
			active_sprite.item = slot_item
			slot_changed.emit()


func _move_to_first_open_slot_in_next_zone(source_slot: ItemSlot):
	var zones := _get_zones()
	var next_zone_index := (zones.find(source_slot.zone) + 1) % zones.size()

	var next_zone: StringName = zones.get(next_zone_index)
	if not next_zone:
		push_warning("No next zone found")
		return

	var slots_in_next_zone := _get_zone_slots(next_zone)
	var destination_slot := _get_first_accepting_slot(slots_in_next_zone, source_slot.get_item())

	if destination_slot.set_item_if_empty_and_accepted(source_slot.get_item()):
		source_slot.remove_item()
		slot_changed.emit()


func _get_zones() -> Array[StringName]:
	var found_zones: Dictionary[StringName, bool] = { }
	for slot in registered_slots:
		found_zones[slot.zone] = true
	return found_zones.keys()


func _get_zone_slots(zone: StringName) -> Array[ItemSlot]:
	return registered_slots.filter(
		func(slot: ItemSlot):
			return slot.zone == zone,
	)


func _get_first_accepting_slot(slots: Array[ItemSlot], item: ItemInstance) -> ItemSlot:
	for slot in slots:
		if not slot.has_item() and slot.accepts.call(item):
			return slot

	return null


func _process(delta: float) -> void:
	active_sprite.global_position = active_sprite.global_position.lerp(
		get_viewport().get_mouse_position() - active_sprite.size / 2,
		delta * 40,
	)
