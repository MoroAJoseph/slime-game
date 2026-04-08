extends EndlessHubFloor

@onready var TRANSIT_POD: Node3D = %TransitPod
@onready var JUMP_START_TERMINAL: Node3D = %JumpStartTerminal
@onready var HOLO_GLOBE_CONSOLE: Node3D = %HoloGlobeConsole
@onready var LIVING_QUARTERS: Node3D = %LivingQuarters

# ===
# Built-In
# ===

func _ready() -> void:
	EventBus.subscribe(_on_event)

# ===
# Events
# ===

func _on_event(_event: Event) -> void:
	pass
