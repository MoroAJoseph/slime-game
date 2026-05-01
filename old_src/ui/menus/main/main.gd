extends Control

@onready var _sandbox_button: Button = %Sandbox
@onready var _play_button: Button = %Play
@onready var _settings_button: Button = %Settings
@onready var _exit_button: Button = %Exit

# ===
# Built-In
# ===

func _ready() -> void:
	_sandbox_button.pressed.connect(_on_sandbox_pressed)
	_play_button.pressed.connect(_on_play_pressed)
	_settings_button.pressed.connect(_on_settings_pressed)
	_exit_button.pressed.connect(_on_exit_pressed)

# ===
# Signals
# ===

func _on_sandbox_pressed() -> void:
	UIEvent.MainMenu.new(UIEvent.MainMenuAction.SANDBOX)

func _on_play_pressed() -> void:
	UIEvent.MainMenu.new(UIEvent.MainMenuAction.PLAY)

func _on_settings_pressed() -> void:
	UIEvent.MainMenu.new(UIEvent.MainMenuAction.SETTINGS)

func _on_exit_pressed() -> void:
	UIEvent.MainMenu.new(UIEvent.MainMenuAction.EXIT)
