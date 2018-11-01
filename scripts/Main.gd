extends Node

export (PackedScene) var Coin
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
	for i in range(4 + level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(offset_coin_spawn, screensize.x),
				rand_range(offset_coin_spawn, screensize.y))

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_Player_hurt():
	game_over()

func _on_Player_pickup():
	score += 1
	$HUD.update_score(score)

func game_over():
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	$HUD.show_game_over()
	$Player.die()