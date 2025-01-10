--[[
IncreasedProduction
Author: 	Kiokoman
Date: 		25.12.2024
Version:	1.0.0.0
]]
FactoryProductionModifier = {}
FactoryProductionModifier.path = g_currentModDirectory
local FactoryProductionModifier_mt = Class(FactoryProductionModifier)


local ProductionsIds = {
    {id = "cheese", name = "production_cheese"},
    {id = "butter_buffaloMilk", name = "production_butter_buffaloMilk"},
    {id = "butter_milk", name = "production_butter_milk"},
    {id = "butter_goatMilk", name = "production_butter_goatMilk"},
    {id = "goatcheese", name = "production_goatcheese"},
    {id = "buffalomozzarella", name = "production_buffalomozzarella"},
    {id = "chocolate", name = "production_chocolate"},
    {id = "milkBottled", name = "production_milkBottled"},
    {id = "goatmilkBottled", name = "production_goatmilkBottled"},
    {id = "buffalomilkBottled", name = "production_buffalomilkBottled"},
    {id = "flourMaize", name = "production_flourMaize"},
    {id = "flourWheat", name = "production_flourWheat"},
    {id = "flourSunflower", name = "production_flourSunflower"},
    {id = "flourCanola", name = "production_flourCanola"},
    {id = "flourSoybean", name = "production_flourSoybean"},
    {id = "flourBarley", name = "production_flourBarley"},
    {id = "flourOat", name = "production_flourOat"},
    {id = "flourSorghum", name = "production_flourSorghum"},
    {id = "flourRiceLongGrain", name = "production_flourRiceLongGrain"},
    {id = "flourRice", name = "production_flourRice"},
    {id = "sugarbeet_sugar", name = "production_sugarbeet_sugar"},
    {id = "sugarbeetCut_sugar", name = "production_sugarbeetCut_sugar"},
    {id = "sugarcane_sugar", name = "production_sugarcane_sugar"},
    {id = "bread", name = "production_bread"},
    {id = "cake", name = "production_cake"},
    {id = "breadRiceFlour", name = "production_breadRiceFlour"},
    {id = "cakeRiceFlour", name = "production_cakeRiceFlour"},
    {id = "furnitureWood", name = "production_furnitureWood"},
    {id = "furnitureBoards", name = "production_furnitureBoards"},
    {id = "furniturePlanks", name = "production_furniturePlanks"},
    {id = "cereal_raisins", name = "production_cereal_raisins"},
    {id = "cereal_chocolate", name = "production_cereal_chocolate"},
    {id = "cereal_riceLongGrain", name = "production_cereal_riceLongGrain"},
    {id = "cereal_rice", name = "production_cereal_rice"},
    {id = "cereal_chocolate", name = "production_cereal_chocolate"},
    {id = "raisins", name = "production_raisins"},
    {id = "grapejuice", name = "production_grapejuice"},
     --    production id="grapePallet" not available in the game yet --
    {id = "biogas", name = "production_biogas"},
    {id = "biogasLiquidManure", name = "production_biogasLiquidManure"},
    {id = "biogasManure", name = "production_biogasManure"},
    {id = "biogasSugarbeetCut", name = "production_biogasSugarbeetCut"},
    {id = "sunflower_oil", name = "production_sunflower_oil"},
    {id = "canola_oil", name = "production_canola_oil"},
    {id = "olive_oil", name = "production_olive_oil"},
    {id = "rice_oil_longGrainRice", name = "production_rice_oil_longGrainRice"},
    {id = "rice_oil_rice", name = "production_rice_oil_rice"},
    {id = "cartonRoll", name = "production_cartonRoll"},
    {id = "paperRoll", name = "production_olive_oil"},
    {id = "boards", name = "production_boards"},
    {id = "planks", name = "production_planks"},
    {id = "woodBeam", name = "production_woodBeam"},
    {id = "prefabWall", name = "production_prefabWall"},
    {id = "fabric_wool", name = "production_fabric_wool"},
    {id = "fabric_cotton", name = "production_fabric_cotton"},
    {id = "clothes", name = "production_clothes"},
    {id = "preservedFoodCarrots", name = "production_preservedFoodCarrots"},
    {id = "preservedFoodParsnip", name = "production_preservedFoodParsnip"},
    {id = "preservedFoodBeetRoot", name = "production_preservedFoodBeetRoot"},
    {id = "preservedFoodCannedPea", name = "production_preservedFoodCannedPea"},
    {id = "preservedFoodSpinachBags", name = "production_preservedFoodSpinachBags"},
    {id = "preservedFoodRiceBags", name = "production_preservedFoodRiceBags"},
    {id = "preservedFoodRiceBoxes", name = "production_preservedFoodRiceBoxes"},
    {id = "preservedFoodjarredGreenbean", name = "production_preservedFoodjarredGreenbean"},
    {id = "preservedFoodFermentedNapaCabbage", name = "production_preservedFoodFermentedNapaCabbage"},
    {id = "noodleSoupFlour", name = "production_noodleSoupFlour"},
    {id = "noodleSoupRiceFlour", name = "production_noodleSoupRiceFlour"},
    {id = "riceRollsRiceLongGrain", name = "production_riceRollsRiceLongGrain"},
    {id = "riceRollsRice", name = "production_riceRollsRice"},
    {id = "ropePalletCotton", name = "production_ropePalletCotton"},
    {id = "ropePalletWool", name = "production_ropePalletWool"},
    {id = "cementBags", name = "production_cementBags"},
    {id = "roofPlate", name = "production_roofPlate"},
    {id = "cementBrick", name = "production_cementBrick"},
    {id = "potatoChips_sunflowerOil", name = "production_potatoChips_sunflowerOil"},
    {id = "potatoChips_canolaOil", name = "production_potatoChips_canolaOil"},
    {id = "potatoChips_oliveOil", name = "production_potatoChips_oliveOil"},
    {id = "soupCansMixed", name = "production_soupCansMixed"},
    {id = "soupCansCarrots", name = "production_soupCansCarrots"},
    {id = "soupCansParsnip", name = "production_soupCansParsnip"},
    {id = "soupCansBeetroot", name = "production_soupCansBeetroot"},
    {id = "soupCansPotato", name = "production_soupCansPotato"},
    {id = "barrelPlanks", name = "production_barrelPlanks"},
    {id = "bucketPlanks", name = "production_bucketPlanks"},
    {id = "bathtubPlanks", name = "production_bathtubPlanks"},
    {id = "barrelBoards", name = "production_barrelBoards"},
    {id = "bucketBoards", name = "production_bucketBoards"},
    {id = "bathtubBoards", name = "production_bathtubBoards"}
}

