class_name UserData
extends Resource

enum KernelType { WINDOWS, LINUX, MAC }

@export var username: String
@export var current_kernel: KernelType
@export var user_agent: String
