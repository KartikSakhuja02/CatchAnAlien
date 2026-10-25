# ARK spawn and interior refit

Applied in Roblox Studio on 2026-10-25 to **Catch an Alien**, place 92593286869246. Changes are in the live Edit DataModel; save the place in Studio to persist them.

## Result

The previously detailed docked spaceship is now `Workspace.SpaceWorld.SpawnHub.ARKShip`. It was enlarged 1.5 times and moved to fit a walkable crew cabin and cockpit. Wings, engines, and exterior equipment remain. The former arrival apron, portal, signage, ground-service setup, and carrier aft arrival platform were removed from Workspace and retained in backup.

`SpawnHub.SharedSpawn` is the only active SpawnLocation. It sits flush in the cabin floor at `(0, 7.35, -179)`, with a top surface at Y 7.4, facing the hub exit. It uses native spawning, with no new runtime scripts.

The ship contains four crew chairs, two pilot chairs, two navigation consoles, cargo storage, a suit locker, a medical cabinet, overhead lighting, wall panels, and a raised cockpit reached by three steps. A lit rear companionway leads to a railed gangway connecting to the existing hub.

The imported primary body was non-manifold and could not be boolean-cut into a hollow interior. It was backed up and replaced with a native hollow pressure shell, glazed cockpit, and deck panels. Obstructing legacy cabin geometry, seating, landing gear, and door pieces were archived. Cockpit and aft bulkheads frame clear central openings.

## Verification

- Final ARK contains 1,080 BaseParts; all are anchored and collidable. No runtime scripts were added to it.
- The old `SpawnHub.ArrivalDock` no longer exists in Workspace.
- Playtest confirmed natural spawn inside the ARK at approximately `(0, 10.398, -179)` with 100 health.
- Walked from spawn to cockpit, back through cabin and companionway, across gangway, and onto hub. All targets reached within 0.87 studs horizontally, with 100 health and grounded floor detection.
- Earlier return-route test also confirmed walking from hub back into ship and cockpit.
- Visually inspected exterior, main cabin, cockpit entrance, and rear exit after cleanup.
- Studio returned to Edit mode after testing.

## Backups and source notes

`ServerStorage.ARKSpawnConversionBackup` includes the original ArrivalDock clone, original spawn, retired arrival setup, carrier aft deck/hull, and `OldInteriorAndLandingGear` containing retired original body and obstructions. Source assets remain in `ServerStorage.SpaceArtSourceAssets`.

`refit-14-ark-interior.luau` and `refit-15-ark-shell.luau` record the authored cabin and replacement shell. They are editor construction scripts, not runtime game scripts, and guard against reapplying completed phases. Initial conversion and selective legacy-geometry retirement were performed through editor commands; these files alone are not a full reconstruction of the conversion.

The pre-existing HUD and gameplay scope were left in place. No publishing or explicit place save was performed by the agent.
