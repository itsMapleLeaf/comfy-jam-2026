class_name BrewingSlot
extends BoxContainer

@onready var ingredient_slot: ItemSlot = %IngredientSlot
@onready var mug_slot: ItemSlot = %MugSlot
@onready var brew_button: Button = %BrewButton


func _ready() -> void:
	brew_button.pressed.connect(_on_brew_button_pressed)
	refresh()


func _on_brew_button_pressed() -> void:
	var new_item := ingredient_slot.sprite.item
	new_item.duplicate()
	new_item.count -= 1
	ingredient_slot.sprite.item = new_item
	refresh()


func refresh() -> void:
	brew_button.disabled = ingredient_slot.sprite.item == null
	ingredient_slot.refresh()
	mug_slot.refresh()


func register_item_slots(context: ItemSlotContext) -> void:
	context.register(ingredient_slot)
	context.register(mug_slot)
