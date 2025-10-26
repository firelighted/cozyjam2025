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
var special_items_found = 0
const special_items_total = 3
const item_names = [
	"purple fleece hat", "red glove", "pale orange beanie",  "toy horse",
	"handmade wool scarf", "bright yellow mittens", "Red Sox baseball cap", 
	"fuzzy green beanie", "pair of Pikachu slippers", "Bluey-themed analog watch", 
	"Qatar world cup soccer ball", 
	"pink hydroflask covered in Hello Kitty stickers", "ceramic mushroom mug"
]

func _ready() -> void:
	randomize()
	hud_label = get_node(hud_label_path)
	leafblow = get_node(leafblow_path)
	footstep_audio = get_node(footstep_audio_path)
	pile_audio = get_node(pile_audio_path) 
	$speech.hide()
	$FootstepAudio.play()
	sprite_blower_update(Vector2(1, 0))


func found_lost_item(): 
	$speech.show()
	$LostItemSFX.play()
	var message = "You found a lost %s!" % item_names[randi() % item_names.size()]
	special_items_found += 1
	if special_items_found == special_items_total:
		message += "
		Thank you, kind soul! The possessions you found have been returned to their rightful owners in the Brookline Middle second grade class"
	$speech/Label.text = message
	$speech/HideSpeechTimer.start()
	

func _physics_process(_delta):
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
	sprite_blower_update(direction_topdown)

func sprite_blower_update(direction_topdown: Vector2):
	var direction = round(direction_topdown.x)
	footstep_audio.stream_paused = (direction == 0)
	if direction != 0:
		leafblow.orbit_velocity_max = direction + 1
		leafblow.orbit_velocity_min = direction
		leafblow.direction.x = direction
		leafblow.position = position + Vector2(64 * direction, 0)
		$CharSprite.scale = Vector2(direction, 1)


func _on_player_detect_body_entered(body: Node2D) -> void:
	print("collectible found")
	piles_found += 1
	hud_label.text = "%d piles cleared
	%d/%d items found" % [piles_found, special_items_found, special_items_total]
	body.get_parent().collect()
	leafblow.amount = MAX_LEAVES_BLOWN
	#pile_audio.play()
	if randf() < 0.1:
		found_lost_item()

func _on_finish_pile_timer_timeout() -> void:
	# runs repeatedly and automatically
	#if leafblow.amount > MIN_LEAVES_BLOWN:
	#	leafblow.amount -= 10
	pass

func _on_hide_speech_timer_timeout() -> void:
	$speech.hide()
