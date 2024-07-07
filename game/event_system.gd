extends Node

#region Bulletins
signal BUL_create_bulletin
signal BUL_destroy_bulletin
#endregion

#region Inventory
signal INV_try_to_pickup_item
signal INV_ask_update_inventory
signal INV_inventory_updated
signal INV_switch_two_item_indexes
signal INV_add_item
#endregion

#region Player
signal PLA_freeze_player
signal PLA_unfreeze_player
#endregion
