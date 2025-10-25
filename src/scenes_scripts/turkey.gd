extends CharacterBody2D

var direction = Vector2i(1,1)

const SPEED = 25

func _ready() -> void:
	randomize()
	if randf() < 0.5:
		$Sprite2D.texture = load("res://assets/turkey2.tres")
	$Sprite2D.flip_h = direction.x > 1

func _on_turkey_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()

func _on_timer_timeout() -> void:
	change_direction()


func change_direction():
	direction = Vector2i((randi() % 2) - 1, (randi() % 2) - 1)
	$Sprite2D.flip_h = direction.x > 1
