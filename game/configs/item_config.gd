class_name ItemConfig

enum Keys {
	#Pickupables
	Stick,
	Stone,
	Plant,
	Mushroom,
	Fruit,
	Log,
	Coal,
	Flintstone,
	RawMeat,
	CookedMeat,
	#Craftables
	Axe,
	Pickaxe,
	Campfire,
	Multitool,
	Rope,
	Tinderbox,
	Torch,
	Tent,
	Raft
}

const CRAFTABLE_ITEM_KEYS : Array[Keys] = [
	Keys.Axe,
	#Keys.Pickaxe,
	#Keys.Campfire,
	#Keys.Multitool,
	Keys.Rope,
	#Keys.Tinderbox,
	#Keys.Torch,
	#Keys.Tent,
	#Keys.Raft
]

#region Items
const ITEM_RESOURCE_PATHS:={
	Keys.Stick:"res://resources/item_resources/stick_resource.tres",
	Keys.Stone:"res://resources/item_resources/stone_resource.tres",
	Keys.Plant:"res://resources/item_resources/plant_resource.tres",
	Keys.Axe:"res://resources/item_resources/axe_item_resource.tres",
	Keys.Pickaxe:"res://resources/item_resources/pickaxe_item_resource.tres",
	Keys.Rope:"res://resources/item_resources/rope_resource.tres",
	Keys.Log:"res://resources/item_resources/log_resource.tres",
	Keys.Mushroom:"res://resources/item_resources/mushroom_item_resource.tres",
	Keys.Coal: "res://resources/item_resources/coal_item_resource.tres",
	Keys.RawMeat: "res://resources/item_resources/raw_meat_item_resource.tres",
	Keys.Tent: "res://resources/item_resources/tent_resource.tres"
}

static func get_item_resource(key:Keys) -> ItemResource:
	return load(ITEM_RESOURCE_PATHS.get(key))
#endregion

#region Crafting
const CRAFTING_BLUEPRINT_RESOURCE_PAHTS:={
	Keys.Axe:"res://resources/crafting_blueprint_resources/axe_blueprint.tres",
	Keys.Rope:"res://resources/crafting_blueprint_resources/rope_blueprint.tres",
	Keys.Pickaxe: "res://resources/crafting_blueprint_resources/pickaxe_blueprint.tres"
}
static func get_crafting_blueprint_resource(key:Keys) -> CraftingBlueprintResource:
	return load(CRAFTING_BLUEPRINT_RESOURCE_PAHTS.get(key))
#endregion

#region Equipment
const EQUIPABLE_ITEM_PAHTS:={
	Keys.Axe:"res://items/equipables/equipable_axe.tscn",
	Keys.Mushroom: "res://items/equipables/equipable_mushroom.tscn",
	Keys.Pickaxe:"res://items/equipables/equipable_pickaxe.tscn",
	Keys.Tent:"res://items/equipables/equipable_tent.tscn"
}
static func get_equipable_item_resource(key:Keys)->PackedScene:
	return load(EQUIPABLE_ITEM_PAHTS[key])
#endregion

#region Pickupables
const PICKUPABLE_ITEM_PATHS:={
	Keys.Log:"res://items/interactables/rigid_pickupable_log.tscn",
	Keys.Coal: "res://items/interactables/rigid_pickupable_coal.tscn",
	Keys.RawMeat: "res://items/interactables/rigid_pickupable_raw_meat.tscn"
}
static func get_pickupable_item(key:Keys)->PackedScene:
	return load(PICKUPABLE_ITEM_PATHS[key])
#endregion

#region Constructables
const CONSTRUCTABLE_SCENES:={
	Keys.Tent:"res://objects/constructables/constructable_tent.tscn",

}
static func get_constructable_scene(key:Keys)->PackedScene:
	return load(CONSTRUCTABLE_SCENES[key])
#endregion
