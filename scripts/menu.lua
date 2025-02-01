FactoryProductionMenu = {}
FactoryProductionMenu.modDir = g_currentModDirectory
FactoryProductionMenu.modName = g_currentModName
FactoryProductionMenu.isMenuVisible = false
FactoryProductionMenu.initialised = false

local FactoryProductionMenu_mt = Class(FactoryProductionMenu, DialogElement)

function FactoryProductionMenu.register()
    print("FactoryProductionMenu: Caricamento XML Menu")
    local FPMenu = FactoryProductionMenu.new()
    g_gui:loadGui(FactoryProductionMenu.modDir .. "gui/menu.xml", "FactoryProductionMenu", FPMenu)
    return FPMenu
end

function FactoryProductionMenu.new(target, custom_mt)
    print("FactoryProductionMenu inizializzazione Finestra")

    local self = DialogElement.new(target, custom_mt or FactoryProductionMenu_mt)
    self.hasCustomMenuButtons = true
    self.currentFocusCell = nil
    self.isActive = false
    self.name = "FactoryProductionMenu"
    self.i18n = l18n or g_i18n
    self.inputBinding = inputBinding or g_inputBinding
    FSBaseMission.saveSavegame = Utils.appendedFunction(FSBaseMission.saveSavegame, FactoryProductionMenu.onSavegame)
    return self
end

function FactoryProductionMenu:loadMap(name)
    g_factoryProductionMenu = self
    print("FactoryProductionMenu: Inizializzazione...")
    if g_gui then
        FactoryProductionMenu.register()
        FactoryProductionMenu:registerActionEvents()
        print("FactoryProductionMenu: appendedFunction")
        FSBaseMission.registerActionEvents =
            Utils.appendedFunction(FSBaseMission.registerActionEvents, FactoryProductionMenu.registerActionEvents)
    else
        print("FactoryProductionMenu g_gui non è pronto. Proverò più tardi.")
    end
end

function FactoryProductionMenu:registerActionEvents(FMenu)
    print("FactoryProductionMenu registrazione action event")
    if g_inputBinding and g_inputBinding.registerActionEvent then
        if FMenu or not FactoryProductionMenu.actionEventId then
            local success, actionEventId =
                g_inputBinding:registerActionEvent(
                    "FACTORYPRODUCTION_MENU",
                    FactoryProductionMenu,
                    FactoryProductionMenu.onMenuAction,
                    false,
                    true,
                    false,
                    true
                )
            print("FactoryProductionMenu success = " .. tostring(success))
            if success then
                g_inputBinding:setActionEventTextPriority(actionEventId, GS_PRIO_LOW)
                g_inputBinding:setActionEventActive(actionEventId, true)
                g_inputBinding:setActionEventText(actionEventId, g_i18n:getText("menu_FACTORYPRODUCTION_MENU"))
                g_inputBinding:setActionEventTextVisibility(actionEventId, true)
                print("FactoryProductionMenu Evento registrato con ID: " .. tostring(actionEventId))
            end
        end
    end
end

function FactoryProductionMenu:onMenuAction()
    self:toggleMenu()
end

function FactoryProductionMenu:toggleMenu()
    --print("FactoryProductionMenu: Tentativo di toggle menu")
    self.isMenuVisible = not self.isMenuVisible
    if self.isMenuVisible then
        --print("FactoryProductionMenu: Apertura menu")
        if g_gui then
            -- Mostra il menu usando il profilo creato
            FactoryProductionMenu.isActive = true
            g_gui:showDialog("FactoryProductionMenu", closeAllOthers)
            return true
        end
    end
end

function FactoryProductionMenu:onOpen()
    --print("FactoryProductionMenu: onOpen")

    FactoryProductionMenu.isActive = true

    FactoryProductionMenu:superClass().onOpen(self)

    -- Force cursor visibility
    g_inputBinding:setShowMouseCursor(true)

    -- Otteniamo l'elemento del titolo tramite l'ID "guiTitle"
    local gui = g_gui.guis.FactoryProductionMenu
    if gui == nil then
        print("La GUI FactoryProductionMenu non è disponibile.")
        return
    end
    local titleElement = findElementByIdRecursive(gui, "guiTitle")

    if titleElement then
        -- Modifica il testo del titolo
        titleElement:setText(g_i18n:getText("menu_FACTORYPRODUCTION_MENU"))
    else
        print("Elemento del titolo non trovato!")
    end
    self.listFactories()
