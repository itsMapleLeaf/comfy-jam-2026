@abstract
class_name MugEffect


@abstract func apply(item: ItemState) -> void


class DarkenRoast extends MugEffect:
	const ROAST_ORDER := [
		ItemLibrary.DRINK_COFFEE_LIGHT_ROAST,
		ItemLibrary.DRINK_COFFEE_MEDIUM_ROAST,
		ItemLibrary.DRINK_COFFEE_DARK_ROAST,
	]


	func apply(item: ItemState) -> void:
		var current_roast_index := ROAST_ORDER.find(item.spec)
		if current_roast_index == -1:
			push_warning("Not a valid drink: %s" % item.spec.get_class())
			return

		item.spec = ROAST_ORDER[clampi(current_roast_index + 1, 0, ROAST_ORDER.size())]
