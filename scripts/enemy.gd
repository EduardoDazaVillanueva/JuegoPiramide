extends CharacterBody2D

const SPEED = 60
var direction = -1
var dead = 1
var hit = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight

func _physics_process(delta: float) -> void:
	Dead()
	handle_movement(delta)

# Método para mover al enemigo
func handle_movement(delta: float):
	# Verificar colisión a la derecha y si no es el jugador
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false

	# Verificar colisión a la izquierda y si no es el jugador
	elif ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true
	
	# Actualizar la posición manualmente
	position.x += SPEED * delta * direction

# Función cuando el enemigo colisiona con el jugador
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		animated_sprite_2d.play("ata")
		body.losing_life()
		await(animated_sprite_2d.animation_finished)
		
		animated_sprite_2d.play("walk")
	
	if body.is_in_group("bala"):
		hit = true
		Dead()
		body.queue_free()



func Dead():
	if hit == true:
		if dead > 0:
			set_physics_process(false)
			animated_sprite_2d.play("dead")
			await(animated_sprite_2d.animation_finished)
			queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bala"):
		hit = true
		Dead()
		area.queue_free()
