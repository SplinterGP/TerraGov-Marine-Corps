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

/datum/action/xeno_action/materialization/give_action(mob/living/L)
	. = ..()
	RegisterSignal(owner, COMSIG_XENOMORPH_MATERIALIZATION, .proc/materialization)

/datum/action/xeno_action/materialization/remove_action(mob/living/L)
	. = ..()
	UnregisterSignal(owner, COMSIG_XENOMORPH_MATERIALIZATION)

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

/datum/action/xeno_action/materialization/materialization(forced = FALSE)
	SIGNAL_HANDLER
	if(!CHECK_BITFIELD(owner.status_flags, INCORPOREAL))
		if(!forced)
			if(!do_after(owner, 7 SECONDS, FALSE, get_turf(owner), extra_checks = CALLBACK(owner, /mob.proc/break_do_after_checks, list("health" = owner.health))))
				add_cooldown()
				to_chat(owner, "<span class='danger'>we've been interrupted during our delicate dematerialization process, it has been cancelled!</span>")
				return fail_activate()
		ENABLE_BITFIELD(owner.status_flags, INCORPOREAL)
		owner.invisibility = INVISIBLITY_MAXIMUM
	else
		DISABLE_BITFIELD(owner.status_flags, INCORPOREAL)
		owner.invisibility = 0
		owner.throwpass = FALSE
		if(!forced)
			if(!do_after(owner, 3 SECONDS, FALSE, get_turf(owner, extra_checks = CALLBACK(owner, /mob.proc/break_do_after_checks, list("health" = owner.health))))
				materialization(TRUE)
				add_cooldown()
				to_chat(owner, "<span class='danger'> we've been interrupted during our delicate materialization process, it has been cancelled!")
				return fail_activate()




