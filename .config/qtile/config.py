import dataclasses
import datetime
import os
import pathlib
import platform
import random
import shutil
import subprocess
import typing

import libqtile.resources
from libqtile import bar, hook, layout, qtile, widget, utils
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.widget import backlight
from libqtile.backend.wayland import InputConfig


def first[T](
    options: list[T],
    predicate: typing.Callable[[T], typing.Any] | None = None,
    default: T | None = None,
) -> T:
    predicate = predicate or (lambda _: True)
    try:
        return next(option for option in options if predicate(option))
    except StopIteration:
        if default:
            return default
        else:
            raise RuntimeError("No valid options available")


def wp_path():
    wp_path = pathlib.Path(os.path.expanduser("~/Pictures/Wallpapers"))
    if qtile.current_screen.width > 4000:
        wp_path = wp_path / "Ultrawide"
    return wp_path


def random_wallpaper():
    wallpapers = [
        f
        for f in wp_path().iterdir()
        if f.is_file() and f.suffix.lower() in [".png", ".jpg", ".jpeg"]
    ]
    return random.choice(wallpapers)


@dataclasses.dataclass
class TimeRange:
    start: datetime.time
    end: datetime.time
    dow: int

    def contains(self, check_time: datetime.datetime) -> bool:
        return all(
            [
                check_time.time() >= self.start,
                check_time.time() <= self.end,
                check_time.weekday() == self.dow,
            ]
        )


workdays = [
    # Monday (0) through Friday (4)
    TimeRange(datetime.time(8), datetime.time(18), dow)
    for dow in [0, 1, 2, 3, 4]
]
# Sunday (6)
workdays.append(TimeRange(datetime.time(12), datetime.time(15), 6))
workdays.append(TimeRange(datetime.time(0), datetime.time(15), 5))


def during_work_hours(check_time: datetime.datetime | None = None) -> bool:
    if not check_time:
        check_time = datetime.datetime.now()
    return any([workday.contains(check_time) for workday in workdays])


def preferred_wallpaper(screen):
    wp_sunny = ("wide", "safe", "~/Pictures/Wallpapers/Ultrawide/o7i7rtkdwyd91.jpg")
    wp_lapis = ("full", "nsfw", "~/Pictures/Wallpapers/20210704_191749.jpeg")
    wp_cloud = ("full", "safe", "~/Pictures/Wallpapers/cloud_by_sakimichan-d4ly1t6.jpg")
    wp_xenia = ("full", "safe", "~/Pictures/Wallpapers/Xenia.png")
    preferences = {
        "framework13": [wp_sunny, wp_lapis, wp_cloud],
        "snappy": [wp_sunny, wp_xenia],
    }
    size = "wide" if qtile and qtile.current_screen.width > 4000 else "full"
    safety = "safe" if during_work_hours() else "nsfw"
    wallpapers = preferences.get(platform.node(), "framework13")

    def match(wp) -> bool:
        wp_size, wp_safety, wp_path = wp
        return wp_size == size and wp_safety == safety

    wallpaper = first(wallpapers, match, wallpapers[-1])
    return os.path.expanduser(wallpaper[-1])


def set_random_wallpaper(screen):
    screen.set_wallpaper(random_wallpaper(), "fill")


def set_preferred_wallpaper(screen):
    screen.set_wallpaper(preferred_wallpaper(screen), "fill")


mod = "mod4"
terminal = first(["konsole", "alacritty", "xterm"], shutil.which, "konsole")
volume = os.path.expanduser("~/.config/qtile/dunst-volume.sh")
keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "space", lazy.spawn("rofi -show drun")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(f"{volume} +2%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(f"{volume} -2%")),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.widget["backlight"].change_backlight(backlight.ChangeDirection.UP),
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.widget["backlight"].change_backlight(backlight.ChangeDirection.DOWN),
    ),
    Key([], "Print", lazy.spawn("spectacle")),
    Key([mod, "control"], "w", lazy.screen.function(set_random_wallpaper)),
    Key([mod, "shift"], "w", lazy.screen.function(set_preferred_wallpaper)),
    Key([mod, "shift", "control"], "l", lazy.spawn("slock")),
    # Somehow, previous and next are backwards?
    Key([mod], "comma", lazy.next_screen()),
    Key([mod], "period", lazy.prev_screen()),
    Key([mod], "p", lazy.spawn("rofi-power")),
    Key([mod], "s", lazy.spawn("rofi-sound")),
    Key([mod], "m", lazy.spawn("xfce4-find-cursor")),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            #     desc=f"Switch to & move focused window to group {i.name}",
            # ),
            # Or, use below if you prefer not to switch to that group.
            # mod + shift + group number = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name),
            ),
        ]
    )

layout_theme = {
    "border_width": 5,
    "margin": 30,
    "border_focus": "#d75f5f",
    "border_normal": "#8f3d3d",
    "single_border_width": 5,
}

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.MonadThreeCol(**layout_theme),
    layout.Columns(**layout_theme),
    layout.VerticalTile(**layout_theme),
    layout.TreeTab(**layout_theme),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Beleren",
    fontsize=18,
    padding=3,
)
extension_defaults = widget_defaults.copy()

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Spacer(),
                widget.WindowName(),
                widget.Spacer(),
                widget.DoNotDisturb(disabled_icon="📣", enabled_icon="😴"),
                widget.Backlight(),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                widget.StatusNotifier(),
                widget.Systray(hide_crash=True),
                widget.BatteryIcon(),
                widget.Battery(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                # widget.QuickExit(),
            ],
            28,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        background="#000000",
        # wallpaper=logo,
        # wallpaper_mode="fill",
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    )
    for _ in range(3)
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:keyboard": InputConfig(kb_options="ctrl:nocaps"),
}

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

idle_inhibitors = []  # type: list

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


@hook.subscribe.startup
@hook.subscribe.screens_reconfigured
def screen_reconf():
    utils.send_notification("qtile", "Screens reconfigured")
    for screen in qtile.screens:
        set_preferred_wallpaper(screen)


@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([script])
