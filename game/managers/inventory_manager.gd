extends Node
class_name InventoryManager

const inventory_size := 28

var inventory:Array = []

func _enter_tree() -> void:
	EventSystem.INV_try_to_pickup_item.connect(try_to_pickup_item)
	EventSystem.INV_ask_update_inventory.connect(send_inventory)
	EventSystem.INV_switch_two_item_indexes.connect(switch_item_index)
	EventSystem.INV_add_item.connect(add_item)
	
func _ready() -> void:
	inventory.resize(inventory_size)
	
func try_to_pickup_item(item_key: ItemConfig.Keys, destroy_pickupable:Callable) -> void:
	if not get_free_slots():
		return 
	add_item(item_key)
	destroy_pickupable.call()

func get_free_slots() -> int:
	return inventory.count(null)
	
func add_item(item_key: ItemConfig.Keys) -> void:
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = item_key
			break
	send_inventory()

func send_inventory()->void:
	EventSystem.INV_inventory_updated.emit(inventory)

func switch_item_index(idx1:int, idx2:int)->void:
	var item_key1 = inventory[idx1]
	inventory[idx1]=inventory[idx2]
	inventory[idx2]=item_key1
	send_inventory()
