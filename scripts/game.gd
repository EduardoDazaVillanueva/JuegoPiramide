extends Node2D

@onready var hearts_container: HBoxContainer = $CanvasLayer/HeartsContainer
@onready var player: CharacterBody2D = $player
@onready var respawn_position = player.global_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hearts_container.updateHearts(player.currentHealth)
	player.healthChanged.connect(hearts_container.updateHearts)

func _on_check_point_body_entered(body):
	if body == player:
		respawn_position = player.global_position

func get_respawn_position() -> Vector2:
	print(respawn_position)
	return respawn_position
