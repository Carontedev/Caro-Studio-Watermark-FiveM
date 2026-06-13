local uiReady = false
local hidden = false
local hideTimer = nil
local debug = false

local function dlog(...)
    if debug then
        print('[^3Caros-Watermark^7]', ...)
    end
end

local function buildPayload()
    return {
        enabled = Config.enabled,
        logoPath = Config.logoPath,
        position = Config.position,
        size = Config.size,
        opacity = Config.opacity,
        animation = Config.animation,
        autoHide = Config.autoHide
    }
end

local function sendConfigToUI()
    if not uiReady then return end
    SendNUIMessage({
        action = 'applyConfig',
        payload = buildPayload()
    })
end

local function hideLogo()
    if not Config.autoHide.enabled then return end
    if hidden then return end
    hidden = true
    dlog('Ocultando logo')

    if hideTimer then
        Citizen.ClearTimeout(hideTimer)
        hideTimer = nil
    end

    local duration = Config.autoHide.autoRestoreDuration or 15000
    if duration > 0 then
        hideTimer = Citizen.SetTimeout(duration, function()
            if hidden then
                hidden = false
                SendNUIMessage({ action = 'show' })
                dlog('Logo restaurado por timeout')
            end
            hideTimer = nil
        end)
    end

    SendNUIMessage({ action = 'hide' })
end

local function showLogo()
    if not Config.autoHide.enabled then return end
    if not hidden then return end
    hidden = false
    dlog('Mostrando logo')

    if hideTimer then
        Citizen.ClearTimeout(hideTimer)
        hideTimer = nil
    end

    SendNUIMessage({ action = 'show' })
end

-- Configurar debug
if Config.autoHide and Config.autoHide.debug then
    debug = true
end

-- ========================================
-- VALIDACION DE CONFIG
-- ========================================
local function validateConfig()
    local validModes = { ['static'] = true, ['shimmer'] = true, ['shimmer-rotatory'] = true, ['rotatory'] = true, ['breathing'] = true, ['floating'] = true }
    local validAnchors = { ['top-left'] = true, ['top-center'] = true, ['top-right'] = true, ['bottom-left'] = true, ['bottom-right'] = true }
    local function err(field, msg)
        print(('[^1Caros-Watermark^7] ERROR: config.%s - %s'):format(field, msg))
    end

    if Config.enabled ~= nil and type(Config.enabled) ~= 'boolean' then err('enabled', 'debe ser boolean (true/false)') end
    if Config.logoPath ~= nil and type(Config.logoPath) ~= 'string' then err('logoPath', 'debe ser string (ruta del logo)') end
    if Config.position then
        local a = Config.position.anchor
        if a and not validAnchors[a] then err('position.anchor', ('"%s" no es valido. Opciones: top-left, top-center, top-right, bottom-left, bottom-right'):format(tostring(a))) end
        if Config.position.x ~= nil and type(Config.position.x) ~= 'string' and type(Config.position.x) ~= 'number' then err('position.x', 'debe ser numero o string (ej: 10, "1vw")') end
        if Config.position.y ~= nil and type(Config.position.y) ~= 'string' and type(Config.position.y) ~= 'number' then err('position.y', 'debe ser numero o string (ej: 10, "1vw")') end
    end
    if Config.size then
        if Config.size.width ~= nil and (type(Config.size.width) ~= 'number' or Config.size.width <= 0) then err('size.width', 'debe ser numero positivo') end
        if Config.size.height ~= nil and (type(Config.size.height) ~= 'number' or Config.size.height <= 0) then err('size.height', 'debe ser numero positivo') end
    end
    if Config.opacity ~= nil then
        if type(Config.opacity) ~= 'number' then err('opacity', 'debe ser numero')
        elseif Config.opacity < 0 or Config.opacity > 1 then err('opacity', 'debe estar entre 0 y 1') end
    end
    if Config.animation then
        local m = Config.animation.mode
        if m and not validModes[m] then err('animation.mode', ('"%s" no es valido. Opciones: static, shimmer, shimmer-rotatory, rotatory, breathing, floating'):format(tostring(m))) end
        if Config.animation.speed ~= nil and (type(Config.animation.speed) ~= 'number' or Config.animation.speed <= 0) then err('animation.speed', 'debe ser numero positivo') end
        if Config.animation.intensity ~= nil and (type(Config.animation.intensity) ~= 'number' or Config.animation.intensity <= 0) then err('animation.intensity', 'debe ser numero positivo') end
    end
    if Config.autoHide then
        if Config.autoHide.enabled ~= nil and type(Config.autoHide.enabled) ~= 'boolean' then err('autoHide.enabled', 'debe ser boolean') end
        if Config.autoHide.transitionDuration ~= nil and (type(Config.autoHide.transitionDuration) ~= 'number' or Config.autoHide.transitionDuration < 0) then err('autoHide.transitionDuration', 'debe ser numero >= 0') end
        if Config.autoHide.autoRestoreDuration ~= nil and (type(Config.autoHide.autoRestoreDuration) ~= 'number' or Config.autoHide.autoRestoreDuration < 0) then err('autoHide.autoRestoreDuration', 'debe ser numero >= 0') end
        if Config.autoHide.customListeners ~= nil and type(Config.autoHide.customListeners) ~= 'table' then err('autoHide.customListeners', 'debe ser una tabla') end
    end
