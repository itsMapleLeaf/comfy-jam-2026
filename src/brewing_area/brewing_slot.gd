class_name BrewingSlot
extends BoxContainer

# signal brewed(drink: ItemInstance)

@export var brew_duration := 0.5

var remaining_brew_time := 0.0
var is_brewing: bool:
	get:
		return remaining_brew_time > 0

@onready var ingredient_slot: ItemSlot = %IngredientSlot
@onready var mug_slot: ItemSlot = %MugSlot
@onready var brew_button: Button = %BrewButton


func _ready() -> void:
	brew_button.pressed.connect(_on_brew_button_pressed)

	ingredient_slot.accepts = func(item: ItemInstance) -> bool:
		return item.spec is IngredientSpec

	mug_slot.accepts = func(item: ItemInstance) -> bool:
		return item is MugInstance

	refresh()


func _process(delta: float) -> void:
	if _advance_brew(delta):
		_complete_brew()


func _start_brew() -> void:
	if is_brewing:
		return
	remaining_brew_time = brew_duration
	refresh()


func _complete_brew() -> void:
	var mug: MugInstance = mug_slot.get_item()
	mug.spec = (ingredient_slot.get_item_spec() as IngredientSpec).brews

	ingredient_slot.decrement_item_count()

	refresh()


func _advance_brew(delta: float) -> bool:
	if remaining_brew_time > 0:
		remaining_brew_time -= delta
		if remaining_brew_time < 0:
			return true

	return false


func _on_brew_button_pressed() -> void:
	_start_brew()


func refresh() -> void:
	if is_brewing:
		brew_button.disabled = true
		brew_button.text = "Brewing..."
	else:
		brew_button.disabled = not ingredient_slot.has_item() or not mug_slot.has_item()
		brew_button.text = "Brew"

	ingredient_slot.refresh()
	mug_slot.refresh()


func register_item_slots(context: ItemSlotContext) -> void:
	context.register(ingredient_slot)
	context.register(mug_slot)


func apply_mug_effects() -> void:
	var mug_item := mug_slot.get_item() as MugInstance
	if mug_item:
		mug_item.effect.apply(mug_item)
		mug_slot.refresh()
