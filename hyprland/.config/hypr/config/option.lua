hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "intl",
        -- kb_model = 
        kb_options = "caps:escape",
        -- kb_rules = 
        follow_mouse = 0,
        float_switch_override_focus = 0,
        touchpad = {
            natural_scroll = false,
        },
        sensitivity = 0.3,
        accel_profile = "\"adaptive\"",
    },
    binds = {
        workspace_back_and_forth = true,
        drag_threshold = 10,
    },
    cursor = {
        inactive_timeout = 5,
        hide_on_key_press = true,
        hide_on_touch = true,
        warp_on_change_workspace = true,
    },
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 3,
        col = {
            active_border = "rgb(FFA500)",
        },
        layout = "dwindle",
        allow_tearing = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 1,
        font_family = "JetBrainsMono Nerd Font",
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    quirks = {
        prefer_hdr = 1,
    },
    decoration = {
        rounding = false,
        blur = {
            enabled = false,
        },
        shadow = {
            enabled = false,
        },
    },
    animations = {
        enabled = false,
    },
    master = {
        new_status = "master",
    },
    xwayland = {
        force_zero_scaling = true,
    },
})
