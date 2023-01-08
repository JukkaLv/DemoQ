MVCFacade = {}

local Notifier = require 'Framework.Notifier'
local ViewAdpter = require 'MVC.ViewAdpter'

function MVCFacade.Initialize(viewCanvas)
    MVCFacade.VIEW_CANVAS_2D = viewCanvas
    if viewCanvas == nil then
        MVCFacade.VIEW_CANVAS_2D = GameObject.Find("Canvas").transform
    end
    ViewAdpter.Initialize()
end

function MVCFacade.ExcuteCommand(COMMAND_NAME, ...)
    local COMMAND = require('MVC.Command.'..COMMAND_NAME)
    COMMAND.Excute(...)
end

local controllers = {}
function MVCFacade.RegisterController(CONTROLLER_NAME)
    local controller = controllers[CONTROLLER_NAME]
    assert(controller == nil, 'Error! '..CONTROLLER_NAME.." controller has already registered.")
    local CONTROLLER = require('MVC.Controller.'..CONTROLLER_NAME)
    controller = CONTROLLER.Create()
    controllers[CONTROLLER_NAME] = controller
end

function MVCFacade.UnregisterController(CONTROLLER_NAME)
    local controller = controllers[CONTROLLER_NAME]
    assert(controller ~= nil, 'Error! '..CONTROLLER_NAME.." controller unregistered.")
    controller:Dispose()
    controllers[CONTROLLER_NAME] = nil
end

function MVCFacade.GetController(CONTROLLER_NAME)
    local controller = controllers[CONTROLLER_NAME]
    assert(controller ~= nil, 'Error! '..CONTROLLER_NAME.." controller unregistered.")
    return controller
end