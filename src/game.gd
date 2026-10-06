class_name Game
extends Node

@onready var visitor_area: VisitorArea = %VisitorArea
@onready var brewing_area: BrewingArea = %BrewingArea

var current_view: Control


func _ready() -> void:
	visitor_area.hide()
	brewing_area.hide()

	set_view(visitor_area)

	visitor_area.request_show_brewing_area.connect(set_view.bind(brewing_area))
	brewing_area.request_show_visitor_area.connect(set_view.bind(visitor_area))


func set_view(new_view: Control) -> void:
	if current_view:
		current_view.hide()
	current_view = new_view
	current_view.show()
