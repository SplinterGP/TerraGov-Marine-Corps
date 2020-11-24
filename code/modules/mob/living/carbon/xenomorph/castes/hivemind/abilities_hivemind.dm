/datum/action/xeno_action/return_to_core
	name = "Return to Core"
	action_icon_state = "lay_hivemind"
	mechanics_text = "Teleport back to your core."

/datum/action/xeno_action/return_to_core/action_activate()
	SEND_SIGNAL(owner, COMSIG_XENOMORPH_CORE_RETURN)

/datum/action/xeno_action/materialization
	name = "Materialization"
	action_icon_state = "lay_hivemind"
	mechanics_text = "Materialize yourself physically."
	cooldown_timer = 5 SECONDS

/datum/action/xeno_action/materialization/action_activate()
	var/mob/living/carbon/xenomorph/hivemind/hivie = owner
	if(hivie.status_flags & INCORPOREAL)
		hivie.materialize()
		return succeed_activate()
	else
		if(!do_after(hivie, 10 SECONDS , FALSE, get_turf(hivie),  BUSY_ICON_BAR))
			return fail_activate()
		hivie.dematerialize()
		return succeed_activate()
