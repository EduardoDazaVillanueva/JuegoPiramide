extends CharacterBody2D

var player_in_area = false
var dialogue_active = false

@onready var exclamation: Sprite2D = $exclamation

@onready var player: CharacterBody2D = $"../../player"

@export var CameraManager: Node

func _ready() -> void:
	exclamation.visible = false
	Dialogic.signal_event.connect(DialogicSignal)

func _process(delta: float) -> void:
	
	if player_in_area:
		exclamation.visible = true
		if Input.is_action_just_pressed("talk") and not dialogue_active:
			player.can_move = false  # Desactivar el movimiento del jugador
			CameraManager.talk_npc()
			run_dialogue("npc1Giving")  # Iniciar el diálogo
			dialogue_active = true
	else:
		exclamation.visible = false 

func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string) # Iniciar el diálogo

func _on_chat_detection_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true

func _on_chat_detection_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false


func DialogicSignal(arg: String):
	if arg == "exit_npc":
		dialogue_active = false
		CameraManager.talk_npc()
		player.can_move = true
