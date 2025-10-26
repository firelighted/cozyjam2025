extends CharacterBody2D

var direction = Vector2i(1,1)

const SPEED = 25

@export var turkey_sound_left : Array[AudioStream]= [
	preload("res://assets/sfx/turkey-concerned-left.mp3"),
	preload("res://assets/sfx/turkey-mad-left.mp3"),
	preload("res://assets/sfx/turkey-happy-left.mp3"),
]

@export var turkey_sound_right : Array[AudioStream]= [
	preload("res://assets/sfx/turkey-concerned-right.mp3"),
	preload("res://assets/sfx/turkey-mad-right.mp3"),
	preload("res://assets/sfx/turkey-happy-right.mp3"),
]

@export var turkey_sound_middle : Array[AudioStream]= [
	preload("res://assets/sfx/turkey-concerned.mp3"),
	preload("res://assets/sfx/turkey-mad.mp3"),
	preload("res://assets/sfx/turkey-happy.mp3"),
]

var sound : AudioStream

func _ready() -> void:
	randomize()
	if randf() < 0.5:
		$Sprite2D.texture = load("res://assets/turkey2.tres")
	change_direction()

func _on_turkey_area_entered(area: Area2D) -> void:
	make_sfx(area.position.x - position.x)

func _physics_process(_delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()
	$Sprite2D.flip_h = (direction.x > 0)

func _on_timer_timeout() -> void:
	change_direction()

func change_direction():
	direction = Vector2i((randi() % 3) - 1, (randi() % 3) - 1)

func make_sfx(x_pos):
	if $SFX.playing:
		return
	if x_pos > 20:
		sound = turkey_sound_left[randi() % turkey_sound_left.size()]
	elif x_pos < -20:
		sound = turkey_sound_right[randi() % turkey_sound_right.size()]
	else:
		sound = turkey_sound_middle[randi() % turkey_sound_middle.size()]
	$SFX.stream = sound
	$SFX.play() 
	change_direction()
