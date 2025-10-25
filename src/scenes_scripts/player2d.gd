extends CharacterBody2D

@export var hud_label_path: NodePath = "../Label"
@export var leafblow_path: NodePath = "../LeafblowParticles"
@export var footstep_audio_path: NodePath = "FootstepAudio"
@export var pile_audio_path: NodePath = "SFXAudio"
#@export var leafblow : PackedScene = load("res://src/scenes_scripts/leafblow_particles.tscn")
var hud_label : Label
var leafblow : CPUParticles2D
var footstep_audio : AudioStreamPlayer2D
var pile_audio : AudioStreamPlayer2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MIN_LEAVES_BLOWN = 25
const MAX_LEAVES_BLOWN = 150

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var piles_found = 0
const piles_found_total = 10
var special_items_found = 0
const special_items_total = 3

func _ready() -> void:
	hud_label = get_node(hud_label_path)
	leafblow = get_node(leafblow_path)
	footstep_audio = get_node(footstep_audio_path)
	pile_audio = get_node(pile_audio_path)


#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#
	#move_and_slide()
		#

func _physics_process(delta):
	var direction_topdown = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction_topdown * SPEED
	
	#if $CharSprite.position.y > 50:
		#$CharSprite.position.y += gravity * delta
	#elif  $CharSprite.position.y < 0: 
		#$CharSprite.position.y = 0
	if Input.is_action_just_pressed("ui_accept"):
		#$CharSprite.position.y += JUMP_VELOCITY * delta
		$AnimationPlayer.play("jump")
	
	move_and_slide()
	
	var direction = direction_topdown.x
	
	leafblow.orbit_velocity_max = direction + 1
	leafblow.orbit_velocity_min = direction
	leafblow.direction.x = direction
	leafblow.emitting = (direction != 0)
	footstep_audio.stream_paused = (direction_topdown.length_squared() == 0) or not is_on_floor()
	leafblow.position = position + Vector2(32 * direction, -32)
	if direction != 0:
		$CharSprite.scale = Vector2(direction, 1)


func _on_player_detect_body_entered(body: Node2D) -> void:
	print("collectible found")
	piles_found += 1
	hud_label.text = "%d/%d piles raked
	%d/%d items found" % [piles_found, piles_found_total, special_items_found, special_items_total]
	body.get_parent().collect()
	leafblow.amount = MAX_LEAVES_BLOWN
	pile_audio.play()

func _on_finish_pile_timer_timeout() -> void:
	# runs repeatedly and automatically
	if leafblow.amount > MIN_LEAVES_BLOWN:
		leafblow.amount -= 10
