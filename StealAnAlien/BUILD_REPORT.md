# Steal an Alien — world build report

The current scene has a later visual refit. See [VISUAL_REFIT_REPORT.md](VISUAL_REFIT_REPORT.md) for the latest appearance, counts, lighting and validation. This file records the earlier construction stages.

Completed in the connected Place1 Studio scene on 2026-10-24.

## Phases
- A: Audited Studio tools and the initial template; created the hierarchy. Moved the default Baseplate, SpawnLocation and original lighting into ServerStorage.StealAnAlien_TemplateBackup.
- B: Configured dark space lighting and a plain black backdrop without external asset IDs.
- C: Built the hub, eight plot footprints, six consecutive world floors, gates, supporting undersides and six connecting bridges.
- D: Built each world separately with themed materials, landmarks, smaller props and three static specimen sites.
- E: Finished eight personal plots with four empty habitats each, return pads, labs and nameplates. Added shared hub facilities and navigation.
- F: Created a static SpaceStealHUD with five labels and ResetOnSpawn=false.
- G: Reviewed aerial, spawn, personal-base, first-world, bridge-transition and mobile views. Adjusted specimen placement, surface lettering and readability; checked geometry again.

## Scene organisation
Workspace.SpaceWorld contains:
- SpawnHub
- PlayerBases: Plot_01 through Plot_08
- ProgressionRoute: Bridge_01 through Bridge_06
- Worlds: World_01_LunarOutpost, World_02_RustMoon, World_03_Xenoforest, World_04_CryoMoon, World_05_BasaltRift, World_06_VoidArchive
- CollectionProps
- HubFacilities
- Landmarks

StarterGui.SpaceStealHUD contains WorldBanner, Resources and Carrying panels.

## Verified counts and geometry
- 8 personal plots, 32 empty habitat bays, 8 return pads and 8 small plot labs.
- 6 world zones, 6 primary landmarks and 18 static alien specimen sites.
- 1 shared spawn, 6 bridges and 4 shared facility models.
- 1,587 physical parts after the spacecraft conversion, all Anchored=true and CanCollide=true.
- No authored runtime scripts in SpaceWorld or the HUD.
- GetPartsInPart reported no intersecting part pairs after final polish.
- Central 14-stud-wide traversal corridor has no decorative obstacles.
- Bridge walking surfaces and world floors meet at Y=2.
- Bridge Z endpoints: 100–155, 335–385, 565–615, 795–845, 1025–1075, 1255–1305.
- Shared spawn is centred at (0,2.5,-82), with its bottom at Y=2 and forward direction +Z.
- Final specimen locations vary across worlds; Rust Moon displays sit beside the assay office and conveyor.

## Lighting actually applied
- ClockTime: 0
- Brightness: 2
- Ambient: RGB(80,86,100)
- OutdoorAmbient: RGB(110,116,130)
- ExposureCompensation: 1
- EnvironmentDiffuseScale / EnvironmentSpecularScale: 0.35 / 0.35
- GlobalShadows: true
- Gravity: 196.2
- FogColor: RGB(8,12,20); FogStart: 2800; FogEnd: 6000
- Bloom: disabled
- ColorCorrection: brightness 0, contrast 0.04, saturation -0.08, white tint

Ambient fill and exposure were raised from the requested starting values after camera review to keep surfaces readable against the dark backdrop. Small practical lamps light the hub and specimen areas.

## UI and live checks
- Desktop viewport reviewed.
- iPhone 17 Pro: landscape and portrait reviewed; portrait viewport 401×778.
- Samsung Galaxy A06: compact landscape reviewed at viewport 705×338.
- All five labels returned TextFits=true during the compact-phone live test.
- Live character spawned on the shared arrival pad.
- The console output was empty during the live check.
- Studio returned to Edit mode, landscape orientation and default viewport.
- StarterGui.ScreenOrientation=Sensor; HUD uses CoreUISafeInsets with ClipToDeviceSafeArea=true.

## Limits and remaining review
- ForgeGUI was not exposed by the connected tools. The HUD was built through supported Roblox Studio APIs.
- No suitable approved space skybox existed in the fresh template. The backdrop is plain black; no asset IDs or fake star fields were invented.
- Aliens, habitats, facilities and all HUD values are static placeholders.
- No ownership, stealing, carrying, economy, progression unlocking, saving, AI or teleportation gameplay was implemented.
- No obvious geometry intersections or HUD text clipping remained in the reviewed views. Long-session, multiplayer and performance profiling were outside this static build pass.
- The build is in the open Studio scene. A native .rbxl save/export was not performed by the available MCP tools.

## Authoring files
The later spacecraft-conversion.luau authoring command converts the hub and six world platforms into a connected fleet. Set INDEX=0 for the carrier hub, then execute separate batches with INDEX=1 through 6 for the worlds. Original underside pieces are retained in ServerStorage.SpacecraftConversionBackup. Each destination now has a Spacecraft model containing ArmoredHull, DeckBulwarks, Propulsion, CommandIsland, DockingCollars and VesselEquipment.

The fleet consists of the ARK colony carrier, SELENE research vessel, FERRUM mining barge, VERDANT bio-ark, BOREAL cryogenic vessel, CINDER refinery vessel and VESPER archive vessel. Features include beveled hulls, split prows, paired engine nacelles, command islands, docking collars and biome-specific equipment. The original floor slabs now serve as the ships' upper decks. Existing plots, specimens, HUD and bridge alignments are preserved.

Post-conversion validation found no intersecting part pairs, no obstacles in the central traversal corridor, and no runtime scripts. The spacecraft are static environments; no flight systems were added.

The phase-*.luau files in this directory are authoring commands, not in-game runtime scripts. They document the construction sequence A through G. Apply phase-g-polish.luau after the earlier builders to reproduce the final specimen positions and ground-label alignment. Do not run construction files again on the completed scene: several deliberately assert that their destination is empty.
