extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

var player_in_area: bool = false

func _ready() -> void:
	sprite_2d.visible = true
	animated_sprite_2d.visible = false
	animated_sprite_2d.connect("animation_finished", Callable(self, "_on_animation_finished"))

# Cuando el jugador entra en el área
func _on_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  
		player_in_area = true
		sprite_2d.visible = false 
		animated_sprite_2d.visible = true
		animated_sprite_2d.play("sacar")

# Cuando el jugador sale del área
func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("player"):  
		player_in_area = false
		animated_sprite_2d.play("guardar") 

# Evento cuando termina la animación
func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "guardar" and not player_in_area:
		print("Animación 'guardar' terminada")
		animated_sprite_2d.visible = false
		sprite_2d.visible = true 