FactoryProductionModifier = {
    SETTINGS = {
        multiplier = 2,
        selectedValue = 2,
        productionEnabled = {}, -- per salvare lo stato delle checkbox
        originalValues = {} -- per salvare i valori originali
    },
    path = g_currentModDirectory
}

local FactoryProductionModifier_mt = Class(FactoryProductionModifier)

FactoryProductionModifier.CONFIG_FILENAME = "factoryProductionModifier.xml"

function FactoryProductionModifier.new()
    local self = setmetatable({}, FactoryProductionModifier_mt)
    self.isLoaded = false
    self.loadTimer = 0
    return self
end

function FactoryProductionModifier:loadConfig()
    local userSettingsFile = Utils.getFilename("modSettings/FactoryProductionModifier.xml", getUserProfileAppPath())
    if fileExists(userSettingsFile) then
        local xmlFile = loadXMLFile("FactoryProductionSettings", userSettingsFile)
        if xmlFile ~= 0 then
            self.SETTINGS.multiplier = Utils.getNoNil(getXMLFloat(xmlFile, "factoryProduction#multiplier"), 2)
            self.SETTINGS.selectedValue = Utils.getNoNil(getXMLInt(xmlFile, "factoryProduction#selectedValue"), 2)

            -- Carica lo stato di ogni produzione
            for _, prod in ipairs(ProductionsIds) do
                self.SETTINGS.productionEnabled[prod.id] =
                    Utils.getNoNil(getXMLBool(xmlFile, "factoryProduction.productions." .. prod.id .. "#enabled"), true)
            end

            delete(xmlFile)
        end
    end