end

function FactoryProductionMenu:listFactories()
    local productionPoints = g_currentMission.productionChainManager.productionPoints
    if productionPoints == nil or #productionPoints == 0 then
        print("FactoryProductionModifier Error: No productionPoints found")
        return
    end

    local inGameMenu = g_gui.screenControllers[InGameMenu]
    local settingsPage = inGameMenu.pageSettings
    local boxLayoutElement = findElementByIdRecursive(g_gui.guis.FactoryProductionMenu, "FPMboxLayout")
    local boxLayoutElementR = findElementByIdRecursive(g_gui.guis.FactoryProductionMenu, "FPMboxLayoutRight")
    if boxLayoutElement == nil then
        print("Error: Could not find FPMElementBox!")
        return
    end

    -- Rimozione manuale degli elementi
    while #boxLayoutElement.elements > 0 do
        boxLayoutElement:removeElement(boxLayoutElement.elements[1])
    end
    while #boxLayoutElementR.elements > 0 do
        boxLayoutElementR:removeElement(boxLayoutElementR.elements[1])
    end


    local originalButton = inGameMenu.contractorButton
    if originalButton == nil then
        print("Error: Could not find the original button to clone!")
        return
    end

    local firstButton = nil

    local yellowColor = {1, 1, 0, 1}
    local greenColor = {0.1, 1, 0.1, 1}
    local orangeColor = {1, 0.647, 0, 1}
    local redColor = {1, 0, 0, 1}

    -- Carica il file XML per i dati di manutenzione
    local userSettingsFile =
        Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance.xml", getUserProfileAppPath())
    local xmlFile = loadXMLFile("FactoryProductionSettings", userSettingsFile)

    if xmlFile == nil then
        print("Error: Could not load XML file for maintenance data")
        return
    end

    -- Funzione per ottenere i mesi di manutenzione per una fabbrica
    local function getMaintenanceMonths(factoryId)
        local pointIndex = 0
        while true do
            local basePath = string.format("settings.productionPoints.point(%d)", pointIndex)
            local currentFactoryId = getXMLString(xmlFile, basePath .. ".factoryId")

            if currentFactoryId == nil then
                break
            end

            if currentFactoryId == factoryId then
                local maintenanceKey = string.format("settings.productionPoints.point(%d).maintenanceMonths", pointIndex)
                return getXMLInt(xmlFile, maintenanceKey) or 0
            end
            pointIndex = pointIndex + 1
        end
        return 0 -- Se non trovato
    end

    -- Itera su ogni ProductionPoint
    for _, productionPoint in ipairs(productionPoints) do
        local unloadingStation = productionPoint.unloadingStation
        if unloadingStation and unloadingStation.owningPlaceable then
            local owningPlaceable = unloadingStation.owningPlaceable
            local storeItem = owningPlaceable.placeableLoadingData and owningPlaceable.placeableLoadingData.storeItem
            local nameCustom = owningPlaceable.nameCustom

            -- Se non c'è un nome personalizzato, usa il nome dal storeItem
            if nameCustom == nil or nameCustom == "" then
                nameCustom = storeItem and storeItem.name or "Unknown Factory"
            end

            -- Verifica la categoria
            if storeItem and storeItem.categoryName == "PRODUCTIONPOINTS" then
                local factoryId = owningPlaceable.uniqueId
                local factoryName = nameCustom

                local maintenanceMonths = getMaintenanceMonths(factoryId) -- Ottieni i mesi di manutenzione
                print(string.format("Maintenance months for factory %s (ID: %s): %d", factoryName, factoryId, maintenanceMonths))

                local repairCost = 0
                if maintenanceMonths == 1 then
                    repairCost = 2000
                elseif maintenanceMonths == 2 then
                    repairCost = 20000
                elseif maintenanceMonths == 3 then
                    repairCost = 30000
                elseif maintenanceMonths == 4 then
                    repairCost = 40000
                elseif maintenanceMonths == 5 then
                    repairCost = 50000
                elseif maintenanceMonths == 6 then
                    repairCost = 60000
                elseif maintenanceMonths == 7 then
                    repairCost = 70000
                elseif maintenanceMonths == 8 then
                    repairCost = 80000
                elseif maintenanceMonths >= 9 then
                    repairCost = 90000
                end

                local monthsText = string.format(g_i18n:getText("maintenance_info"), maintenanceMonths, repairCost)
                print(monthsText)

                -- Clona il pulsante e lo aggiungi alla lista
                local menuOptionBox = originalButton:clone(boxLayoutElement)
                menuOptionBox:setText(factoryName)
                menuOptionBox:setTextColor(0.89627, 0.92158, 0.81485, 1)
                menuOptionBox.id = string.format("%sButton", factoryId)
                menuOptionBox.handleFocus = true
                menuOptionBox.inputEnabled = true

                local defaultColor = {0.89627, 0.92158, 0.81485, 1} -- Colore di default
                local greenColor = {0.1, 1, 0.1, 1}

                menuOptionBox.onClickCallback = function()
                    print(string.format("Clicked on factory: %s", factoryName))
                    menuOptionBox:setTextColor(unpack(greenColor))

                    -- Verifica se ci sono abbastanza soldi per la riparazione
                    local playerMoney = g_currentMission.missionInfo.money
                    if playerMoney >= repairCost then
                        -- Sottrai l'ammontare della riparazione dai soldi del giocatore
                        g_currentMission:addMoney(
                            -repairCost,
                            g_currentMission:getFarmId(),
                            MoneyType.OTHER,
                            true,
                            true
                        )
                        print(string.format("Paying for factory repair: -%d money", repairCost))

                        -- Carica nuovamente il file XML per i dati di manutenzione
                        local userSettingsFile =
                            Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance.xml", getUserProfileAppPath())
                        local xmlFile = loadXMLFile("FactoryProductionSettings", userSettingsFile)

                        if xmlFile == nil then
                            print("Error: Could not load XML file for maintenance data")
                            return
                        end

                        -- Trova il nodo point con il factoryId corrispondente e aggiorna i mesi di manutenzione
                        local pointIndex = 0
                        while true do
                            local basePath = string.format("settings.productionPoints.point(%d)", pointIndex)
                            local currentFactoryId = getXMLString(xmlFile, basePath .. ".factoryId")

                            if currentFactoryId == nil then
                                break
                            end

                            if currentFactoryId == factoryId then
                                -- Resetta i mesi di manutenzione a 0
                                local maintenanceKey = string.format("settings.productionPoints.point(%d).maintenanceMonths", pointIndex)
                                setXMLInt(xmlFile, maintenanceKey, 0) -- Setta il valore a 0
                                print(string.format("Maintenance reset for factory: %s (ID: %s)", factoryName, factoryId))

                                -- Salva il file XML con le modifiche
                                saveXMLFile(xmlFile, userSettingsFile)
                                break
                            end
                            pointIndex = pointIndex + 1
                        end

                        -- Chiudi il file XML
                        delete(xmlFile)

                        -- Aggiorna il testo di manutenzione
                        if menuOptionBox.maintenanceText then
                            local updatedText = string.format(g_i18n:getText("maintenance_info"), 0, 0) -- Valori resettati
                            menuOptionBox.maintenanceText:setText(updatedText)
                        end
                    else
                        -- Non abbastanza soldi
                        print("Not enough money for repair!")
                    end
                end

                menuOptionBox:applyProfile(fs25_saveButton, true)
                menuOptionBox.profile = "fs25_saveButton"
                menuOptionBox.inputEnabled = true
                menuOptionBox.focusActive = true
                menuOptionBox.focusId = FocusManager:serveAutoFocusId()

                -- Creazione e gestione del testo di manutenzione
                local maintenanceText = TextElement:new()
                maintenanceText:setText(monthsText)
                maintenanceText:setTextColor(1, 1, 1, 1)
                maintenanceText:applyProfile(fs25_dialogText, true)
                maintenanceText.profile = "fs25_dialogText"
                maintenanceText:setSize(0.45, 0.033)
                maintenanceText.textVerticalAlignment = "top"
                maintenanceText.textAlignment = 0
                maintenanceText.setTextSize = 0.001
                maintenanceText.focusActive = true
                maintenanceText.focusId = FocusManager:serveAutoFocusId()

                -- Assegna il colore in base ai mesi di manutenzione
                if maintenanceMonths == 0 then
                    maintenanceText:setTextColor(unpack(greenColor))
                elseif maintenanceMonths == 1 then
                    maintenanceText:setTextColor(unpack(greenColor))
                elseif maintenanceMonths == 2 then
                    maintenanceText:setTextColor(unpack(yellowColor))
                elseif maintenanceMonths == 3 then
                    maintenanceText:setTextColor(unpack(yellowColor))
                elseif maintenanceMonths == 4 then
                    maintenanceText:setTextColor(unpack(yellowColor))
                elseif maintenanceMonths == 5 then
                    maintenanceText:setTextColor(unpack(orangeColor))
                elseif maintenanceMonths == 6 then
                    maintenanceText:setTextColor(unpack(orangeColor))
                elseif maintenanceMonths == 7 then
                    maintenanceText:setTextColor(unpack(orangeColor))
                elseif maintenanceMonths == 8 then
                    maintenanceText:setTextColor(unpack(redColor))
                elseif maintenanceMonths == 9 then
                    maintenanceText:setTextColor(unpack(redColor))
                elseif maintenanceMonths > 9 then
                    maintenanceText:setTextColor(unpack(redColor))
                else
                    print(maintenanceMonths)
                end

                menuOptionBox.maintenanceText = maintenanceText

                boxLayoutElement:addElement(menuOptionBox)
                boxLayoutElementR:addElement(maintenanceText)

                if firstButton == nil then
                    firstButton = menuOptionBox
                end

                print(string.format("Added button for factory: %s (ID: %s)", factoryName, factoryId))
            end
        end
    end

    -- Aggiorna layout dopo aver aggiunto tutti i pulsanti
    boxLayoutElement:invalidateLayout()
    boxLayoutElement:updateAbsolutePosition()
    boxLayoutElementR:invalidateLayout()
    boxLayoutElementR:updateAbsolutePosition()

    -- Se abbiamo trovato almeno un bottone, impostiamo il focus su di esso
    if firstButton then
        FocusManager:setFocus(firstButton)
    end

    -- Chiudi il file XML
    delete(xmlFile)
