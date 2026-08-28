Config = {
    enabled = true,
    logoPath = 'assets/logo.png',
    position = {
        anchor = 'top-center',
        x = '-1vw',
        y = '1vh'
    },
    -- width/height: base container size (auto-scaled to screen resolution)
    -- Recommended logo resolution: 400x200 px or ~2:1 to 1:1 ratio
    size = {
        width = 110,
        height = 110
    },
    opacity = 1.0,
    animation = {
        -- mode options: 'static' | 'shimmer' | 'shimmer-rotatory' | 'rotatory' | 'breathing' | 'floating'
        mode = 'shimmer-rotatory',
        speed = 1.0,
        intensity = 1.0
    },

    -- Auto-hide: automatically hides the logo during on-screen announcements/alerts
    autoHide = {
        enabled = true,
        transitionDuration = 350,
        autoRestoreDuration = 15000,
        customListeners = {
        },
        debug = false,
    }
}