-- Bridge: reenvia eventos de txAdmin del servidor a los clientes
-- para que Caro-Studio-Watermark pueda ocultar el logo

local function dlog(...)
    if Config and Config.autoHide and Config.autoHide.debug then
        print('[^3Caros-Watermark-Server^7]', ...)
    end
end

AddEventHandler('txAdmin:events:announcement', function(data)
    dlog('txAdmin:events:announcement recibido, reenviando a clientes')
    TriggerClientEvent('txAdmin:events:announcement', -1, data or {})
end)

AddEventHandler('txAdmin:events:announcementClose', function(data)
    dlog('txAdmin:events:announcementClose recibido, reenviando a clientes')
    TriggerClientEvent('txAdmin:events:announcementClose', -1, data or {})
end)

AddEventHandler('txAdmin:showWarning', function(...)
    dlog('txAdmin:showWarning recibido, reenviando a clientes')
    TriggerClientEvent('txAdmin:showWarning', -1, ...)
end)

AddEventHandler('txAdmin:warningClosed', function(...)
    dlog('txAdmin:warningClosed recibido, reenviando a clientes')
    TriggerClientEvent('txAdmin:warningClosed', -1, ...)
end)

AddEventHandler('txAdmin:showMessage', function(...)
    dlog('txAdmin:showMessage recibido, reenviando a clientes')
    TriggerClientEvent('txAdmin:showMessage', -1, ...)
end)

AddEventHandler('txAdmin:messageClosed', function(...)
    dlog('txAdmin:messageClosed recibido, reenviando a clientes')
    TriggerClientEvent('txAdmin:messageClosed', -1, ...)
end)

AddEventHandler('txAdmin:events:playerDirectMessage', function(eventData)
    dlog('txAdmin:events:playerDirectMessage recibido, reenviando al destino')
    if eventData and eventData.target then
        TriggerClientEvent('txAdmin:events:playerDirectMessage', eventData.target, eventData)
    end
end)

AddEventHandler('txAdmin:events:playerWarned', function(eventData)
    dlog('txAdmin:events:playerWarned recibido, reenviando al destino')
    if eventData and eventData.target then
        TriggerClientEvent('txAdmin:events:playerWarned', eventData.target, eventData)
    end
end)
