class_name Drink

const DRINK_NAMES: Array[String] = [
	"Light Roast Coffee",
	"Medium Roast Coffee",
	"Dark Roast Coffee",
	"Green Tea",
	"Black Tea",
	"Raspberry Tea",
	"Jasmine Tea",
	"Peppermint Tea",
	"Oolong Tea",
	"Matcha Tea",
]

var name: String
var additions: Dictionary[Addition, bool] = { }

var addition_list_string: String:
	get:
		return ", ".join(additions.keys().map(get_addition_name))

enum Addition {
	MILK,
	SUGAR,
	CREAM,
}


func add_addition(addition: Addition) -> void:
	additions[addition] = true


static func get_addition_name(addition: Addition) -> String:
	var addition_name: String = Addition.find_key(addition)
	return addition_name.capitalize()


@warning_ignore("shadowed_variable")
func _init(name: String) -> void:
	self.name = name


static func make_random() -> Drink:
	var drink := Drink.new(DRINK_NAMES.pick_random() as String)

	var possible_additions: Array[Addition] = [Addition.MILK, Addition.SUGAR, Addition.CREAM]
	possible_additions.shuffle()

	for i in randi() % (possible_additions.size() + 1):
		drink.add_addition(possible_additions[i])

	return drink
