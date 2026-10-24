# ARK arrival deck and docked shuttle

Built in Studio place 126862452789872 on 24 October 2026. The existing ARK arrival area at the rear of the hub was converted into Arrival Bay 01.

## Result

- Added an 82 by 74 stud steel docking apron, spanning Z=-196 to -122, with its walking surface at Y=2.
- Joined the apron cleanly to the existing aft arrival deck at Z=-122. Shared spawn remains at (0, 2.5, -82).
- Replaced the closed arrival bulkhead with a 24 stud wide portal, structural shoulders, and ARK arrival signage.
- Installed a detailed 48 stud long docked shuttle with authored cockpit, hull, propulsion, and landing gear geometry. Hull finishes were adjusted to graphite, blue-grey steel, muted teal and ochre; 42 larger armor panels were highlighted to improve readability.
- Added a steel boarding ramp with rails, a threshold and an authored sealed airlock. The ramp is walkable; the airlock is static.
- Added landing guide markings, guardrails, four mounted floodlights, cargo containers, an arrival terminal and a supported ground-services sign.

## Sources and files

- Shuttle: [Sci Fi Spaceship by Fallowick](https://create.roblox.com/store/asset/125245019220487), a free Creator Store model. The source contains 1,178 physical parts and no runtime scripts. Source retained at `ServerStorage.SpaceArtSourceAssets.ArrivalShuttleSource`.
- Airlock, cargo and terminal: existing Roblox Beyond the Dark architecture/prop sources already in this place.
- Original bulkhead, identity panel and two old lockers: `ServerStorage.ArrivalBayBackup` (four objects).
- New assembly: `Workspace.SpaceWorld.SpawnHub.ArrivalDock`.
- Authoring commands: `refit-11-arrival-bay.luau` (run phases 1, 2, 3 in order), then `refit-12-arrival-polish.luau`.

An unused alternate shuttle source and all temporary review geometry/lights were removed. No new AI mesh generation or paid ForgeGUI generation was used for this pass.

## Verification

- All 445 referenced content loads completed with Success.
- Arrival bay contains 1,297 physical parts; all are anchored and collidable. The full SpaceWorld now contains 3,604 physical parts.
- No runtime scripts exist in the arrival bay; imported seats are disabled.
- No intersections between separate assemblies were found after polishing. Internal prefab construction joints and welded railing/light assemblies were excluded from that check.
- Landing markings use Roblox's minimum 0.05 stud thickness and sit above the floor. The ramp foot was raised to avoid embedding its underside in the deck.
- Route floor samples from Z=-122 to -73 found no gaps. Rays through the entry corridor at three lateral positions and three walking heights found no obstructions.
- Live playtest: character walked from the arrival approach up the boarding ramp, ending at approximately (0, 9.43, -134.22), alive and standing on Metal. Studio was returned to Edit mode afterwards.
- Original floor materials, aliens, main hub architecture and HUD were preserved.

The agent applied the changes in Studio but did not explicitly save or publish the place after this pass.
