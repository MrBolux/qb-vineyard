Config.Fermentation = {
    vineyard = {
        {
            box = {
                coords = vector3(-1878.56, 2060.99, 135.92),
                length = 1.5,
                width = 1,
                heading = 156.43,
                minZ = 134.92,
                maxZ = 136.50,
            },
            production = {}
        }
    }
}

Config.Recipe = {
    redWine = {
        processTime = 10, -- sec per product
        requiredItem = {
            bottle = 1,
            redgrapejuice = 2
        }
    }
}

-- Config.stash = {
--     vineyard = {
--         {
--             coords = vector3(-1869.66, 2066.12, 140.98),
--             length = 1,
--             width = 1.5,
--             heading = 90,
--             minZ = 139.98,
--             maxZ = 141.98,
--         },
--     },
-- }