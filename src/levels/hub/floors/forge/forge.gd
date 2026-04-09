extends EndlessHubFloor

@onready var BUILDER_BENCH: Node3D = %BuilderBench
@onready var STOCKING_STATION: Node3D = %SocketingStation
@onready var LOADOUT_TERMINAL: Node3D = %LoadoutTerminal
@onready var PROVISIONER: Node3D = %Provisioner
@onready var STANDARD_ISSUE_TERMINAL: Node3D = %StandardIssueTerminal
@onready var DISMANTLER: Node3D = %Dismantler

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
