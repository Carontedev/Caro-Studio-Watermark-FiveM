<p align="center">
  <img src="html/assets/logo.png" alt="CaroStudio Watermark" width="220">
</p>

<h1 align="center">CaroStudio Watermark</h1>

<p align="center">
  <strong>NUI watermark for FiveM servers with configurable animations.</strong><br>
  Branded logo with effects, auto-hide during txAdmin announcements, and full control from other resources.
</p>

<p align="center">
  <a href="https://github.com/Carontedev/cs_watermark_fivem/releases"><img src="https://img.shields.io/github/release/Carontedev/cs_watermark_fivem?style=flat-square&color=8B5CF6&label=Release" alt="Release"></a>
  <img src="https://img.shields.io/badge/FiveM-NUI-blue?style=flat-square" alt="FiveM NUI">
  <img src="https://img.shields.io/badge/Standalone-Yes-brightgreen?style=flat-square" alt="Standalone">
  <img src="https://img.shields.io/badge/Lua-5.4-2C2D72?style=flat-square" alt="Lua 5.4">
  <img src="https://img.shields.io/badge/Licence-MIT-green?style=flat-square" alt="MIT Licence">
  <img src="https://img.shields.io/github/stars/Carontedev/cs_watermark_fivem?style=flat-square&color=yellow" alt="Stars">
</p>

<p align="center">
  <a href="#installation"><strong>Installation</strong></a> ·
  <a href="#configuration"><strong>Configuration</strong></a> ·
  <a href="#animations"><strong>Animations</strong></a> ·
  <a href="#events-and-commands"><strong>Events & Commands</strong></a> ·
  <a href="#troubleshooting"><strong>Troubleshooting</strong></a> ·
  <a href="#license"><strong>License</strong></a>
</p>

---

## Features

- 🎨 **NUI logo** with transparency, auto-scaled to the player's screen resolution
- ✨ **6 animation modes**: static, rotatory, breathing, floating, shimmer and combined
- 🎚️ **Fine tuning**: speed and intensity configurable independently
- 📢 **Smart auto-hide**: hides automatically during txAdmin announcements and on-screen messages
- 🔌 **Control from other resources** via events (`cswatermark:hide` / `cswatermark:show`)
- 🛠️ **Player commands** to show/hide manually and debug from the F8 console
- ✅ **Config validation** on startup, with descriptive error messages

---

<h2 id="installation">Installation</h2>

1. Copy the `cs_watermark` folder into your server's `resources` directory
2. Add the following to your `server.cfg`:

   ```cfg
   ensure cs_watermark
   ```

3. Tune the settings in `config.lua`
4. Restart the server or run `restart cs_watermark`

> **Requirements:** FiveM, Lua 5.4.

---

<h2 id="configuration">Configuration</h2>

```lua
Config = {
    enabled = true,
    logoPath = 'assets/logo.png',
    position = {
        anchor = 'top-center',
        x = '-1vw',
        y = '1vh'
    },
    size = {
        width = 110,
        height = 110
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

Every parameter is optional; each block (position, size, animation, auto-hide) can be simplified if you don't need it.

---

<h2 id="animations">Animations</h2>

```lua
animation = { mode = '...' }   -- one of these:

-- static           static logo
-- rotatory         3D horizontal rotation (360°) with front pause
-- breathing        scale pulse + lift + brightness "breath" effect
-- floating         smooth vertical float
-- shimmer          shine sweep across the logo
-- shimmer-rotatory shine sweep + 3D rotation combined
```

---

<h2 id="events-and-commands">Events & Commands</h2>

### Events

Any resource can control the watermark:

| Event | Direction | Description |
|---|---|---|
| `cswatermark:hide` | Server → Client | Hides the logo |
| `cswatermark:show` | Server → Client | Shows the logo |

```lua
TriggerEvent('cswatermark:hide')
TriggerEvent('cswatermark:show')
```

### Player commands

| Command | Description |
|---|---|
| `/wmhide` | Hides the logo manually |
| `/wmshow` | Shows the logo manually |
| `/wmdebug` | Toggles debug logs (F8) |

> Commands only work when `autoHide.enabled = true`.

---

## Auto-hide (autoHide)

The watermark hides automatically when txAdmin shows announcements, warnings, or on-screen messages. You can also register your own listeners in `config.lua`:

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

<h2 id="troubleshooting">Troubleshooting</h2>

**The logo doesn't appear:**
- Run `/wmdebug` in the F8 console to verify the config was sent correctly
- Check that the logo path in `config.lua` is correct (relative to `html/`)
- Make sure the resource is started (`ensure cs_watermark`)

**Validation error in the console:**
- The script validates the config on startup and prints descriptive errors naming the wrong field

**The logo doesn't hide with announcements:**
- Verify that `autoHide.enabled = true`
- Check that txAdmin events are reaching the server

---

## Recommendations

- **Logo:** transparent PNG, 1:1 or 2:1 ratio, at least 400×200 px
- The container auto-scales to the player's screen resolution
- The logo hides during txAdmin announcements and restores automatically

---

<h2 id="license">License</h2>

MIT © 2025 – [CaroStudio.xyz](https://carostudio.xyz) · Built by **Caronte**

<a href="https://github.com/Carontedev/cs_watermark_fivem/issues"><img src="https://img.shields.io/badge/Report_a_bug-8B5CF6?style=flat-square" alt="Report a bug"></a>
