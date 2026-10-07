class_name VisitorArea
extends Control

signal request_show_brewing_area

const VISITOR_NAMES: Array[String] = [
	# masculine(ish)
	"Ian",
	"Eli",
	"Alex",
	"Chris",
	"Brandon",
	# feminine(ish)
	"Violet",
	"Allison",
	"Emilia",
	"Serena",
	"Luna",
]


class Visitor:
	var name: String = VISITOR_NAMES.pick_random()
	var order := Drink.make_random()


	func display_text() -> String:
		var result := "%s orders a %s" % [name, order.name]
		if order.has_additions():
			result += " with %s" % order.addition_list_string
		return result


	func get_new_name() -> void:
		name = VISITOR_NAMES.pick_random()


var visitors: Array[Visitor] = []
@onready var visitor_list_container: Container = %VisitorListContainer


func _ready() -> void:
	for i in 3:
		_add_visitor()
	_render()


func _add_visitor() -> void:
	var visitor := Visitor.new()

	while _is_visitor_name_used(visitor):
		push_warning("Visitor name %s already taken" % visitor.name)
		visitor.get_new_name()

	visitors.append(visitor)


func _is_visitor_name_used(visitor: Visitor) -> bool:
	return visitors.any(
		func(v: Visitor):
			return v.name == visitor.name,
	)


func _render() -> void:
	for child in visitor_list_container.get_children():
		child.queue_free()

	for visitor in visitors:
		var label := Label.new()
		label.text = visitor.display_text()
		visitor_list_container.add_child(label)


func _on_back_counter_button_pressed() -> void:
	request_show_brewing_area.emit()
