# ARK shuttle equipment and service dressing

Completed in Studio place 126862452789872 on 24 October 2026.

The shuttle and surrounding arrival deck were too sparse. This pass adds recognizable service equipment to its hull and working areas around the parked craft.

## Added

- 13 ship-mounted modules: paired life-support fan units, paired engine cooling grilles, paired insulated coolant lines, paired external supply cases, a dorsal service hatch, communications array, forward sensor radome and two small navigation lamps.
- Nine ground-service prop assemblies: two cargo pallets, two systems crates, two tool cases, a canister recharge rack, ground power cabinet and first-aid equipment.
- Larger metal hull surfaces use the existing brushed-steel PBR material.
- Roof equipment uses individual mounting plates and support feet. Locations and heights were measured against the original hull with raycasts; denser samples and foot-corner samples eliminated intersections on curved surfaces.

Assets are reused from the existing Roblox Beyond the Dark source library. No new AI asset generation, uploads or paid ForgeGUI calls were needed.

## Verification

- 106 physical parts added; all anchored and collidable.
- Zero runtime scripts added.
- Zero intersections between separate new assemblies and the surrounding ship/deck. Internal prefab joins were excluded.
- All 20 new content loads completed with Success.
- Approach clearance rays found no new obstructions to the boarding route.
- Hull systems and the full docking bay were inspected in rendered screenshots.
- Arrival bay now contains 1,403 physical parts; full SpaceWorld count is 3,710.

New geometry is grouped under `Workspace.SpaceWorld.SpawnHub.ArrivalDock.ShuttleExterior` and `ShuttleGroundServices`. The original shuttle's geometry, boarding ramp, spawn position and UI remain unchanged.

Repeatable editor commands are in `refit-13-shuttle-equipment.luau`, run with `local DETAIL_PHASE=1`, then `local DETAIL_PHASE=2`. This is an authoring file, not a runtime Script.

The changes are applied in Studio. The agent did not explicitly save or publish the place after this pass.
