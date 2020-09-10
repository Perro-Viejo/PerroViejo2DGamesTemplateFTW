class_name Inventory
extends Node

export(int) var max_size = 0
var _inventory = {}
var _current_size = 0

func _add_item_to_inventory(item) -> bool:
	if _current_size + item.size <= max_size:
		if item.name in _inventory:
			_inventory[item.name].add(item)
		else:
			_inventory[item.name] = [item]
		item.container = self
		_current_size += item.size
		on_item_added(item)
		return true
	
	return false

func add_to_inventory(item) -> bool:
	if item.is_type("Item"):
		return _add_item_to_inventory(item)
	else:
		push_error("Object has to be or contain an Item to be added to an inventory") 
	return false

func _remove_item_from_inventory(item) -> bool:
	if item.name in _inventory:
		_inventory[name].erase(item)
		_current_size -= item.size
		
		if _inventory[item.name].empty():
			_inventory.erase(item.name)
		item.container = null
		on_item_removed(item)
		return true
	return false

func remove_from_inventory(item) -> bool:
	var is_item = item.is_type("Item")
	var contains_item = item.get_node("Item") != null
	
	if is_item or contains_item:
		return _remove_item_from_inventory(item)
	else:
		push_error("Object has to be or contain an Item to be removed from an inventory") 
	return false

func on_item_added(item) -> void:
	pass

func on_item_removed(item) -> void:
	pass
