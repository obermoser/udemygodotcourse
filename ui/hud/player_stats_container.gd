extends VBoxContainer

@onready var energybar: TextureProgressBar = $Energybar
@onready var healthbar: TextureProgressBar = $Healthbar

func _enter_tree() -> void:
	EventSystem.PLA_energy_updated.connect(energy_updated)
	EventSystem.PLA_health_updated.connect(health_updated)
	

func energy_updated(max_energy:float, current_energy:float)->void:
	energybar.max_value = max_energy
	energybar.value = current_energy

func health_updated(max_health:float, current_health:float)->void:
	healthbar.max_value = max_health
	healthbar.value = current_health
