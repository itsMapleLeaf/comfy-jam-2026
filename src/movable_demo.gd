class_name MovableDemo
extends Control


func _ready() -> void:
	var movable := Movable.new()
	add_child(movable)

	var slots: Array[DemoSlot] = [
		DemoSlot.new(DemoItem.new(Color.PALE_VIOLET_RED)),
		DemoSlot.new(DemoItem.new(Color.SEA_GREEN)),
		DemoSlot.new(),
	]

	for i in slots.size():
		var slot := slots[i]
		slot.position = Vector2(100, 100) + Vector2(80 * i, 0)
		movable.add_child(slot)


class DemoItem extends Movable.Item:
	var initial_color: Color


	@warning_ignore("shadowed_variable")
	func _init(
		initial_color: Color
	) -> void:
		self.initial_color = initial_color


	func _ready() -> void:
		var rect := ColorRect.new()
		add_child(rect)
		rect.color = initial_color
		rect.size = Vector2(48, 48)
		rect.position = Vector2.ZERO
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		size = rect.size
		super()


class DemoSlot extends Movable.Slot:
	func _ready() -> void:
		var rect := ColorRect.new()
		add_child(rect)
		rect.color = Color(0, 0, 0, 0.5)
		rect.size = Vector2(64, 64)
		rect.position = Vector2.ZERO
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		size = rect.size
		super()
