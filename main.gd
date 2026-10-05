extends Control

var current_shop_view := ShopView.FRONT_COUNTER

enum ShopView {
	FRONT_COUNTER,
	BACK_COUNTER,
}


class Mug:
	var contents: Coffee = null


class Coffee:
	var roast: CoffeeRoast


class CoffeeGrounds:
	var roast: CoffeeRoast


enum CoffeeRoast {
	LIGHT,
	MEDIUM,
	DARK,
}


class CoffeeMachine:
	var grounds: CoffeeGrounds = null


class Customer:
	var order: Coffee


var cursor_item: CursorItem


@abstract class CursorItem:
	pass


class CoffeeGroundsCursorItem extends CursorItem:
	var roast: CoffeeRoast


class MugCursorItem extends CursorItem:
	var mug: Mug


class CoffeeMakerCursorItem extends CursorItem:
	var coffee_maker: CoffeeMachine


func _ready() -> void:
	match cursor_item:
		var item when item is CoffeeGroundsCursorItem:
			print(item.roast)
