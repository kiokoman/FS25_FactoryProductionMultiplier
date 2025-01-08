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
    {id = "bathtubBoards", name = "production_bathtubBoards"},


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

function FactoryProductionModifier:updateProductionCycles(production)
    -- Verifica se la produzione è abilitata
    if not self:isProductionId(production.id) then
        return -- Se disabilitata, non applicare la moltiplicazione
    end

    if not production or not self.SETTINGS.originalValues[production.id] then
        return
    end

    local original = self.SETTINGS.originalValues[production.id]
    local multiplier = tonumber(self.SETTINGS.multiplier)

    if not multiplier then
        return
    end

    -- Usa i valori originali per il calcolo solo se la produzione è abilitata
    if original.cyclesPerMinute then
        production.cyclesPerMinute = original.cyclesPerMinute * multiplier
    end
    if original.cyclesPerHour then
        production.cyclesPerHour = original.cyclesPerHour * multiplier
    end
    if original.cyclesPerMonth then
        production.cyclesPerMonth = original.cyclesPerMonth * multiplier
    end
end

function FactoryProductionModifier:reset()
    self.SETTINGS.originalValues = {}
    self.isLoaded = false
end

function FactoryProductionModifier:load(mission)
    if self.isLoaded then
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

    local success, result =
        pcall(
        function()
            local count = 0
            for _, point in pairs(pcm.productionPoints) do
                if point and point.productions then
                    for _, prod in pairs(point.productions) do
                        if prod and prod.id and self:isProductionId(prod.id) then
                        if not self.SETTINGS.originalValues[prod.id] then
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

--function FactoryProductionModifier:isProductionId(prodId)
--    for _, prod in ipairs(ProductionsIds) do
--       if prod.id == prodId then
--            return true
--       end
--    end
--    return false
--end

function FactoryProductionModifier:update(dt)
    if not self.isLoaded then
        self.loadTimer = self.loadTimer + dt
        if self.loadTimer >= 200 then
            self:load(g_currentMission)
            g_currentMission:removeUpdateable(self)
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
            multiOption.texts = {
                "1x ",
                "2x ",
                "3x ",
                "4x ",
                "5x ",
                "6x ",
                "7x ",
                "8x ",
                "9x "
            }
            multiOption.values = {1, 2, 3, 4, 5, 6, 7, 8, 9}
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

            -- Imposta il callback
            menuBinaryOption:setCallback("onClickCallback", "onMenuOptionChanged")
            menuBinaryOption:setDisabled(false)
            updateFocusIds(menuOptionBox)

            -- Imposta il tooltip
            local toolTip = menuBinaryOption.elements[1]
            toolTip:setText(g_i18n:getText("production_tooltip") .. " " .. g_i18n:getText(prod.name))

            -- Imposta il testo della label
            local setting = menuOptionBox.elements[2]
            setting:setText(g_i18n:getText(prod.name))

            -- Imposta i testi e lo stato
            menuBinaryOption:setTexts({"Enabled", "Disabled"})

            -- Imposta lo stato iniziale
            local initialState = self.SETTINGS.productionEnabled[prod.id]
            if initialState == nil then
                initialState = true
                self.SETTINGS.productionEnabled[prod.id] = true
            end
            menuBinaryOption:setState(initialState and 1 or 2)

            -- Aggiorna i focus ID
            menuOptionBox.focusId = FocusManager:serveAutoFocusId()

            -- Aggiungi alla lista dei controlli
            table.insert(settingsPage.controlsList, menuOptionBox)
            menuOptionBox:updateAbsolutePosition()
            -- Forza il ricalcolo del layout
            settingsPage.generalSettingsLayout:invalidateLayout()
        end
    end
end

-- Aggiungi la funzione di callback
function FactoryProductionModifier:onMenuOptionChanged(state, id)
    if id and self.SETTINGS.productionEnabled then
        self.SETTINGS.productionEnabled[id] = (state == 1)
        self:saveConfig()
        self:onSettingsChanged()
    end
end

function FactoryProductionModifier:saveConfig()
    local userSettingsFile = Utils.getFilename("modSettings/FactoryProductionModifier.xml", getUserProfileAppPath())
    local xmlFile = createXMLFile("FactoryProductionSettings", userSettingsFile, "factoryProduction")

    if xmlFile and xmlFile ~= 0 then
        setXMLFloat(xmlFile, "factoryProduction#multiplier", self.SETTINGS.multiplier)
        setXMLInt(xmlFile, "factoryProduction#selectedValue", self.SETTINGS.selectedValue)

        -- Salva lo stato di ogni produzione
        for _, prod in ipairs(ProductionsIds) do
            local enabled = self.SETTINGS.productionEnabled[prod.id]
            if enabled ~= nil then
                setXMLBool(xmlFile, "factoryProduction.productions." .. prod.id .. "#enabled", enabled)
            end
        end

        saveXMLFile(xmlFile)
        delete(xmlFile)
        return true
    end
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
