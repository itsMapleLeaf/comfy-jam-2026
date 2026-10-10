class_name MugInstance
extends ItemInstance

var effect: Effect


class Effect:
	func apply(_mug: MugInstance) -> void:
		pass


	class DarkenRoast extends Effect:
		func apply(mug: MugInstance) -> void:
			match mug.spec:
				ItemLibrary.DRINK_COFFEE_LIGHT_ROAST:
					mug.spec = ItemLibrary.DRINK_COFFEE_MEDIUM_ROAST
				ItemLibrary.DRINK_COFFEE_MEDIUM_ROAST:
					mug.spec = ItemLibrary.DRINK_COFFEE_DARK_ROAST
