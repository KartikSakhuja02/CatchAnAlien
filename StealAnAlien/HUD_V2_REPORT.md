# HUD v2 — delivery and verification

Installed in StarterGui.SpaceStealHUD in Studio Place1 on 2026-10-24.

## Implemented
- Graphite instrument panels with restrained gradients, fine borders and soft shadows.
- Lunar navigation emblem, current-world title, six-stage route indicator and next-world label.
- Resource counters with native credit-chip and alien-head icons.
- Separate carrying panel with empty specimen-slot illustration.
- Responsive widths, text constraints, ResetOnSpawn=false, and Roblox safe-area clipping.
- Static labels only; no runtime scripts or functional buttons.
- Previous HUD preserved under ServerStorage.StealAnAlien_HUDBackups.
- Authoring source: hud-v2.luau. This replaces the earlier phase-f-hud.luau design when applied after the initial build.

## QA
Desktop view inspected. iPhone 17 Pro portrait (401×778) and Samsung Galaxy A06 landscape (705×338) inspected.
All 11 labels fit after final text-scaling changes.
No top-level panel overlaps in portrait.
Live compact-phone test verified all labels, text scaling and ResetOnSpawn=false.
Studio returned to Edit mode and the default viewport.
No image asset IDs were invented; no game-world geometry changed.

## ForgeGUI outcome and limitation
A single lunar emblem generation succeeded:
- Job: 06a647fb-9ef0-4518-8237-57a4d8f8cc07
- Request: steal-alien-hud-v2-lunar-20261024-01
- Artifact: mcp-artifact:06a647fb-9ef0-4518-8237-57a4d8f8cc07:0
- Preview: https://azyjlkhpdgafuobyxoax.supabase.co/storage/v1/object/public/asset-images/564490be-86b9-4633-aed4-1bc64fb5b1cc/mcp/06a647fb-9ef0-4518-8237-57a4d8f8cc07-0.png

Studio upload_image rejected that host with "Image Url is not trusted". ForgeGUI publication_connections_list returned no connections. The generated artwork was therefore NOT inserted; the installed interface uses native Roblox vector-style UI shapes.

The second generation request, for an alien icon, was refused with insufficient_credits (1600 required, 994 available). No further paid requests were made. If credits are replenished, a future request must use a NEW request_id. This redesign does not require that generation: a native alien icon is already installed.
