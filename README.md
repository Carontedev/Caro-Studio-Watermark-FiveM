# Caro-Studio-Watermark

NUI watermark for FiveM servers with configurable animations.

---

## Installation

1. Copy the `Caro-Studio-Watermark` folder into your `resources` directory
2. Add `ensure Caro-Studio-Watermark` to your `server.cfg`
3. Configure it in `config.lua`
4. Restart the server or run `restart Caro-Studio-Watermark`

---

## Animation modes

| Mode | Description |
|---|---|
| `static` | Static logo, no animation |
| `rotatory` | Horizontal 3D rotation with front pause (360°) |
| `breathing` | Scale pulse + lift + brightness "breath" effect |
| `floating` | Smooth vertical float (levitation) |
| `shimmer` | Shine sweep across the logo |
| `shimmer-rotatory` | Shine sweep + 3D rotation combined |

---

## Configuration

```lua
Config = {
    enabled = true,
    logoPath = 'assets/logo2.png',
    position = {
        anchor = 'top-center',
        x = '1vw',
        y = '-0.8vh'
    },
    size = {
        width = 150,
        height = 150
    },
    opacity = 1.0,
    animation = {
        mode = 'shimmer-rotatory',
        speed = 1.0,
        intensity = 1.0
    },
    autoHide = {
        enabled = true,
        transitionDuration = 350,
        autoRestoreDuration = 15000,
        customListeners = {},
        debug = false
    }
}
```

### Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `enabled` | boolean | `true` | Enable/disable the watermark |
| `logoPath` | string | `'assets/logo2.png'` | Logo path (relative to `html/`) |
| `position.anchor` | string | `'top-center'` | Position: `top-left`, `top-center`, `top-right`, `bottom-left`, `bottom-right` |
| `position.x` | number/string | `'1vw'` | Horizontal offset (px, vw, %) |
| `position.y` | number/string | `'-0.8vh'` | Vertical offset (px, vh, %) |
| `size.width` | number | `150` | Container base width (auto-scaled to resolution) |
| `size.height` | number | `150` | Container base height |
| `opacity` | number | `1.0` | Logo opacity (0.0 – 1.0) |
| `animation.mode` | string | `'shimmer-rotatory'` | Animation mode (see table above) |
| `animation.speed` | number | `1.0` | Animation speed (higher = faster) |
| `animation.intensity` | number | `1.0` | Effect intensity (brightness, lift, etc.) |
| `autoHide.enabled` | boolean | `true` | Auto-hide during announcements |
| `autoHide.transitionDuration` | number | `350` | Hide/show transition duration (ms) |
| `autoHide.autoRestoreDuration` | number | `15000` | Time to restore the logo (ms, 0 = no restore) |
| `autoHide.debug` | boolean | `false` | Debug logs in F8 console |

---

## Events

Any script can trigger these events to control the watermark:

| Event | Direction | Description |
|---|---|---|
| `CarosWatermark:hide` | Server → Client | Hides the logo |
| `CarosWatermark:show` | Server → Client | Shows the logo |

Example from another resource:

```lua
TriggerEvent('CarosWatermark:hide')
TriggerEvent('CarosWatermark:show')
```

---

## Auto-hide

The watermark automatically hides when txAdmin shows announcements, warnings, or on-screen messages. You can also add custom events in `config.lua`:

```lua
autoHide = {
    enabled = true,
    customListeners = {
        { hide = 'myResource:announcementStarts', show = 'myResource:announcementEnds' },
        { hide = 'anotherEvent:hide' }
    }
}
```

If `customListeners` is empty, it only reacts to txAdmin events.

---

## Commands

| Command | Description |
|---|---|
| `/wmhide` | Manually hide the logo |
| `/wmshow` | Manually show the logo |
| `/wmdebug` | Toggle debug logs (F8) |

> Commands only work when `autoHide.enabled = true`.

---

## Recommendations

- **Logo:** 1024×1024 px or 1:1 ratio, PNG with transparency
- The container auto-scales to the player's screen resolution
- The logo hides during txAdmin announcements and restores automatically

---

## Troubleshooting

**Logo doesn't appear:**
- Check the F8 console with `/wmdebug` to verify the config was sent correctly
- Make sure the logo path in `config.lua` is correct (relative to `html/`)
- Ensure the resource is started (`ensure Caro-Studio-Watermark`)

**Validation error in console:**
- The script validates the config on startup and prints specific error messages with the incorrect field

**Logo doesn't hide with announcements:**
- Verify `autoHide.enabled = true`
- Check that txAdmin events are reaching the server

---

## Credits

Developed by Caronte — [CaroStudio.xyz](https://carostudio.xyz)
