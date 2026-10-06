class_name VisitorArea
extends Control

signal request_show_brewing_area


func _on_back_counter_button_pressed() -> void:
	request_show_brewing_area.emit()