end
function FactoryProductionMenu:loadMaintenanceData(maintenanceData) --inutilizzato
    local userSettingsFile = Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance.xml", getUserProfileAppPath())

    -- Verifica se il file XML esiste
    local xmlFile
    if fileExists(userSettingsFile) then
        xmlFile = loadXMLFile("FactoryProductionSettings", userSettingsFile)
    else
        -- Se il file non esiste, lo inizializziamo
        self:initializeXML()
        return {}
    end

    local maintenanceData = {}

    -- Itera sui punti di produzione già caricati per caricare i dati dall'XML
    for _, productionPoint in ipairs(g_currentMission.productionChainManager.productionPoints) do
        local unloadingStation = productionPoint.unloadingStation
        if unloadingStation and unloadingStation.owningPlaceable then
            local owningPlaceable = unloadingStation.owningPlaceable
            local storeItem = owningPlaceable.placeableLoadingData and owningPlaceable.placeableLoadingData.storeItem
            local factoryId = tostring(owningPlaceable.uniqueId) -- Usa l'ID univoco della fabbrica
            local nameCustom = owningPlaceable.nameCustom

            -- Se non c'è un nome personalizzato, usa il nome dal storeItem
            if nameCustom == nil or nameCustom == "" then
                nameCustom = storeItem and storeItem.name or "Unknown Factory"
            end

            -- Verifica la categoria
            if storeItem and storeItem.categoryName == "PRODUCTIONPOINTS" then
                -- Percorso corretto nell'XML per leggere il nome e i mesi di manutenzione
                local maintenanceKey = string.format("settings.productionPoints.%s.maintenanceMonths", factoryId)
                --print(maintenanceKey)
                local nameKey = string.format("settings.productionPoints.%s.name", factoryId)
                --print(nameKey)
                -- Leggi i dati di manutenzione e il nome della fabbrica
                local maintenanceMonths = getXMLInt(xmlFile, maintenanceKey)
                --print(maintenanceMonths)
                local factoryName = getXMLString(xmlFile, nameKey)
                --print(factoryName)
                -- Se i dati di manutenzione non esistono, possiamo usarne di default
                if maintenanceMonths == nil then
                    maintenanceMonths = 0 -- Default se non esistono dati
                end
                if factoryName == nil then
                    factoryName = "Unknown Factory" -- Nome di fallback se non esiste
                end

                -- Aggiungi i dati alla tabella
                maintenanceData[factoryId] = {
                    maintenanceMonths = maintenanceMonths,
                    name = factoryName
                }
            end
        end
    end

    -- Chiudi il file XML dopo aver caricato i dati
    delete(xmlFile)

    -- Restituisce i dati di manutenzione caricati
    return maintenanceData
