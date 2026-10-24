# Alien display species pass

Completed in Studio place 126862452789872 on 24 October 2026.

Replaced the 18 repeated display figures with six new textured mesh species. Each world has three specimens with separate finish tints and scale variations. These are six model archetypes with 18 visual variants, rather than 18 independently modeled species.

| World | Species appearance | Generated source asset |
| --- | --- | --- |
| Lunar Outpost | Large-eyed silver-grey lunar alien, mottled skin and compact limbs | 72720222779551 |
| Rust Moon | Four-legged armored desert beetle, segmented copper-red chitin | 122398938264057 |
| Xenoforest | Botanical bark creature, leaf crown, moss and seedpods | 95537377450724 |
| Cryo Moon | Round white snow creature, pale blue frost markings and paws | 135918364752754 |
| Basalt Rift | Porous stone guardian, earthy charcoal finish and amber eyes | 118423432153041 |
| Void Archive | Finned, tentacled creature with indigo/violet skin and star-like freckles | 86916283373725 |

The original specimen names were retained: Lunar Scout / Dust Drifter / Moonling; Rust Burrower / Ore Sifter / Copper Crawler; Canopy Wanderer / Moss Strider / Seed Keeper; Frostling / Ice Grazer / Snow Sentinel; Ash Walker / Basalt Keeper / Rift Grazer; Archive Witness / Echo Keeper / Void Scribe.

## Storage and authoring

- Six reusable source models: `ServerStorage.SpaceArtSourceAssets.AlienSpecies`.
- All 18 original figures: `ServerStorage.AlienSpeciesBackup`, with their original parent paths recorded as attributes.
- Installed figures retain the `SpecimenFigure` name under their existing `Workspace.SpaceWorld.CollectionProps` display sites.
- `SpeciesFamily`, `SpecimenType`, and `FinishVariant` attributes identify the new visuals.
- Repeatable editor-only commands: `refit-10-alien-species.luau`; prefix its source with `local ALIEN_FAMILY="Lunar"` (or Rust, Xeno, Cryo, Basalt, Void).
- Six new textured assets were generated through Roblox Studio's native mesh-generation tool. No paid ForgeGUI calls were made.

## Verification

- All 18 displays contain the expected family, three per world.
- All 52 distinct mesh/texture content references returned `AssetFetchStatus.Success`.
- 78 new displayed MeshParts; final SpaceWorld physical part count is 2,311, reduced from 2,665 by replacing the older multi-part figures.
- Every new figure sits at its pedestal's top (Y=3.4 within 0.001 stud) and fits inside the pedestal footprint.
- Physical overlap queries found no intersections with external signs, terminals or environment parts. Internal joins between a creature's mesh segments and contact with its own pedestal were excluded.
- All 2,311 SpaceWorld parts are anchored and collidable. SpaceWorld contains no runtime scripts.
- One installed specimen from each family was checked in rendered screenshots; basalt and void finishes were subdued after inspection.
- No generated staging models remain in Workspace. Floors, buildings, UI and gameplay behavior were unchanged.

Changes are applied in Studio. The agent did not explicitly save or publish the place after this pass.