end

function FactoryProductionModifier:getCurrentMonth()    -- Verifica se g_currentMission.environment esiste
    if g_currentMission and g_currentMission.environment then
        local currentSeason = g_currentMission.environment.currentSeason
        local dayInSeason = g_currentMission.environment.currentDayInSeason
        local daysPerPeriod = g_currentMission.environment.daysPerPeriod  -- parametro per i giorni per periodo
        
        -- Calcola il mese in base alla stagione e al numero di giorni per periodo
        local month
        
        -- Calcola quale mese corrisponde
        local monthIndex = math.ceil(dayInSeason / daysPerPeriod)  -- Dividi i giorni in base alla durata del periodo
        
        -- Determina il mese sulla base della stagione
        if currentSeason == 1 then
            -- Primavera (Marzo, Aprile, Maggio)
            if monthIndex == 1 then
                month = 3 -- Marzo
            elseif monthIndex == 2 then
                month = 4 -- Aprile
            elseif monthIndex == 3 then
                month = 5 -- Maggio
            end
        elseif currentSeason == 2 then
            -- Estate (Giugno, Luglio, Agosto)
            if monthIndex == 1 then
                month = 6 -- Giugno
            elseif monthIndex == 2 then
                month = 7 -- Luglio
            elseif monthIndex == 3 then
                month = 8 -- Agosto
            end
        elseif currentSeason == 3 then
            -- Autunno (Settembre, Ottobre, Novembre)
            if monthIndex == 1 then
                month = 9 -- Settembre
            elseif monthIndex == 2 then
                month = 10 -- Ottobre
            elseif monthIndex == 3 then
                month = 11 -- Novembre
            end
        elseif currentSeason == 4 then
            -- Inverno (Dicembre, Gennaio, Febbraio)
            if monthIndex == 1 then
                month = 12 -- Dicembre
            elseif monthIndex == 2 then
                month = 1 -- Gennaio
            elseif monthIndex == 3 then
                month = 2 -- Febbraio
            end
        end
        return month
    else
        print("g_currentMission.environment non esiste!")
        return nil
    end
end

