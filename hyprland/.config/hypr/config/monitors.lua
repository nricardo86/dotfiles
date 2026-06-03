hl.monitor({
	output = "DP-3",
	mode = "3840x2160@69.99700",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
})
hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@59.95",
	position = "960x2160",
	scale = 1,
	bitdepth = 10,
})

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
