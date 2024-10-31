extends RigidBody2D

var initial_velocity: Vector2

func _ready() -> void:
	linear_velocity = initial_velocity

func _physics_process(delta: float) -> void:
	linear_velocity.y += delta

#eliminar con un timer
func _on_timer_timeout() -> void:
	queue_free()