end

validateConfig()

-- ========================================
-- EVENTOS DE SCRIPTS DE ANUNCIOS
-- ========================================

-- txAdmin (eventos reales del log)
-- Los nombres correctos detectados en tu servidor:
RegisterNetEvent('txAdmin:events:announcement', function(data)
    dlog('Evento txAdmin:events:announcement recibido')
    if debug and data then
        dlog('Payload:', json.encode(data))
    end
    hideLogo()
    -- Si el payload incluye duracion, ajustar el auto-restore
    if data and data.duration and type(data.duration) == 'number' and data.duration > 0 then
        if hideTimer then
            Citizen.ClearTimeout(hideTimer)
            hideTimer = nil
        end
        hideTimer = Citizen.SetTimeout(data.duration + 1000, function()
            if hidden then
                hidden = false
                SendNUIMessage({ action = 'show' })
                dlog('Logo restaurado por duracion del anuncio')
            end
            hideTimer = nil
        end)
    end
end)
-- Fallback para versiones antiguas de txAdmin
RegisterNetEvent('txAdmin:showWarning', function(...)
    dlog('Evento txAdmin:showWarning recibido')
    hideLogo()
end)
RegisterNetEvent('txAdmin:warningClosed', function(...)
    dlog('Evento txAdmin:warningClosed recibido')
    showLogo()
end)
RegisterNetEvent('txAdmin:showMessage', function(...)
    dlog('Evento txAdmin:showMessage recibido')
    hideLogo()
end)
RegisterNetEvent('txAdmin:messageClosed', function(...)
    dlog('Evento txAdmin:messageClosed recibido')
    showLogo()
end)
-- Evento generico de txAdmin
RegisterNetEvent('txAdmin:events:announcementClose', function(...)
    dlog('Evento txAdmin:events:announcementClose recibido')
    showLogo()
end)

-- Direct Messages de txAdmin
RegisterNetEvent('txAdmin:events:playerDirectMessage', function(data)
    dlog('Evento txAdmin:events:playerDirectMessage recibido')
    if debug and data then
        dlog('Payload:', json.encode(data))
    end
    hideLogo()
end)

RegisterNetEvent('txAdmin:events:playerWarned', function(data)
    dlog('Evento txAdmin:events:playerWarned recibido')
    if debug and data then
        dlog('Payload:', json.encode(data))
    end
    hideLogo()
end)

-- Eventos genericos CarosWatermark (cualquier script puede usarlos)
-- TriggerEvent('CarosWatermark:hide')
-- TriggerEvent('CarosWatermark:show')
RegisterNetEvent('CarosWatermark:hide', hideLogo)
RegisterNetEvent('CarosWatermark:show', showLogo)

-- Eventos personalizados desde config.lua
if Config.autoHide and Config.autoHide.customListeners then
    for _, entry in ipairs(Config.autoHide.customListeners) do
        if entry.hide then
            RegisterNetEvent(entry.hide, function(...)
                dlog('Evento personalizado hide:', entry.hide)
                hideLogo()
            end)
        end
        if entry.show then
            RegisterNetEvent(entry.show, function(...)
                dlog('Evento personalizado show:', entry.show)
                showLogo()
            end)
        end
    end
end

-- ========================================
-- COMANDOS DE PRUEBA
-- ========================================
RegisterCommand('wmhide', hideLogo, false)
RegisterCommand('wmshow', showLogo, false)
RegisterCommand('wmdebug', function()
    debug = not debug
    print('[Caros-Watermark] Debug:', debug and 'ON' or 'OFF')
end, false)

-- ========================================
-- NUI CALLBACKS
-- ========================================
RegisterNUICallback('logo:ready', function(_, cb)
    uiReady = true
    sendConfigToUI()
    if cb then cb({ ok = true }) end
end)

-- ========================================
-- RESTAURAR VISIBILIDAD AL INICIAR RECURSOS
-- ========================================
AddEventHandler('onClientResourceStart', function(resName)
    if resName == GetCurrentResourceName() then return end
    SetTimeout(2000, showLogo)
end)

-- ========================================
-- INICIALIZACION
-- ========================================
CreateThread(function()
    SetNuiFocus(false, false)
    sendConfigToUI()
end)