end

function FactoryProductionMenu:initializeXML()
    local permanentSettingsFile = Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance_final.xml", getUserProfileAppPath())
    local userSettingsFile = Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance.xml", getUserProfileAppPath())
    local factoryCounter = 0
    -- Verifica se il file XML esiste
    local xmlFile
    if not fileExists(userSettingsFile) and not fileExists(permanentSettingsFile) then
        local folderPath = Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier", getUserProfileAppPath())

        -- Verifica se la cartella esiste già, altrimenti creala
        if not fileExists(folderPath) then
            createFolder(folderPath)
            print("La cartella FS25_FactoryProductionMultiplier è stata creata con successo.")
        else
            print("La cartella FS25_FactoryProductionMultiplier esiste già.")
        end

        print("FactoryProductionMenu Creo nuovo file xml per la manutenzione .")
        -- Se entrambi i file non esistono, creiamo un file vuoto con la struttura di base
        xmlFile = createXMLFile("FactoryProductionSettings", userSettingsFile, "settings")

        -- Aggiungiamo un nodo "productionPoints" vuoto
        setXMLString(xmlFile, "settings.productionPoints", "")

        -- Itera su ogni ProductionPoint e aggiungi i dati nell'XML
        for _, productionPoint in ipairs(g_currentMission.productionChainManager.productionPoints) do
            local unloadingStation = productionPoint.unloadingStation

            if unloadingStation and unloadingStation.owningPlaceable then
                local owningPlaceable = unloadingStation.owningPlaceable
                local storeItem = owningPlaceable.placeableLoadingData and owningPlaceable.placeableLoadingData.storeItem
                local nameCustom = owningPlaceable.nameCustom

                if nameCustom == nil or nameCustom == "" then
                    nameCustom = storeItem and storeItem.name or "Unknown Factory"
                end

                if storeItem and storeItem.categoryName == "PRODUCTIONPOINTS" then
                    local factoryId = owningPlaceable.uniqueId
                    factoryCounter = factoryCounter + 1

                    -- Nuovo schema XML
                    local baseNodePath = string.format("settings.productionPoints.point(%d)", factoryCounter - 1)
                    setXMLString(xmlFile, baseNodePath .. "#id", tostring(factoryCounter))
                    setXMLInt(xmlFile, baseNodePath .. ".maintenanceMonths", 0)
                    setXMLString(xmlFile, baseNodePath .. ".name", nameCustom)
                    setXMLString(xmlFile, baseNodePath .. ".factoryId", factoryId)
                end
            end
        end

        -- Salva il file XML con i dati iniziali
        saveXMLFile(xmlFile)
        delete(xmlFile) -- Chiude il file
        print("FactoryProductionMenu XML file initialized and populated with factories.")

    elseif fileExists(userSettingsFile) and fileExists(permanentSettingsFile) then
        -- Se entrambi i file esistono, sovrascriviamo il file temporaneo con il file definitivo
        copyFile(permanentSettingsFile, userSettingsFile, true)
        print("FactoryProductionMenu Temporary XML file updated with permanent data.")

    elseif not fileExists(userSettingsFile) and fileExists(permanentSettingsFile) then
        -- Se solo il file definitivo esiste, copiamo i dati nel file temporaneo
        copyFile(permanentSettingsFile, userSettingsFile, true)
        print("FactoryProductionMenu Copied permanent data to temporary XML file.")

    elseif fileExists(userSettingsFile) and not fileExists(permanentSettingsFile) then
        -- Cancella il file temporaneo e richiamata la funzione di inizializzazione
        deleteFile(userSettingsFile)
        print("FactoryProductionMenu Deleted temporary XML file.")
        -- Richiama la funzione per ricreare il file
        FactoryProductionMenu:initializeXML()
    else
        -- Questo caso non dovrebbe mai accadere
        print("FactoryProductionMenu Unexpected condition: Something went wrong.")
    end

