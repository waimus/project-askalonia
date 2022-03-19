extends Area


func _on_area_checkpoint_body_entered(body):
	if body.is_in_group("Presistent"):
		SaveGameSystem.save_game()


func _on_area_checkpoint_body_exited(body):
	if body.is_in_group("Presistent"):
		print("%s is passing checkpoint" % body)
