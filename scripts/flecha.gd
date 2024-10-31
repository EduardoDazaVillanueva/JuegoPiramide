extends Area2D

var speed
@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	position.x += delta * speed

func _on_body_entered(body: Node2D) -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