end

function FactoryProductionMenu:incrementMaintenanceMonths()
    local userSettingsFile = Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance.xml", getUserProfileAppPath())
    local xmlFile = loadXMLFile("FactoryProductionSettings", userSettingsFile)

    if xmlFile == nil then
        print("Error: Could not load XML file for maintenance data")
        return
    end

    -- Lista di fabbriche, recuperate dalle tue strutture di gioco, ad esempio:
    for _, productionPoint in ipairs(g_currentMission.productionChainManager.productionPoints) do
        local unloadingStation = productionPoint.unloadingStation
        if unloadingStation and unloadingStation.owningPlaceable then
            local owningPlaceable = unloadingStation.owningPlaceable
            local factoryId = owningPlaceable.uniqueId
            local storeItem = owningPlaceable.placeableLoadingData and owningPlaceable.placeableLoadingData.storeItem
            local nameCustom = owningPlaceable.nameCustom

            if nameCustom == nil or nameCustom == "" then
                nameCustom = storeItem and storeItem.name or "Unknown Factory"
            end

            if storeItem and storeItem.categoryName == "PRODUCTIONPOINTS" then
                local nodeIndex = 0
                local found = false

                while true do
                    local nodePath = string.format("settings.productionPoints.point(%d)", nodeIndex)
                    local storedFactoryId = getXMLString(xmlFile, nodePath .. ".factoryId")

                    if storedFactoryId == nil then
                        break
                    end

                    if storedFactoryId == factoryId then
                        local maintenanceKey = nodePath .. ".maintenanceMonths"
                        local maintenanceMonths = getXMLInt(xmlFile, maintenanceKey)

                        if maintenanceMonths == nil then
                            print("FactoryProductionMenu maintenanceMonths rilevato nil")
                            maintenanceMonths = 0
                        end

                        maintenanceMonths = maintenanceMonths + 1
                        setXMLInt(xmlFile, maintenanceKey, maintenanceMonths)
                        found = true
                        break
                    end

                    nodeIndex = nodeIndex + 1
                end

                if not found then
                    print(string.format("Factory with ID %s not found in XML", factoryId))
                end
            end
        end
    end

    -- Salva i dati nel file XML
    saveXMLFile(xmlFile)
    delete(xmlFile)

    --print("Maintenance months incremented successfully.")
