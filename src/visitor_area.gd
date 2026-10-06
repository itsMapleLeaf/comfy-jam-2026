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


var visitors: Array[Visitor] = [Visitor.new(), Visitor.new(), Visitor.new()]
@onready var visitor_list_container: FlowContainer = %VisitorListContainer


func _ready() -> void:
	_render()


func _render() -> void:
	for child in visitor_list_container.get_children():
		child.queue_free()

	for visitor in visitors:
		var label := Label.new()
		label.text = visitor.display_text()
		visitor_list_container.add_child(label)


func _on_back_counter_button_pressed() -> void:
	request_show_brewing_area.emit()
