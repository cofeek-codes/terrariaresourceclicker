extends Node


func safe_create_tween(tween: Tween, trans_type: Tween.TransitionType = Tween.TransitionType.TRANS_CUBIC) -> Tween:
	if tween == null || !tween.is_running():
		tween = get_tree().create_tween().set_trans(trans_type)
		
	return tween
