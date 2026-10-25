# Planet visibility in Play mode

Applied on 2026-10-25 to Catch an Alien (place 92593286869246).

The original test verified positions and orbital motion, but did not verify actual gameplay rendering. Two issues were reproduced: the ARK spawn is indoors with the sky behind its roof, and distant planet geometry was culled at the current Automatic graphics setting despite being loaded and inside the camera frustum. Client preload reported Success, with no asset failures. Controlled textured sphere probes at near distances rendered while farther probes disappeared.

## Fix

- Moved the virtual system toward the far outdoor horizon, at centre `(-2400,1500,10000)`, with a 0.5-degree orbital plane. Larger display bodies and orbit spacing improve gameplay composition.
- Replaced `OrbitalMotion` with a cosmetic camera-relative renderer. Virtual positions still follow the configured circular orbits and axial rotations; scaled local copies draw 300 studs from the camera with equivalent apparent angles and a 1.35 presentation size multiplier.
- Runtime copies live in client-only `Workspace.RenderedSolarSystem`; they are anchored, non-colliding, non-touching and non-querying visual geometry. Original server preview parts remain anchored/collidable and are hidden locally. There is no per-frame server replication.
- Nearby geometry naturally occludes the copies. A low-frequency centre ray also hides a body if more distant architecture would otherwise appear behind its nearer visual copy. This uses whole-body hiding for distant occlusion rather than a pixel-accurate silhouette mask.
- Retained the former motion script disabled under `ServerStorage.OrbitalEnvironmentBackup.OrbitalMotion_BeforeGraphicsFix`.

## Actual gameplay verification

- Walked the native character from the ARK through the hub and onto the open Lunar deck, retaining 100 health.
- Captured actual Client gameplay images showing visible planets and the Sun, including a capture with no camera override.
- All 10 rendered bodies were present, using 13 local visual BaseParts with no anchoring/collision configuration issues. All 23 referenced content requests succeeded on the Client.
- Earth's render orientation changed about 4.11 degrees in two seconds. Earth–Moon virtual distance remained approximately 430 studs after the display-scale change.
- The runtime console was empty. Studio returned to Edit mode; temporary distance probes existed only in Play mode and were discarded.

The roof still blocks the sky inside the ARK. Planets are visible from open decks and change positions as they orbit. Save the place in Studio; the agent did not explicitly save or publish it.

Sources: `refit-18-gameplay-planet-visibility.luau` records the display-layout update; the updated `OrbitalMotion.client.luau` is installed in StarterPlayerScripts. Previous orbital report describes the initial implementation and is superseded by this fix for runtime rendering details.
