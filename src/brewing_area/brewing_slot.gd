class_name BrewingSlot
extends BoxContainer

signal brewed(drink: ItemState)

@onready var ingredient_slot: ItemSlot = %IngredientSlot
@onready var mug_slot: ItemSlot = %MugSlot
@onready var brew_button: Button = %BrewButton


func _ready() -> void:
	brew_button.pressed.connect(_on_brew_button_pressed)

	ingredient_slot.accepts = func(item: ItemState) -> bool:
		return item.spec.type == ItemSpec.ItemType.INGREDIENT

	mug_slot.accepts = func(item: ItemState) -> bool:
		return item.spec.type == ItemSpec.ItemType.MUG

	refresh()


func _on_brew_button_pressed() -> void:
	ingredient_slot.decrement_item_count()
	mug_slot.decrement_item_count()

	var drink := ItemState.new()
	drink.spec = load("res://src/items/drink_coffee_light_roast.tres")

	brewed.emit(drink)

	refresh()


func refresh() -> void:
	brew_button.disabled = not ingredient_slot.has_item() or not mug_slot.has_item()
	ingredient_slot.refresh()
	mug_slot.refresh()


func register_item_slots(context: ItemSlotContext) -> void:
	context.register(ingredient_slot)
	context.register(mug_slot)
