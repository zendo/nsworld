-- https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
---@diagnostic disable: undefined-global

-- -------===[ Variables ]===-------
-- hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_SIZE", "24")

-- -------===[ Programs ]===-------
local term        = "kitty"
local editor      = "emacs"
local browser     = "firefox"
local filemanager = "thunar"

-- -------===[ Autostart ]===-------
hl.on("hyprland.start", function ()
    -- hl.exec_cmd("fcitx5 -rd")
    -- hl.exec_cmd("ibus-daemon -drxR ; sleep 3; ibus engine rime")
end)

-- -------===[ Monitors ]===-------
-- hl.monitor({
--     output   = "eDP-1",
--     mode     = "preferred",
--     position = "auto",
--     scale    = "auto",
-- })

-- -------===[ Input ]===-------
hl.config({
    input = {
        kb_file    = "",
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        -- kb_options = "ctrl:swapcaps",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0, -- -1.0 - 1.0, 0 意味着不修改

        touchpad = {
            natural_scroll = true, -- 旧版的 1 对应 true
        },
    },
})


-- -------===[ Main Settings ]===-------
hl.config({
    general = {
        gaps_in     = 1,
        gaps_out    = 5,
        border_size = 4,

        col = {
            active_border   = "rgba(ee111166)",
            inactive_border = "rgba(33333366)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 8,
        shadow = {
            enabled      = true,
            range        = 20,
            render_power = 2,
            color        = "rgba(00000044)",
        },
    },
})

-- 模糊层规则 (旧版的 blurls)
hl.layer_rule({ name = "blur-fuzzel", match = { namespace = "fuzzel" } })
hl.layer_rule({ name = "blur-lockscreen", match = { namespace = "lockscreen" } })


-- -------===[ Animations ]===-------
hl.config({
    animations = {
        enabled = true,
    },
})
hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })


-- -------===[ Dwindle ]===-------
--[[
hl.config({
    dwindle = {
        pseudotile = false,
    },
})
--]]

-- -------===[ Keybindings ]===-------
local mainMod = "SUPER"

-- 应用程序与基础操作
hl.bind(mainMod .. " + Q",      hl.dsp.window.close()) -- killactive 对应关闭当前窗口
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + F",      hl.dsp.exec_cmd(filemanager))
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + X",      hl.dsp.exec_cmd("vicinae toggle"))
hl.bind(mainMod .. " + V",      hl.dsp.exec_cmd("vicinae vicinae://extensions/vicinae/clipboard/history"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("vicinae vicinae://extensions/vicinae/vicinae/search-emojis"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout"))
hl.bind("CTRL + ALT + delete",  hl.dsp.exec_cmd("wlogout"))

-- 窗口状态
hl.bind(mainMod .. " + H",   hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",   hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + P",   hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F11", hl.dsp.window.fullscreen())

-- 移动窗口位置 (SUPER + 方向键)
hl.bind(mainMod .. " + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.window.move({ direction = "down" }))

-- 调整窗口大小 (SUPER + SHIFT + 方向键)
-- hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ address = "", width = -20, height = 0 }))
-- hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ address = "", width = 20,  height = 0 }))
-- hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ address = "", width = 0,   height = -20 }))
-- hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ address = "", width = 0,   height = 20 }))

-- 鼠标手势绑定 (移动与缩放)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- 切换工作区 (SUPER + 1-0) 与 移动窗口至工作区 (ALT + 1-0)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("ALT + " .. key,        hl.dsp.window.move({ workspace = i }))
end

-- 鼠标滚轮切换工作区
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- 屏幕/显示器聚焦
hl.bind(mainMod .. " + ALT + up",   hl.dsp.focus({ monitor = "u" }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.focus({ monitor = "d" }))

-- 系统锁屏与截图
hl.bind(mainMod .. " + l",         hl.dsp.exec_cmd("hyprlock"))
hl.bind("Print",                   hl.dsp.exec_cmd("shotman -c output"))
hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("shotman -c region"))

-- 亮度调节
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("lightctl up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("lightctl down"))

-- 音量调节
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volumectl -u up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volumectl -u down"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("volumectl toggle-mute"))
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("volumectl -m toggle-mute"))

-- 媒体控制
hl.bind(mainMod .. " + backslash",    hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("playerctl next"))
hl.bind(mainMod .. " + bracketleft",  hl.dsp.exec_cmd("playerctl previous"))

hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"))

-- hl.bind("XF86Calculator", hl.dsp.exec_cmd(calendar))
hl.bind("XF86Display",    hl.dsp.exec_cmd("wdisplays"))


-- -------===[ Window Rules ]===-------
hl.window_rule({
    name = "kitty-workspace",
    match = { class = "kitty" },
    workspace = "1",
})

hl.window_rule({
    name = "ibus-nofocus",
    match = { class = "ibus-ui" },
    no_focus = true,
})

hl.window_rule({
    name = "fuzzel-float",
    match = { class = "fuzzel" },
    float = true,
})

hl.window_rule({
    name = "media-viewer-nofocus",
    match = { title = "Media viewer" },
    no_focus = true,
})

hl.window_rule({
    name = "wlogout-fullscreen",
    match = { class = "wlogout" },
    fullscreen = true,
})

hl.window_rule({
    name = "pavucontrol-float",
    match = { class = "pavucontrol" },
    float = true,
})

hl.window_rule({
    name = "blueman-float",
    match = { class = "blueman-manager" },
    float = true,
})