end

function FactoryProductionMenu:searchNewFactories()
    -- Carica il file XML esistente
    local userSettingsFile = Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance.xml", getUserProfileAppPath())
    local xmlFile = loadXMLFile("FactoryProductionSettings", userSettingsFile)

    if xmlFile == nil then
        print("Error: Could not load XML file for maintenance data")
        return
    end

    -- Ottieni i punti di produzione
    local productionPoints = g_currentMission.productionChainManager.productionPoints

    -- Itera su ogni punto di produzione
    for _, productionPoint in ipairs(productionPoints) do
        local unloadingStation = productionPoint.unloadingStation
        if unloadingStation and unloadingStation.owningPlaceable then
            local owningPlaceable = unloadingStation.owningPlaceable
            local storeItem = owningPlaceable.placeableLoadingData and owningPlaceable.placeableLoadingData.storeItem
            local nameCustom = owningPlaceable.nameCustom

            if nameCustom == nil or nameCustom == "" then
                nameCustom = storeItem and storeItem.name or "Unknown Factory"
            end

            if storeItem and storeItem.categoryName == "PRODUCTIONPOINTS" then
                local factoryId = owningPlaceable.uniqueId

                -- Verifica se la fabbrica è già presente nell'XML
                local found = false
                local nodeIndex = 0

                -- Cerca se il factoryId è già presente nell'XML
                while true do
                    local basePath = string.format("settings.productionPoints.point(%d)", nodeIndex)
                    local existingFactoryId = getXMLString(xmlFile, basePath .. ".factoryId")

                    if existingFactoryId == nil then
                        break -- se il factoryId non esiste, possiamo fermarci
                    end

                    if existingFactoryId == factoryId then
                        found = true
                        break -- se troviamo un match, non aggiungiamo la fabbrica
                    end

                    nodeIndex = nodeIndex + 1
                end

                -- Se la fabbrica non è già presente, aggiungiamola
                if not found then
                    local basePath = string.format("settings.productionPoints.point(%d)", nodeIndex)
                    setXMLString(xmlFile, basePath .. "#id", tostring(nodeIndex + 1))
                    setXMLString(xmlFile, basePath .. ".name", nameCustom)
                    setXMLString(xmlFile, basePath .. ".factoryId", factoryId)
                    setXMLInt(xmlFile, basePath .. ".maintenanceMonths", 0)
                    print(string.format("Added new factory: %s (ID: %s)", nameCustom, factoryId))
                end
            end
        end
    end

    -- Salva i dati aggiornati nel file XML
    saveXMLFile(xmlFile)
    delete(xmlFile)