function FactoryProductionModifier:updateProductionCycles(production)
    -- Debug: Stampa il mese corrente
    local currentMonth = self:getCurrentMonth()
    print(string.format("FactoryProductionModifier - Current Month: %d", currentMonth))

    -- Verifica se la produzione è abilitata
    if not self:isProductionId(production.id) then
        print(string.format("FactoryProductionModifier - Production %s is disabled", production.id))
        return
    end

    if not production or not self.SETTINGS.originalValues[production.id] then
        print("FactoryProductionModifier - Missing production or original values")
        return
    end

    -- Debug: Stampa i valori originali
    print(string.format("FactoryProductionModifier - Original values for %s:", production.id))
    if self.SETTINGS.originalValues[production.id].cyclesPerHour then
        print(string.format("  Original cyclesPerHour: %f", self.SETTINGS.originalValues[production.id].cyclesPerHour))
    end

    -- Check if current month is August (8) or December (12)
    if currentMonth == 8 or currentMonth == 12 then
        print(string.format("FactoryProductionModifier - Month %d detected, resetting to original values", currentMonth))
        
        -- Reset to original values for August and December
        if self.SETTINGS.originalValues[production.id].cyclesPerMinute then
            production.cyclesPerMinute = self.SETTINGS.originalValues[production.id].cyclesPerMinute
            print(string.format("  Reset cyclesPerMinute to: %f", production.cyclesPerMinute))
        end
        if self.SETTINGS.originalValues[production.id].cyclesPerHour then
            production.cyclesPerHour = self.SETTINGS.originalValues[production.id].cyclesPerHour
            print(string.format("  Reset cyclesPerHour to: %f", production.cyclesPerHour))
        end
        if self.SETTINGS.originalValues[production.id].cyclesPerMonth then
            production.cyclesPerMonth = self.SETTINGS.originalValues[production.id].cyclesPerMonth
            print(string.format("  Reset cyclesPerMonth to: %f", production.cyclesPerMonth))
        end
        return
    end

    local original = self.SETTINGS.originalValues[production.id]
    local multiplier = tonumber(self.SETTINGS.multiplier)

    if not multiplier then
        print("FactoryProductionModifier - Invalid multiplier value")
        return
    end

    print(string.format("FactoryProductionModifier - Applying multiplier %f", multiplier))

    -- Apply multiplier for all other months
    if original.cyclesPerMinute then
        production.cyclesPerMinute = original.cyclesPerMinute * multiplier
        print(string.format("  Set cyclesPerMinute to: %f", production.cyclesPerMinute))
    end
    if original.cyclesPerHour then
        production.cyclesPerHour = original.cyclesPerHour * multiplier
        print(string.format("  Set cyclesPerHour to: %f", production.cyclesPerHour))
    end
    if original.cyclesPerMonth then
        production.cyclesPerMonth = original.cyclesPerMonth * multiplier
        print(string.format("  Set cyclesPerMonth to: %f", production.cyclesPerMonth))
    end
end

function FactoryProductionModifier:reset()
    self.SETTINGS.originalValues = {}
    self.isLoaded = false
end

function FactoryProductionModifier:load(mission)
    print("FactoryProductionModifier - Load function called")
    
    if self.isLoaded then
        print("FactoryProductionModifier - Already loaded, skipping")
        return
    end

    if mission == nil then
        print("FactoryProductionModifier Error: Invalid mission object")
        return
    end

    if mission.productionChainManager == nil then
        print("FactoryProductionModifier Error: ProductionChainManager not found")
        return
    end

    local pcm = mission.productionChainManager

    if pcm.productionPoints == nil then
        print("FactoryProductionModifier Error: No production points found")
        return
    end

    -- Debug: Print current month before processing
    local currentMonth = self:getCurrentMonth()
    print(string.format("FactoryProductionModifier - Processing productions for month: %d", currentMonth))

    local success, result = pcall(
        function()
            local count = 0
            for _, point in pairs(pcm.productionPoints) do
                if point and point.productions then
                    for _, prod in pairs(point.productions) do
                        if prod and prod.id and self:isProductionId(prod.id) then
                            if not self.SETTINGS.originalValues[prod.id] then
                                print(string.format("FactoryProductionModifier - Saving original values for production: %s", prod.id))
                                self.SETTINGS.originalValues[prod.id] = {
                                    cyclesPerMinute = prod.cyclesPerMinute,
                                    cyclesPerHour = prod.cyclesPerHour,
                                    cyclesPerMonth = prod.cyclesPerMonth
                                }
                            end

                            self:updateProductionCycles(prod)
                            count = count + 1
                        end
                    end
                end
            end
            return count
        end
    )

    if success then
        print(string.format("FactoryProductionModifier: Successfully processed %d productions", result))
        self.isLoaded = true
    else
        print("FactoryProductionModifier Error: " .. tostring(result))
    end
end

function FactoryProductionModifier:isProductionId(prodId)
    for _, prod in ipairs(ProductionsIds) do
        if prod.id == prodId then
            return self.SETTINGS.productionEnabled[prod.id] ~= false
        end
    end
    return false
end

