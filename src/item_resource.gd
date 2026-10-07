class_name ItemResource
extends Resource

@export var name := "Generic Item"
@export var type: ItemType
@export var texture: Texture

enum ItemType {
	MUG,
	INGREDIENT,
	DRINK,
}
