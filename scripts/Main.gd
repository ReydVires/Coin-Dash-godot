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
	new_game()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()
	spawn_coins()

func spawn_coins():
	for i in range(4 + level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = screensize
		c.position = Vector2(rand_range(offset_coin_spawn, screensize.x),
				rand_range(offset_coin_spawn, screensize.y))
		