end

function FactoryProductionMenu:savePermanentData()
    local userSettingsFile = Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance.xml", getUserProfileAppPath())
    local permanentSettingsFile = Utils.getFilename("modSettings/FS25_FactoryProductionMultiplier/FactoryProductionMaintenance_final.xml", getUserProfileAppPath())

    -- Crea una copia del file temporaneo nel file definitivo
    if fileExists(userSettingsFile) then
        copyFile(userSettingsFile, permanentSettingsFile, true)
        print("Saved changes to permanent data.")
    else
        print("Error: No temporary file to save.")
    end
end

function FactoryProductionMenu:onClose()
    --print("FactoryProductionMenu: onClose")
    FactoryProductionMenu.isActive = false
    FactoryProductionMenu.isMenuVisible = false

    -- Reset cursor and input context
    g_inputBinding:setShowMouseCursor(false)
end

function FactoryProductionMenu:onClickClose()
    g_gui:closeDialogByName("FactoryProductionMenu")
    self:onClose()
end

function FactoryProductionMenu:onClickOk()
    --print("FactoryProductionMenu: onClickOk")
    g_gui:closeDialogByName("FactoryProductionMenu")
    g_gui:changeScreen(nil)
    self:onClose()
end

function FactoryProductionMenu:delete()
    if g_inputBinding then
        g_inputBinding:removeActionEventsByTarget(self)
        print("FactoryProductionMenu: Eventi rimossi durante delete")
    end
end

function FactoryProductionMenu:deleteMap()
    -- Rimuovi il riferimento globale quando la mod viene scaricata
    g_factoryProductionMenu = nil

    if g_inputBinding then
        g_inputBinding:removeActionEventsByTarget(self)
        print("FactoryProductionMenu: Eventi rimossi durante delete")
    end
end

function FactoryProductionMenu:update(dt)
    local player = g_localPlayer
    local isInVehicle = player:getIsInVehicle()

    FactoryProductionMenu.playerIsEntered = player.isControlled and not isInVehicle

    if FactoryProductionMenu.playerIsEntered and not g_gui:getIsGuiVisible() then
        if not FactoryProductionMenu.initialised then
            print("FactoryProductionMenu inizializzo ancora")
            FactoryProductionMenu:registerActionEvents()
            FactoryProductionMenu.initialised = true
        end
    else
    -- print("FactoryProductionMenu in veicolo o in menu")
    end
    FactoryProductionMenu:searchNewFactories()
end

function findElementByIdRecursive(element, targetId)
    -- Verifica che l'elemento esista prima di procedere
    if element == nil then
        return nil
    end

    -- Controlla se l'elemento corrente ha l'ID che stiamo cercando
    if element.id == targetId then
        return element
    end

    -- Se l'elemento ha dei figli, cerca ricorsivamente in ciascuno di essi
    if element.elements then
        for _, child in ipairs(element.elements) do
            local found = findElementByIdRecursive(child, targetId)
            if found then
                return found
            end
        end
    end

    -- Se non trovato, ritorna nil
    return nil
end

function FactoryProductionMenu.onSavegame()
    if g_factoryProductionMenu ~= nil then
        g_factoryProductionMenu:savePermanentData()
    end
end

FSBaseMission.onStartMission =
    Utils.appendedFunction(
        FSBaseMission.onStartMission,
        function()
            FactoryProductionMenu:loadMaintenanceData()
        end
    )

-- Crea una nuova istanza e registra il mod
local modMenu = FactoryProductionMenu:new()
g_factoryProductionMenu = modMenu
addModEventListener(modMenu)
