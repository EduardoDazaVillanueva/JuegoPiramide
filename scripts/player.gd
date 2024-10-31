extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var can_move: bool = true
var currentHealth: int = 3

signal healthChanged

@onready var marker_der: Marker2D = $MarkerDer
@onready var marker_izq: Marker2D = $MarkerIzq
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $attack/CollisionShape2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var CameraManager: Node = $"../CameraManager"
@onready var game = get_parent()
@onready var balaTimer: Timer = $BalaTimer
@onready var flechaTimer: Timer = $FlechaTimer

func _ready() -> void:
	balaTimer.one_shot = true
	flechaTimer.one_shot = true

func _physics_process(delta: float) -> void:
	
	collision_shape_2d.disabled = true
	
	if can_move:
		# Add gravity
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if Input.is_action_just_pressed("ata"):
			animated_sprite_2d.visible = false
			sprite_2d.visible = true
			collision_shape_2d.disabled = false
			animation_player.play("attack")
			await(animation_player.animation_finished)
			collision_shape_2d.disabled = true

		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Handle movement and direction
		var direction := Input.get_axis("move_left", "move_right")
		
		if Input.is_action_just_pressed("shoot"):
			shoot()
		
		if Input.is_action_just_pressed("flecha"):
			shoot_flecha()
		
		if direction > 0:
			collision_shape_2d.position.x = 18.5
			animated_sprite_2d.flip_h = false
			sprite_2d.flip_h = false
		elif direction < 0:
			collision_shape_2d.position.x = -18.5
			animated_sprite_2d.flip_h = true
			sprite_2d.flip_h = true
		
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("jump")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"attack":
			animated_sprite_2d.visible = true
			sprite_2d.visible = false
	pass # Replace with function body.


func _on_attack_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit = true
	pass # Replace with function body.

func losing_life():
	currentHealth -= 1
	healthChanged.emit(currentHealth)
	if currentHealth <= 0:
		die_and_respawn()

# Función para morir y reaparecer
func die_and_respawn():
	currentHealth = 3
	healthChanged.emit(currentHealth)
	global_position = game.get_respawn_position()


func _on_area_2d_body_entered(body):
	if body.is_in_group("RigidBody"):
		body.collision_layer = 1
		body.collision_mask = 1

func _on_area_2d_body_exited(body):
	if body.is_in_group("RigidBody"):
		body.collision_layer = 2
		body.collision_mask = 2

func shoot():
	if balaTimer.is_stopped():
		const BALA = preload("res://scenes/bala.tscn")
		var new_bala = BALA.instantiate()
		if sprite_2d.flip_h:
			new_bala.global_position = marker_izq.global_position
			new_bala.initial_velocity = Vector2(-200, -300)
		else:
			new_bala.global_position = marker_der.global_position
			new_bala.initial_velocity = Vector2(200, -300)
		
		get_tree().current_scene.add_child(new_bala)
		balaTimer.start()

func shoot_flecha():
	if flechaTimer.is_stopped():
		const FLECHA = preload("res://scenes/flecha.tscn")
		var new_flecha = FLECHA.instantiate()
		
		if sprite_2d.flip_h:
			new_flecha.global_position = marker_izq.global_position
			new_flecha.speed = -400
			new_flecha.get_node("Sprite2D").rotation_degrees = 226
		else:
			new_flecha.global_position = marker_der.global_position
			new_flecha.speed = 400
		
		get_tree().current_scene.add_child(new_flecha)
		flechaTimer.start()
