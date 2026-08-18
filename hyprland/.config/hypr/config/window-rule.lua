hl.window_rule({
    match = {
        float = false,
    },
    opacity = "1.0 0.8 1.0",
})

hl.window_rule({
    match = {
        float = true,
    },
    opacity = "1.0 0.8 1.0",
})

hl.window_rule({
    match = {
        fullscreen = true,
    },
    opacity = 1.0,
})

hl.window_rule({
    match = {
        class = "^(librewolf|firefox-esr|chromium|SheetCamTNG-dev|librewolf|[kK]i[cC]ad|pcb_calculator|eeschema|gerbview|pcbnew|bitmap2component|FreeCAD|Tor Browser|soffice)$",
    },
    opacity = 1.0,
})

hl.window_rule({
    match = {
        class = "^([kK]i[cC]ad|bitmap2component|pcb_calculator|Tor Browser|virt-manager|qt.ct|nwg-look|xdg-desktop-portal*|org.remmina.Remmina)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^([eE]lectrum|feather)$",
    },
    float = true,
    size = "800 400",
})

hl.window_rule({
    match = {
        class = "^(io.bassi.Amberol|xdg-desktop-portal-gtk)$",
    },
    float = true,
    size = "1200 1000",
})

hl.window_rule({
    match = {
        class = "(org.gnupg.pinentry-qt)",
    },
    float = true,
    center = true,
})

hl.window_rule({
    match = {
        title = "^(Moonlight|chiaki-ng|Open File|OnionShare)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        title = "^(ghostty)$",
    },
    opacity = "0.9 0.8 1.0",
})

hl.window_rule({
    match = {
        title = "^(tmux)$",
    },
    opacity = 1.0,
})

hl.window_rule({
    match = {
        title = "^(galc|nmtui|bluetuith|pass|wiremix|display)$",
    },
    float = true,
    size = "800 600",
    center = true,
})

hl.window_rule({
    match = {
        title = "^(ghostty|yazi|Open File|chiaki-ng)$",
    },
    float = true,
    size = "1200 1000",
    center = true,
})
