--[[
    cs_watermark - Configuration
    ----------------------------
    NUI watermark logo with optional animations and auto-hide behaviour
    during server-wide announcements (txAdmin).
]]

Config = {
    -- Master switch. Set to false to completely hide the watermark.
    enabled = true,

    -- Path to the logo image, relative to the html/ folder.
    -- PNG with transparency is recommended. Remember to also register
    -- the file in fxmanifest.lua if you add a new asset.
    logoPath = 'assets/logo.png',

    -- Screen placement of the watermark.
    --   anchor : 'top-left' | 'top-center' | 'top-right' | 'bottom-left' | 'bottom-right'
    --   x / y  : offset applied from the anchor. Accepts a number (pixels)
    --            or a string with viewport units ('10px', '1vw', '2vh').
    --            Negative values move the logo up/left. Values that push
    --            the logo outside the viewport will clip it on screen.
    position = {
        anchor = 'top-center',
        x = '-1vw',
        y = '-4vh'
    },

    -- Base container size in pixels. Automatically scaled to the player's
    -- screen resolution (1080p used as reference). Recommended logo
    -- resolution: 400x200 px or an aspect ratio between 2:1 and 1:1.
    size = {
        width = 110,
        height = 110
    },

    -- Overall opacity of the watermark. Range: 0.0 (invisible) to 1.0 (opaque).
    opacity = 1.0,

    -- Animation settings.
    --   mode      : 'static'            no movement, logo stays still
    --               'shimmer'           light sweep across the logo
    --               'shimmer-rotatory'  light sweep combined with 3D flip
    --               'rotatory'          3D flip with a frontal pause
    --               'breathing'         subtle scale/brightness pulse
    --               'floating'          gentle vertical floating
    --               'jelly'             squash-and-stretch jump with spin and shine
    --   speed     : multiplier, must be > 0 (1.0 = default, 2.0 = twice as fast)
    --   intensity : multiplier, must be > 0 (drives deformation, brightness and glow strength)
    animation = {
        mode = 'jelly',
        speed = 1.0,
        intensity = 1.0
    },

    -- Automatically hides the watermark while on-screen announcements or
    -- alerts (txAdmin) are displayed, and restores it afterwards.
    autoHide = {
        -- Enable or disable the auto-hide behaviour.
        enabled = true,

        -- Fade-out / fade-in duration in milliseconds.
        transitionDuration = 350,

        -- Time in milliseconds before the logo is restored automatically.
        -- Set to 0 to keep it hidden until a close/show event is received.
        autoRestoreDuration = 15000,

        -- Extra event pairs to listen for. Each entry may define a 'hide'
        -- and/or 'show' event name. Any resource can also use the generic
        -- events without configuration:
        --   TriggerEvent('cswatermark:hide')
        --   TriggerEvent('cswatermark:show')
        customListeners = {
            -- { hide = 'myresource:hideWatermark', show = 'myresource:showWatermark' },
        },

        -- Print debug information to the client console (F8).
        debug = false,
    }
}
