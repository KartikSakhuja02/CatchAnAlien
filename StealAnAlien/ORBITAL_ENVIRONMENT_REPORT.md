# Environment colour and animated planets

Applied to **Catch an Alien** (place 92593286869246) on 2026-10-25. Save the place in Studio to persist the live edits.

## Visual changes

- Recoloured 415 existing parts while preserving geometry, collision, and authored floor MaterialVariants.
- Hub: navy structural hull, teal engine bands and trim, blue-green concourse arches, and a neutral-warm lighting balance.
- World accents: lunar blue, rust amber, forest green, cryo cyan, basalt orange, and archive violet. Ground tints reinforce each world's existing textured material.
- Added `Workspace.SpaceWorld.Landmarks.SolarSystem`: Sun, Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune, and Earth's Moon. Earth includes blue oceans and cloud cover; Saturn has textured rings. Meshes use Precise rendering to preserve distant silhouettes.
- Replaced the previous oversized static moon with the orbiting Moon; its original model is retained in `ServerStorage.OrbitalEnvironmentBackup`.

## Motion

`StarterPlayer.StarterPlayerScripts.OrbitalMotion` performs decorative animation locally at up to 30 updates per second. Positions derive from the shared server clock; there is no per-frame server replication. Persistent streaming on each body keeps the distant planets available to clients.

The eight planets follow circular orbits around the Sun and spin on tilted axes. Inner orbits are faster than outer ones; Venus and Uranus spin in reverse. The Moon orbits Earth at 215 studs. The Sun stays in place and rotates.

Distances, sizes, and periods are compressed for visibility and game presentation; this is not a physically scaled astronomy simulation. Orbital periods range from 180 to 2,700 seconds. Final planetary spin periods are 2.5 times the initial construction values; Earth's is 175 seconds and Jupiter's is 100 seconds.

Editable attributes are on `SolarSystem` (`TimeScale`, `AnimationEnabled`, `AnimationEpoch`, `OrbitCenter`, `OrbitInclination`) and each body (`OrbitRadius`, `OrbitPeriod`, `SpinPeriod`, `PhaseDegrees`, `AxialTilt`). Animation runs in Play mode; Edit mode shows the composed preview poses.

## Validation

- Ten bodies use 13 BaseParts. Every new BasePart is anchored and collidable; planet geometry is positioned well above the playable decks. No imported scripts were carried into the scene.
- All 23 referenced asset-content requests succeeded during preload.
- Playtest confirmed all eight planets changed position and orientation, Sun rotation with zero positional drift, and Moon movement with an Earth–Moon distance of approximately 215 studs.
- MotionReady was true and the runtime console was empty. Native ARK spawning remained at `(0, 10.398, -179)` with 100 health.
- Visually checked station palette, Earth surface/clouds, Jupiter, Saturn's rings, and distant silhouettes; then slowed the spin defaults and retained the tested orbital speeds.
- Returned Studio to Edit mode. No place save or publish was performed by the agent.

## Files and assets

- `refit-16-environment-colour.luau`: editor colour and lighting pass.
- `refit-17-orbital-backdrop.luau`: editor construction in three verified batches.
- `OrbitalMotion.client.luau`: source installed in StarterPlayerScripts.
- Planet art: free Creator Store **Solar System Models**, asset **16811836464**, by **roblox_user_1559819283**, retained under `ServerStorage.SpaceArtSourceAssets.PlanetArtReference`. Imported scripts were removed before use. Saturn ring texture is asset **423084630**, discovered in the inspected planet references. The Moon uses the project's existing `LunarPlanetSource`.
- Original affected part colours are stored as `OrbitalOriginalColor` attributes. Original lighting properties and cloned effects are in `ServerStorage.OrbitalEnvironmentBackup`.