function FactoryProductionModifier:update(dt)
    -- Initial load handling
    if not self.isLoaded then
        self.loadTimer = self.loadTimer + dt
        if self.loadTimer >= 200 then
            print("FactoryProductionModifier - Initial load triggered")
            self:load(g_currentMission)
            -- Non rimuoviamo più l'updateable per continuare a monitorare i cambiamenti di mese
        end
        return
    end

    -- Verifica se g_currentMission e environment esistono
    if not g_currentMission or not g_currentMission.environment then
        return
    end

    -- Ottieni il mese corrente
    local currentMonth = self:getCurrentMonth()
    if not currentMonth then
        return
    end

    -- Inizializza lastCheckedMonth se non esiste
    if not self.lastCheckedMonth then
        self.lastCheckedMonth = currentMonth
        print(string.format("FactoryProductionModifier - Initial month set to: %d", self.lastCheckedMonth))
        return
    end

    -- Controlla se il mese è cambiato
    if currentMonth ~= self.lastCheckedMonth then
        print(string.format("FactoryProductionModifier - Month changed from %d to %d", self.lastCheckedMonth, currentMonth))
        self.lastCheckedMonth = currentMonth

        -- Ricarica tutte le produzioni con i nuovi valori
        if g_currentMission and g_currentMission.productionChainManager then
            local pcm = g_currentMission.productionChainManager
            if pcm.productionPoints then
                for _, point in pairs(pcm.productionPoints) do
                    if point and point.productions then
                        for _, prod in pairs(point.productions) do
                            if prod and prod.id and self:isProductionId(prod.id) then
                                self:updateProductionCycles(prod)
                            end
                        end
                    end
                end
            end
        end
    end
end


function FactoryProductionModifier:onSettingsChanged()
    self.isLoaded = false
    self:load(g_currentMission)
end

