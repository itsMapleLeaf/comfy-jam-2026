class_name BrewingSlot
extends BoxContainer

signal brewed(drink: ItemState)

@export var brew_duration := 3.0

var remaining_brew_time := 0.0
var is_brewing: bool:
	get:
		return remaining_brew_time > 0

@onready var ingredient_slot: ItemSlot = %IngredientSlot
@onready var mug_slot: ItemSlot = %MugSlot
@onready var brew_button: Button = %BrewButton


func _ready() -> void:
	brew_button.pressed.connect(_on_brew_button_pressed)

	ingredient_slot.accepts = func(item: ItemState) -> bool:
		return item.spec is IngredientSpec

	mug_slot.accepts = func(item: ItemState) -> bool:
		return item.spec.type == ItemSpec.ItemType.MUG

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
	var drink := ItemState.new()
	drink.spec = (ingredient_slot.get_item_spec() as IngredientSpec).brews

	ingredient_slot.decrement_item_count()
	mug_slot.overwrite_item(drink)

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


func apply_mug_effects(mug_effects: Dictionary[int, MugEffect]) -> void:
	var mug_item := mug_slot.get_item()
	if not mug_item:
		return

	var effect: MugEffect = mug_effects.get(mug_item.id)
	if not effect:
		return

	effect.apply(mug_item)
	mug_slot.refresh()
