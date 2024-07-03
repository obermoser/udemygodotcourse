extends Bulletin

@onready var inventory_slots: GridContainer = %InventorySlots

func _enter_tree() -> void:
	EventSystem.INV_inventory_updated.connect(update_inventory_slots)
	
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventSystem.PLA_freeze_player.emit()
	EventSystem.INV_ask_update_inventory.emit()
	
func close() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
	EventSystem.PLA_unfreeze_player.emit()

func update_inventory_slots(inventory:Array)->void:
		for i in inventory.size():
			inventory_slots.get_child(i).set_item_key(inventory[i])