function FactoryProductionModifier:onLoadGame(mission)
    if mission:getIsClient() then
        -- Accedi al menu delle impostazioni
        local inGameMenu = g_gui.screenControllers[InGameMenu]
        local settingsPage = inGameMenu.pageSettings

        -- Aggiungi il titolo della sezione per il moltiplicatore della produzione
        local sectionTitle = nil
        for idx, elem in ipairs(settingsPage.generalSettingsLayout.elements) do
            if elem.name == "sectionHeader" then
                sectionTitle = elem:clone(settingsPage.generalSettingsLayout)
                break
            end
        end

        -- Crea una nuova intestazione di sezione se non esiste
        if sectionTitle then
            sectionTitle:setText(g_i18n:getText("factoryProduction_settings"))
        else
            sectionTitle = TextElement.new()
            sectionTitle:applyProfile("fs25_settingsSectionHeader", true)
            sectionTitle:setText(g_i18n:getText("factoryProduction_settings"))
            sectionTitle.name = "sectionHeader"
            settingsPage.generalSettingsLayout:addElement(sectionTitle)
        end

        -- Assign new focus ID to section
        sectionTitle.focusId = FocusManager:serveAutoFocusId()
        table.insert(settingsPage.controlsList, sectionTitle)

        -- Force layout recalculation
        settingsPage.generalSettingsLayout:invalidateLayout()

        local originalSlider = settingsPage.multiVolumeVoiceBox
        local multiplierSlider = originalSlider:clone(settingsPage.generalSettingsLayout)

        -- Set proper IDs for the slider and its elements
        multiplierSlider.id = "factoryMultiplierSlider"
        if multiplierSlider.elements[1] then
            local multiOption = multiplierSlider.elements[1]
            multiOption.id = "factoryMultiplierSlider_option"

            -- Configure the multi option settings
            multiOption.texts = {"1x ", "2x ", "3x ", "4x ", "5x "}
            multiOption.values = {1, 2, 3, 4, 5}
            local initialState = tonumber(self.SETTINGS.selectedValue) or 2
            multiOption:setState(initialState)
            print("DEBUG: Setting initial state to: " .. tostring(initialState))
            -- Store reference to our mod environment
            local mod = self

            -- Setup required callbacks and events

            multiOption.onClickCallback = function()
                local selectedIndex = multiOption:getState()
                print("DEBUG: Selected Index: " .. tostring(selectedIndex))

                if selectedIndex and selectedIndex >= 1 and selectedIndex <= #multiOption.values then
                    local value = multiOption.values[selectedIndex]
                    self.SETTINGS.multiplier = value
                    self.SETTINGS.selectedValue = selectedIndex
                    self:saveConfig()
                    self:onSettingsChanged()
                end
            end

            for i = 1, #multiOption.texts do
            end

            multiOption.onOptionSelected = function(index)
                if type(index) == "number" and index >= 1 and index <= #multiOption.values then
                    local value = multiOption.values[index]
                    if multiOption.onOptionChanged ~= nil then
                        multiOption:onOptionChanged(value)
                    end
                end
            end

            multiOption.onOptionChanged = function(_, value)
                if type(value) == "number" then
                    mod.SETTINGS.multiplier = value
                    mod.SETTINGS.selectedValue = multiOption.state
                    mod:saveConfig()
                    mod:onSettingsChanged()
                    print("FactoryProductionModifier - Value changed to: " .. tostring(value))
                end
            end

            -- Set initial state
            local initialState = tonumber(self.SETTINGS.selectedValue) or 2
            multiOption:setState(initialState)
        end

        -- Update all focus IDs
        local function updateFocusIds(element)
            if not element then
                return
            end
            element.focusId = FocusManager:serveAutoFocusId()
            if element.elements then
                for _, child in pairs(element.elements) do
                    updateFocusIds(child)
                end
            end
        end
        updateFocusIds(multiplierSlider)

        -- Set tooltip and label text
        if multiplierSlider.elements[1] and multiplierSlider.elements[1].elements[1] then
            local toolTip = multiplierSlider.elements[1].elements[1]
            toolTip:setText(g_i18n:getText("factoryProduction_multiplier_tooltip"))
        end

        if multiplierSlider.elements[2] then
            local setting = multiplierSlider.elements[2]
            setting:setText(g_i18n:getText("factoryProduction_multiplier"))
        end

        -- Add the slider to the controls list
        table.insert(settingsPage.controlsList, multiplierSlider)
        multiplierSlider:updateAbsolutePosition()

        -- Force layout recalculation
        settingsPage.generalSettingsLayout:invalidateLayout()

        -- Aggiungi il titolo della sezione per il moltiplicatore della produzione
        local sectionProd = nil
        for idx, elem in ipairs(settingsPage.generalSettingsLayout.elements) do
            if elem.name == "sectionHeader" then
                sectionProd = elem:clone(settingsPage.generalSettingsLayout)
                break
            end
        end

        -- Crea una nuova intestazione di sezione se non esiste
        if sectionProd then
            sectionProd:setText(g_i18n:getText("factoryProduction_prod"))
        else
            sectionProd = TextElement.new()
            sectionProd:applyProfile("fs25_settingsSectionHeader", true)
            sectionProd:setText(g_i18n:getText("factoryProduction_prod"))
            sectionProd.name = "sectionProd"
            settingsPage.generalSettingsLayout:addElement(sectionProd)
            settingsPage.generalSettingsLayout:invalidateLayout()
        end

        -- Clona la checkbox per ogni produzione
        for _, prod in ipairs(ProductionsIds) do
            local originalBox = settingsPage.checkCameraCheckCollisionBox
            local menuOptionBox = originalBox:clone(settingsPage.generalSettingsLayout)
            menuOptionBox.id = prod.id .. "box"

            local menuBinaryOption = menuOptionBox.elements[1]
            menuBinaryOption.id = prod.id
            menuBinaryOption.target = sectionProd

            -- Store reference to our mod environment
            local mod = self
            
            -- Set up the callback properly
            menuBinaryOption.onClickCallback = function()
                local state = menuBinaryOption:getState()
                mod:onMenuOptionChanged(state, prod.id)
                print(string.format("Checkbox changed for %s to state %s", prod.id, tostring(state)))
            end

            -- Set texts and initial state
            menuBinaryOption:setTexts({"Enabled", "Disabled"})
            menuBinaryOption:setDisabled(false)

            -- Set initial state from saved settings
            local initialState = self.SETTINGS.productionEnabled[prod.id]
            if initialState == nil then
                initialState = true
                self.SETTINGS.productionEnabled[prod.id] = true
            end
            menuBinaryOption:setState(initialState and 1 or 2)

            -- Setup tooltip and label
            local toolTip = menuBinaryOption.elements[1]
            toolTip:setText(g_i18n:getText("production_tooltip") .. " " .. g_i18n:getText(prod.name))

            local setting = menuOptionBox.elements[2]
            setting:setText(g_i18n:getText(prod.name))

            -- Update focus IDs
            menuOptionBox.focusId = FocusManager:serveAutoFocusId()
            
            -- Add to controls list
            table.insert(settingsPage.controlsList, menuOptionBox)
            menuOptionBox:updateAbsolutePosition()
        end

        -- Force layout recalculation
        settingsPage.generalSettingsLayout:invalidateLayout()
    end
