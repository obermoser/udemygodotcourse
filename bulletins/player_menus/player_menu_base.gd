extends Bulletin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventSystem.PLA_freeze_player.emit()
	
	
func close() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
	EventSystem.PLA_unfreeze_player.emit()
