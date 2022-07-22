extends Node


export (PackedScene) var mob_scene  #PackedScene referencia os .tscn e nesse caso sera o mob
var score = 0

func _ready():
	randomize() #para gerar posições diferentes a cada tentativa


func new_game():
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free") #destroi todos os monstros no restart
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	$Music.play()
	
	$HUD.show_message("Começando...")
	
	yield($StartTimer, "timeout") #vai parar a função até o sinal ser ativado, da um tempo na sequencia
	
	$ScoreTimer.start()
	$MobTimer.start()
	


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func _on_MobTimer_timeout():
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.unit_offset = randf()  #randf gera um número entre 0 e 1
	
	var mob = mob_scene.instance()
	add_child(mob)
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2  # pi = 180, logo 90 graus, pois ele ta reto na linha
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0) #vetor apontando para a direita
	mob.linear_velocity = velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
