extends Node

#region Bulletins
signal BUL_create_bulletin
signal BUL_destroy_bulletin
#endregion

#region Inventory
signal INV_try_to_pickup_item
signal INV_ask_update_inventory
signal INV_inventory_updated
signal INV_hotbar_updated
signal INV_switch_two_item_indexes
signal INV_add_item
signal INV_delete_crafting_blueprint_costs
#endregion

#region Player
signal PLA_freeze_player
signal PLA_unfreeze_player
#endregion

#region Item equipping
signal EQU_hotkey_pressed
signal EQU_equip_item
signal EQU_unequip_item
signal EQU_active_hotbar_slot_updated
#endregion
