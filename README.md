# R-Elevators

A simple, standalone elevator system for FiveM.

This resource uses **R-Lib** for:

- TextUI prompt (with floor marker circle)
- Context menu for floor selection

## Requirements

- `R-Lib` (must be started before `R-Elevators`)

## Installation

1. Drop `R-Elevators` into your server `resources` folder.
2. Ensure `R-Lib` is installed.
3. Add to `server.cfg`:

```cfg
ensure R-Lib
ensure R-Elevators
```

## Configuration

Edit `config.lua`.

### Fade timings

- `Config.FadeOut`
- `Config.FadeIn`

These are milliseconds used during teleport.

### Adding / Editing elevators

All elevators are defined in:

- `Config.Elevators`

Structure:

- `id` (string, unique)
- `label` (string, shown in TextUI and menu title)
- `floors` (array)

Each floor:

- `label` (string, menu option title)
- `description` (string, menu option description)
- `teleport` (`vec4(x, y, z, heading)`)
- `interact` (`vec3(x, y, z)`)
- `distance` (number, meters; interaction range)

Example:

```lua
Config.Elevators = {
    {
        id = "my_elevator",
        label = "Office Elevator",
        floors = {
            {
                label = "Lobby",
                description = "Main entrance",
                teleport = vec4(445.58, -652.50, 34.46, 155.64),
                interact = vec3(445.83, -651.79, 34.46),
                distance = 3.0
            },
            {
                label = "Roof",
                description = "Roof access",
                teleport = vec4(445.99, -633.12, 74.46, 348.88),
                interact = vec3(445.99, -633.12, 34.46),
                distance = 3.0
            }
        }
    }
}
```

## R-Lib UI Notes

- The TextUI prompt position is set to `right` in `client.lua`.
- The floor circle marker color/size/visibility is controlled by **R-Lib** config:

- `R-Lib/config.lua` -> `Config.TextUI.marker`
- `R-Lib/config.lua` -> `Config.TextUI.theme.accent`

## Support

- Check your `F8` client console for errors.
- Make sure `R-Lib` starts before `R-Elevators`.
