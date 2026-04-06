# Slime Game

## Core

The game is built on the tension between **Persistence** (what you own) and
**Risk** (what you've found).

- **Primary Goal**: Levels are created using procedurally stitched "tiles"
  (premade rooms that snap together). Each run has a primary goal: find the
  Vacuum Vent (Exit).

- **Optional Goals**: Every level contains two optional objectives:
  Extermination (kill a specific % of slimes) and Scavenging (find all hidden
  chests). Completing these grants massive point bonuses.

- **Timer**: A constant countdown. Reaching the exit before it hits zero is the
  only way to "Win" the level. If the timer hits zero, the Hub turbines lose
  pressure, the player is considered "Lost" in the veins, and the backpack is
  wiped.

- **Backpack**: A temporary inventory for loot found during a run.
    - **Success**: Reaching the exit moves all loot to the Permanent Vault.

    - **Failure**: Death or Timer expiration destroys everything currently in
      the backpack.

- **EZ-Pass**: Rare, one-time-use digital keys required for the Safety Hatch.
  Earned via Bounties, rare chests, or high-cost point purchases.

- **Recal Protocol (Keep Inventory)**: A world-creation toggle.
    - **Hardcore**: Player loses everything on death and must restart.

    - **Standard (Softcore)**: Only the pilot is teleported on death; all gear
      and backpack items are lost to the pressure veins.

    - **Persistent (Casual)**: A "Quantum Tether" ensures the pilot and all
      equipped/held items are snapped back to the Hub upon death.

---

## Progression

Traditional XP is replaced with a physical Point-Buy Hub system.

- **Earning Points**: Points are volatile. Gained via kills, looting, and
  objectives. If you die, carried points are reset to zero.

- **Banking**: Players must return to the Hub to "Bank" points into the Hub's
  upgrade systems.

- **Hub Stations**: Physical interactable stations with multi-tier upgrade paths
  (Level 1–5+).

---

## Combat

Guns and other weapons are assembled from individual parts and enhanced by
biological Slime Cores.

- **Weapon Parts**: Components include Frames, Barrels, Magazines, Sights, and
  Muzzles.

- **Chest Tiers**: Chest size corresponds to part size. Small (Sights/Muzzles),
  Medium (Barrels/Mags), Large (Frames/Stocks).

- **Scrap & Blueprints**: Dismantling a part gives "Scrap" (currency for
  crafting). Dismantling a part multiple times eventually grants its
  "Blueprint," allowing the player to craft that specific part anytime using
  Scrap.

- **Slime Cores**: Cores are not just slotted; they are permanently fused into a
  part at the Socketing Station.
    - **Infused Stats**: The part gains the core’s elemental "Flavor" and stat
      buffs, becoming a new unique item (e.g., "Volt-Heavy Barrel").
    - **3-Color Visual System**: Parts feature Primary (Camo/Shell), Secondary
      (Slime/Veins), and Tertiary (Accents) color slots. The Secondary color is
      overridden by the Infused Slime’s glow (e.g., Neon Yellow for Volt).

- **Part Mastery**: Successful extractions with specific parts grant permanent
  stat buffs to those parts.

---

## The "Slimiary"

Each slime type provides a predictable core effect, allowing players to "farm"
specific "biomes" for their build.

- **Yellow (Volt)**: High speed. Drops cores for Fire Rate, Movement Speed, and
  Reload Speed.

- **Blue (Bulwark)**: High health/armor. Drops cores for Magazine Size, Damage
  Resistance, and Knockback.

- **Red (Magma)**: Aggressive/Explosive. Drops cores for AOE Radius and
  Explosive Damage.

- **Green (Caustic)**: Leaves trails of acid. Drops cores for Damage over Time
  (DoT) and Armor Stripping.

- **Purple (Phase)**: Teleports or blinks. Drops cores for Piercing and Bullet
  Velocity.

---

## Endless Mode

The primary loop. Groups of 5 levels ending in a small Boss Arena. Difficulty
and loot quality scale infinitely.

### Hub

A pressurized bunker connected to the planet via repurposed pneumatic "Transit
Veins."

#### Layout & Infrastructure

**Floor 1: Atrium (Command & Prep)**

- **Transit Pod (North Airlock)**: A reinforced glass and steel capsule. When a
  run begins, the pod is pressurized and sucked UP into the planet's ceiling at
  high velocity.

- **Jump-Start Terminal**: Located next to the Pod. Allows players to
  "Overclock" the Hub's turbines to bypass shallow Transit Veins, launching them
  directly to deeper relay stations (e.g., Floor 10, 20, 50).

- **Main Lift (Central)**: A heavy industrial elevator providing vertical access
  between the Hub’s internal floors (Atrium, Forge, Bio-Lab).

- **Holo-Globe Command (East)**: A tactical projection showing the current
  Endless Floor progress, biome modifiers, and active Bounties.

- **Living Quarters (West)**: A personal space for cosmetic customization (Skin
  Locker) and a physical Trophy Shelf for boss-kill mementos.

**Floor 2: Forge (Weapon Fabrication)**

- **Blueprint Wall**: A glass-encased gallery of holographic wireframes. As
  players unlock Blueprints, these transition into solid, physical weapon parts.

- **Dismantle Bench**: The station used for breaking down high-tier parts into
  Scrap and Blueprints.

- **Socketing Station**: A high-precision workbench used to "inject" biological
  Slime Cores into weapon parts.

- **Loadout Terminal**: A physical UI station to save, name, and quickly swap
  complex weapon configurations.

- **Provisioner (Store)**: Located in the West Wing. A shop where players spend
  banked Points on consumables (Grenades, Shields, Med-Stims), EZ-Passes, and
  permanent utility upgrades like the Slime Core Satchel (a dedicated 1×1 grid
  for cores).

- **Standard Issue Terminal**: A fallback station that "prints" basic, zero-mod
  starter weapon parts for free, ensuring players can always start a new run if
  they lose their gear in Standard Mode.

**Floor 3: Bio-Lab (Core Management)**

- **The Central Vats**: Five massive glass cylinders (Volt, Bulwark, Magma,
  Caustic, Phase). These act as a **Resource Reservoir**, filling with raw
  "Liquid Essence" harvested from slimes during successful runs.

- **Core-Printer (Pity System)**: A distillation terminal that allows players to
  "burn" stored liquid essence to craft guaranteed Slime Cores.
    - **Scaling Pity**: Spending more liquid in a single "print" raises the
      minimum rarity of the resulting core (e.g., 500 units for a Random Core,
      5000 units for a Guaranteed Legendary).

- **Fusion Chamber**: A reinforced, high-energy centrifuge used to combine three
  low-tier cores into a single higher-tier version.

- **The Slimiary**: An interactive encyclopedia with 3D rotations of all
  encountered slimes and their predictable drop tables.

**Sub-Basement: Standardized Range (Tunnel)**

- **Integrated Shooting Range**: A long, reinforced tunnel for testing weapon
  builds in a zero-risk environment.

- **Holographic Dummy Spawner**: Allows players to spawn specific slime types to
  test elemental damage effectiveness and Armor Stripping.

- **Ballistics Display:**: Real-time floating UI showing DPS, recoil patterns,
  and elemental proc uptime.

- **Rent-A-Weapon Station**: Create and "rent" a temporary weapon, fully
  customized to your liking, to use at the range.

#### Mechanics

- **Pneumatic Extraction**: The "Exit" of every level is a roaring **Vacuum
  Vent**. Jumping into this vent sucks the player and their loot back to the
  Hub.

- **Essence Harvesting**: Every slime killed is automatically harvested for raw
  liquid essence via a vacuum attachment on the player’s weapon.

- **Loot Pipe**: During the return trip (loading screen), the player can see
  their backpack items flying through parallel transparent tubes alongside them.

- **Banking & Loss**:
    - **Risk**: In Standard Mode, all items in the Backpack and currently
      equipped Weapon Slots are lost upon death or Pressure Failure (Timer
      Zero).
    - **Safe Zone**: Carried Points and Liquid Essence are only secured into the
      Hub’s permanent systems once the player interacts with the Central Lift
      console after a successful run.

- **Visual Scaling**: As the player invests points into Hub Upgrades, the base
  visually evolves from a "cluttered bunker" into a "high-tech research
  facility" with better lighting, cleaner textures, and more robotic helpers.

- **Upgradable Rig**: Players must purchase upgrades from the Provisioner to
  unlock the Secondary Back-Harness and Tertiary Side-Holster weapon slots, as
  well as expanded Backpack grid tiles.

### Levels

Every procedural level is connected by the planetary pneumatic network.

#### Airbox (Entrance & Exit)

Every level starts in a small, reinforced "Safe Zone" before the main combat
area.

- **Transit Pod (Retreat)**: Allows immediate return to the Hub with the current
  backpack.

- **Safety Hatch (insurance)**: A port next to the Pod. Requires an EZ-Pass.
  Allows the player to "deposit" specific items directly into the Vault before
  opening the blast door.

- **Blast Door (Commit)**: Opening this door starts the Level Timer and begins
  the mission.

- **In-Field Management**: Players can swap parts between weapons in their
  backpack while in the Airbox, but they cannot perform **Infusions** or
  **Dismantling**. Those actions strictly require the industrial machinery of
  the Hub's Forge.

#### Surface & Junctions

- **Surface Tiles**: Procedural areas contain an entrance and an exit.

- **Junction Boss Arenas**: Every 5th level is a fortified structure that must
  be cleared to restore transit pressure for the next 5 floors.

---

## Normal Mode

A curated, open-map experience with specific story beats (to be developed
post-core polish).

---

## End Game

Avoiding the "Prestige" reset loop in favor of horizontal growth.

- **Relics**: Unique, game-changing parts (e.g., Ricocheting Barrels) found only
  in deep Endless levels (Floor 100+).

- **Point Infusion**: A permanent point sink. Invest millions of points into a
  "Biome Infuser" to permanently increase the difficulty and loot rarity of that
  specific world type.

- **Hub Completion**: Turning the solitary bunker into a maxed-out base with
  trophy rooms and holographic displays of boss kills.

---

## Future Expansion

- **Multiplayer Hub**: The Hub becomes a multiplayer space where players can see
  each other between runs.

- **Player Trading**: A player-to-player economy for rare Blueprints and
  high-tier Slime Cores.

- **Co-op Extraction**: Tactical squad-based gameplay in the Endless loop.

---

## Notes
