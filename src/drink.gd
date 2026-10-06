class_name Drink

const COFFEE_NAMES: Array[String] = [
	"Light Roast Coffee",
	"Medium Roast Coffee",
	"Dark Roast Coffee",
]

const TEA_NAMES: Array[String] = [
	"Green Tea",
	"Black Tea",
	"Raspberry Tea",
	"Jasmine Tea",
	"Peppermint Tea",
	"Oolong Tea",
	"Matcha Tea",
]

const DRINK_NAMES: Array[String] = COFFEE_NAMES + TEA_NAMES

var name: String
# Using a pseudo-set truthy dict, because we don't want an addition included twice
var additions: Dictionary[Addition, bool] = { }

var addition_list_string: String:
	get:
		return " and ".join(additions.keys().map(get_addition_name))

enum Addition {
	MILK,
	SUGAR,
	CREAM,
}


func add_addition(addition: Addition) -> void:
	additions[addition] = true


func has_additions() -> bool:
	return not additions.is_empty()


static func get_addition_name(addition: Addition) -> String:
	var addition_name: String = Addition.find_key(addition)
	return addition_name.capitalize()


@warning_ignore("shadowed_variable")
func _init(name: String) -> void:
	self.name = name


static func make_random() -> Drink:
	var name_pool: Array[String] = [COFFEE_NAMES, TEA_NAMES].pick_random()
	var drink := Drink.new(name_pool.pick_random() as String)

	var possible_additions: Array[Addition] = [Addition.MILK, Addition.SUGAR, Addition.CREAM]
	possible_additions.shuffle()

	if randf() > 0.5:
		drink.add_addition(possible_additions.pop_front() as Addition)

		if randf() > 0.5:
			drink.add_addition(possible_additions.pop_front() as Addition)

	return drink
