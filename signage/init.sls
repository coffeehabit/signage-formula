{% set signage_user = 'signage' %}
{{ signage_user }}:
  user.present

pkgs_for_signage:
  pkg.installed:
    - names:
      - xinit
      - lightdm
      - i3
      - chromium-browser
      - xdotool
      - feh
      - figlet

/etc/lightdm/lightdm.conf:
  file.managed:
    - contents: |
        [SeatDefaults]
        autologin-user={{ signage_user }}
    - require:
      - user: {{ signage_user }}


/home/{{ signage_user }}/.config/i3/config:
  file.managed:
    - contents: |
        set $mod Mod4
        font pango:monospace 8
        hide_edge_borders both
        bindsym 0 workspace 0: Special
        bindsym 1 workspace 1: Sites
        bindsym 2 workspace 2: Pictures
        bindsym 3 workspace 3: Videos
        assign [class="xfce4-terminal"] 0: Special
        assign [class="Chromium"] 1: Sites
        assign [class="feh"] 2: Pictures
        assign [title="Cinemagraph"] 3: Videos
        bar {
             status_command i3status
        }

    - require:
      - user: {{ signage_user }}

pkill chromium-browser; export DISPLAY=:0.0 && chromium-browser --kiosk --incognito "https://radar.weather.gov/Conus/Loop/NatLoop.gif":
  cron.present:
    - identifier: weather_radar
    - user: {{ signage_user }}
    - minute: '10,20,30,40,50'

pkill chromium browser; export DISPLAY=:0.0 && chromium-browser --kiosk --incognito "https://howdns.works":
  cron.present:
    - identifier: dns_comic
    - user: {{ signage_user }}
    - minute: '5,15,25,35,45,55'
