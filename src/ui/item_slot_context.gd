class_name ItemSlotContext
extends Node

signal slot_changed

const ITEM_SPRITE = preload("uid://bko34xbjepf62")

@onready var active_sprite: ItemSprite = ITEM_SPRITE.instantiate()


func _ready() -> void:
	add_child(active_sprite)


func register(slot: ItemSlot) -> void:
	slot.pressed.connect(_on_slot_pressed.bind(slot))


func _on_slot_pressed(slot: ItemSlot) -> void:
	if slot.sprite.item and not active_sprite.item:
		active_sprite.item = slot.sprite.item
		slot.sprite.item = null

		slot_changed.emit()

	elif not slot.sprite.item and active_sprite.item:
		slot.sprite.item = active_sprite.item
		active_sprite.item = null

		slot_changed.emit()

	elif slot.sprite.item and active_sprite.item:
		var slot_item := slot.sprite.item
		slot.sprite.item = active_sprite.item
		active_sprite.item = slot_item

		slot_changed.emit()


func _process(delta: float) -> void:
	active_sprite.global_position = active_sprite.global_position.lerp(
		get_viewport().get_mouse_position() - active_sprite.size / 2,
		delta * 40,
	)
