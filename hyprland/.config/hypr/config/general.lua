hl.config({
	input({
		kb_layout = us,
		kb_variant = intl,
		-- kb_options = caps:escape,

		follow_mouse = 0,
		float_switch_override_focus = 0,

		touchpad({
			natural_scroll = no,
		}),

		sensitivity = 0.3,
		accel_profile = "adaptive",
	}),
	binds({
		workspace_back_and_forth = true,
	}),

	cursor({
		inactive_timeout = 5,
		hide_on_key_press = true,
		hide_on_touch = true,
		warp_on_change_workspace = true,
	}),
	general({
		gaps_in = 0,
		gaps_out = 0,
		border_size = 3,
		col = {
			active_border = "rgb(FFA500)",
		},
		layout = dwindle,
		allow_tearing = true,
	}),
	misc({
		disable_hyprland_logo = true,
		font_family = "JetBrainsMono Nerd Font",
	}),

	decoration({
		rounding = false,
		blur({
			enabled = false,
		}),
	}),

	animations({
		enabled = false,
	}),

	master({
		new_status = master,
	}),

	xwayland({
		force_zero_scaling = true,
	}),
})
