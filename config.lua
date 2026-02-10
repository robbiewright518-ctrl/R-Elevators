Config = {}

Config.FadeOut = 350
Config.FadeIn  = 350

Config.Elevators = {
    {
        id = "gurkhin",
        label = "Gurkhin Elevator",
        floors = {
            {
                label = "Lobby",
                description = "Main entrance",
                teleport = vec4(132.43, -735.96, 46.09, 302.91),
                interact = vec3(133.02, -735.74, 46.09),
                distance = 3.0
            },
            {
                label = "Top",
                description = "Top Floor",
                teleport = vec4(141.36, -747.09, 219.18, 14.99),
                interact = vec3(141.36, -747.09, 219.18),
                distance = 3.0
            }
        }
    },

    {
        id = "shard",
        label = "Shard Elevator",
        floors = {
            {
                label = "Lobby",
                description = "Main entrance",
                teleport = vec4(452.77, -618.78, 41.93, 82.02),
                interact = vec3(452.77, -618.78, 41.93),
                distance = 3.0
            },
            {
                label = "Top",
                description = "Top Floor",
                teleport = vec4(461.81, -613.11, 270.3, 261.51),
                interact = vec3(461.81, -613.11, 270.3),
                distance = 3.0
            }
        }
    },

    {
        id = "idk",
        label = "idk Elevator",
        floors = {
            {
                label = "Ground",
                description = "Ground level",
                teleport = vec4(133.09, -644.02, 47.93, 277.67),
                interact = vec3(133.09, -644.02, 47.93),
                distance = 2.0
            },
            {
                label = "Top",
                description = "Top access",
                teleport = vec4(137.4, -632.48, 193.02, 340.03),
                interact = vec3(137.4, -632.48, 193.02),
                distance = 2.0
            }
        }
    }
}