end


function FactoryProductionModifier:onMenuOptionChanged(state, id)
    print(string.format("onMenuOptionChanged called with state %s and id %s", tostring(state), tostring(id)))
    
    if id and self.SETTINGS.productionEnabled then
        local enabled = (state == 1)
        self.SETTINGS.productionEnabled[id] = enabled
        print(string.format("Setting %s to %s", id, tostring(enabled)))
        
        local saved = self:saveConfig()
        print(string.format("Save config result: %s", tostring(saved)))
        
        self:onSettingsChanged()
    else
        print("Invalid id or settings table not initialized")
    end
end

function FactoryProductionModifier:saveConfig()
    local userSettingsFile = Utils.getFilename("modSettings/FactoryProductionModifier.xml", getUserProfileAppPath())
    print(string.format("Saving config to: %s", userSettingsFile))
    
    local xmlFile = createXMLFile("FactoryProductionSettings", userSettingsFile, "factoryProduction")

    if xmlFile and xmlFile ~= 0 then
        setXMLFloat(xmlFile, "factoryProduction#multiplier", self.SETTINGS.multiplier)
        setXMLInt(xmlFile, "factoryProduction#selectedValue", self.SETTINGS.selectedValue)

        -- Save production states with debug logging
        for _, prod in ipairs(ProductionsIds) do
            local enabled = self.SETTINGS.productionEnabled[prod.id]
            if enabled ~= nil then
                local path = "factoryProduction.productions." .. prod.id .. "#enabled"
                setXMLBool(xmlFile, path, enabled)
                print(string.format("Saved %s = %s", path, tostring(enabled)))
            end
        end

        saveXMLFile(xmlFile)
        delete(xmlFile)
        print("Config file saved successfully")
        return true
    end
    
    print("Failed to create or save XML file")
    return false
end




local modDirectory = g_currentModDirectory or ""
local modName = g_currentModName or "unknown"
local modEnvironment = FactoryProductionModifier.new()
modEnvironment:loadConfig()

FSBaseMission.onStartMission =
    Utils.appendedFunction(
    FSBaseMission.onStartMission,
    function()
        g_currentMission:addUpdateable(modEnvironment)
    end
)

Mission00.loadMission00Finished =
    Utils.appendedFunction(
    Mission00.loadMission00Finished,
    function(mission)
        modEnvironment:onLoadGame(mission)
    end
)
-- Quando viene caricata una nuova partita
Mission00.delete = Utils.appendedFunction(Mission00.delete, function()
    modEnvironment:reset()
end)

-- Quando si esce dal gioco
FSBaseMission.delete = Utils.appendedFunction(FSBaseMission.delete, function()
    modEnvironment:reset()
end)

-- Quando si carica una nuova partita
Mission00.onStartMission = Utils.appendedFunction(Mission00.onStartMission, function()
    modEnvironment:reset()
end)
