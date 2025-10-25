extends CharacterBody2D

@export var hud_label_path: NodePath = "../Label"
@export var leafblow_path: NodePath = "LeafblowParticles"
#@export var leafblow : PackedScene = load("res://src/scenes_scripts/leafblow_particles.tscn")
var hud_label : Label
var leafblow : CPUParticles2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var piles_found = 0
const piles_found_total = 10
var special_items_found = 0
const special_items_total = 3

func _ready() -> void:
	hud_label = get_node(hud_label_path)
	leafblow = get_node(leafblow_path)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	leafblow.orbit_velocity_min = direction
	leafblow.orbit_velocity_max = direction
	leafblow.emitting = (direction != 0)
	move_and_slide()


func _on_player_detect_body_entered(body: Node2D) -> void:
	print("collectible found")
	piles_found += 1
	hud_label.text = "%d/%d piles raked
	%d/%d items found" % [piles_found, piles_found_total, special_items_found, special_items_total]
	body.queue_free()
	
