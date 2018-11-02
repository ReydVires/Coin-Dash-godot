extends Node

export (PackedScene) var Coin
export (PackedScene) var Powerup
export (int) var playtime

var level
var score
var time_left
var screensize
var playing = false
var offset_coin_spawn = 30

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	screensize.y -= offset_coin_spawn
	screensize.x -= offset_coin_spawn
	$Player.screensize = screensize
	$Player.hide()

func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5 #add 5 if next level
		spawn_coins()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	$HUD.update_timer(time_left)
	$HUD.update_score(score)
	spawn_coins()

func spawn_coins():
	$LevelSound.play()
	for i in range(4 + level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(offset_coin_spawn, screensize.x),
				rand_range(offset_coin_spawn, screensize.y))
		$PowerupTimer.wait_time = rand_range(5, 10)
		$PowerupTimer.start()

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_Player_hurt():
	game_over()

func _on_Player_pickup(type):
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$PowerupSound.play()
			$HUD.update_timer(time_left)

func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	#Make all children deleted
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()

func _on_PowerupTimer_timeout():
	if playing:
		var p = Powerup.instance()
		var offset = 30
		add_child(p)
		p.screensize = screensize
		p.position = Vector2(
				rand_range(offset, screensize.x - offset),
				rand_range(offset, screensize.y - offset))
