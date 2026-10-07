class_name Helpers


static func yes_no(yes: bool) -> String:
	return "Yes" if yes else "No"


static func remove_all_children(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()
