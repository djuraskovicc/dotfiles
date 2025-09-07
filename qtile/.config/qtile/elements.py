from libqtile import widget, qtile
from subprocess import check_output, CalledProcessError


class MyWidgets:
    def __init__(self):
        self.discharge_icons = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
        self.font_colors = [
            "#151D5B",
            "#ffffff"
        ]
        self.background_colors = [
            # Blue colors
            "#81D4FA",
            "#4FC3F7",
            "#29B6F6",
            "#03A9F4",
            "#039BE5",
            "#0288D1"
        ]

    def get_battery_icon(self):
        try:
            output = check_output(["cat", "/sys/class/power_supply/BAT0/capacity"], universal_newlines=True)

            index = min(int(output) // 10, len(self.discharge_icons) - 1)
            return self.discharge_icons[index]

        except CalledProcessError:
            return "N/A"

    def rofi(self):
        return widget.Image(
            filename="/home/petar/archlinux-logo.png",
            margin=8,
            mouse_callbacks={
                "Button1": lambda: qtile.spawn("rofi -show drun")
            },
            background=self.background_colors[5]
        )

    def group(self):
        return widget.GroupBox(
            background=self.background_colors[5],
            highlight_method='line',
            highlight_color=["#9370DB", "#40E0D0"]
        )

    def cpu(self):
        return widget.CPU(
            format="  {load_percent}%",
            background=self.background_colors[4]
        )

    def ram(self):
        return widget.Memory(
            format=" {MemUsed: .0f}{mm}",
            background=self.background_colors[3]
        )

    def weather(self):
        return widget.Wttr(
            background=self.background_colors[2],
            location={
                    'Podgorica': 'Podgorica'
                }
        )

    def system_tray(self):
        return widget.Systray(
            background=self.background_colors[1]
        )

    def separator(self):
        return widget.Spacer(
            background=self.background_colors[0],
            padding=5
        )

    def internet(self):
        return widget.Net(
            format="{down:.0f}{down_suffix} ↓↑ {up:.0f}{up_suffix}",
            background=self.background_colors[1]
        )

    def brightness(self):
        return widget.Backlight(
            background=self.background_colors[2],
            backlight_name="amdgpu_bl1",
            brightness_file="brightness",
            change_command="brightnessctl set {0}%",
            fmt="󰃠  {}",
            step=5
        )

    def volume(self):
        return widget.PulseVolume(
            background=self.background_colors[3],
            limit_max_volume=True,
            channel="master",
            scroll=True,
            scroll_fixed_width=True,
            fmt="   {}",
            step=5
        )

    def battery(self):
        return widget.Battery(
            background=self.background_colors[4],
            discharge_char=self.get_battery_icon(),
            charge_char=" ",
            full_char=self.discharge_icons[10]
        )

    def clock(self):
        return widget.Clock(
            background=self.background_colors[5],
            format="  %d/%m/%Y %a %H:%M"
        )

    def quick_exit(self):
        return widget.QuickExit(
            background=self.background_colors[5],
            default_text=" ",
            countdown_format=" {} "
        )

class Functions:
    def volume_up(qtile):
        qtile.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")

    def volume_down(qtile):
        qtile.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")

    def brightness_up(qtile):
        qtile.spawn("brightnessctl set +5%")

    def brightness_down(qtile):
        qtile.spawn("brightnessctl set 5-%")

    def spawn_rofi(qtile):
        qtile.spawn("rofi -show drun")
