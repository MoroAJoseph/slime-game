# Slime Game

insert table of contents here

## Table of Contents

- [Core Concept & Pillars](#core-concept--pillars)
- [Narrative & World-Building](#narrative--world-building)
- [The Hub](#the-hub)
- [Gameplay Modes](#gameplay-modes)
- [Combat & Customization](#combat--customization)
- [Economy & Resources](#economy--resources)
- [Level Design & Biomes](#level-design--biomes)
- [Objectives & Grading](#objectives--grading)
- [Endgame & Explanation](#endgame--explanation)
- [Future Roadmap](#future-roadmap)

## Core Concept & Pillars

### Logline

High-octane extraction shooter. Reconstruct on collapsing planet Aura-5, harvest
biological power from Slime, build modular weapons, and escape via Ark before
planetary collapse.

### Design Pillars

- **Upgrades, people, upgrades**: Every reward must give mechanical enhancement,
  crafting material, or Hub upgrade. No useless items. Cosmetics only for
  prestige.

- **Purpose-Driven Arsenal**: Every weapon part solves a specific environmental
  or tactical problem.

- **Risk-Managed Persistence**: Gamble between safe extraction and pushing
  deeper for bigger rewards. Know when to Sync versus chase multipliers.

---

## Narrative & World-Building

### Setting

Aura-5 was a corporate mining world of pneumatic Transit Veins and turbines.
After the Resonance Breach, industrial lubricant (Slime) fused with power Cores,
turning the planet into a living, aggressive organism that slowly consumes
everything.

### Conflict

You are the Prism Lab Caretaker — a human in cryostasis. You operate via printed
Siphon Pilot chassis (stable carbon-material hybrid). The planet wants to digest
you. You harvest Slime Cores to power hardware while the living Slime tries to
purge intruders.

### Key Lore Elements

- **The Neural Lattice (The Pilot)**: Printed chassis from stable lab material.
  Consciousness uploaded from your cryo body each time. Destruction yanks
  consciousness back to Hub via radio; chassis and gear left behind.

- **The Outliner**: AI running Prism Lab. Prints bodies, defends Hub, mentors
  via limited radio.

- **Planetary Purge**: Printed chassis resists normal damage but gets crushed by
  full planetary purge waves (internals cannot handle the process). Gear left at
  crash site is consumed if not recovered in time.

- **Biome Bosses**: The researchers attempted digital immortality by merging
  with Slime-Cores. They mutated into towering slime monstrosities guarding Ark
  Keys encoded in their Cores.

- **Cores**: High-density minerals that channel raw power. Allow physical force
  from biological energy.

- **The Ark**: Interstellar courier ship in Hub sub-basement. Needs Stabilized
  Points + 5 Keys to launch and escape the planet.

- **Ark Stasis**: Your original human body in cryostasis on Floor 0. Final goal:
  upload consciousness back into it and launch.

- **Symbiosis**: Slime provides muscle; Cores provide control. Slimes act as the
  planet’s aggressive immune response.

- **The Paradox of Sanity**: Only the printed stable chassis can socket Cores
  without mutating. Human biology cannot handle the load and became bosses.

---

## The Hub

### Overview

Physical vertical fortress protected by Outliner. Safe zone. Real-time but pause
allowed inside.

### Floor Breakdown

- **Floor 4: Atrium (Command Center)**: Logistics & Strategy
    - **Print Pad**: Primary spawn point where the Pilot’s chassis is rendered.

    - **Jump-Start Terminal**: Select Story nodes or start an Endless Cycle.

    - **Holo-Globe**: Real-time display that tracks biome collapse timers and
      identifies active Lab frequencies.

    - **Archive Terminal**: Accesses decrypted Caretaker logs.

    - **Standard-Issue Terminal**: Prints basic core-less hardware for free if
      bankrupt.

- **Floor 3: Forge (Weaponry)**: Industrial Fabrication
    - **Blueprint Lattice**: Gallery of weapon schematics.

    - **Dismantler**: Recycles parts into Scrap.

    - **Builder Bench**: Prints modular weapon components and assembles weapon
      configurations.

    - **Socket Station**: Hard-wires Slime Cores into hardware parts.

- **Floor 2: Bio-Lab (Research)**: Alchemy & Evolution
    - **Essence Vats**: Store liquified Core Essence.

    - **Core Printer**: Renders new Slime Cores.

    - **Fusion Chamber**: Combine low-tier cores into higher tiers.

    - **Suit Rig**: Modifies Neural Lattice for core-driven movement and utility
      abilities.
    - **Drone Station**: Upgrades drone.

- **Floor 1: Range (Testing Ground)**: Simulation
    - **Rent-A-Weapon Station**: Test any weapon.

    - **Target Simulation**: Spawns holographic slimes for DPS testing.

    - **Analytics Overlay**: Shows spread, recoil, damage fall-off.

- **Floor 0: Ark Hangar**: Final Goal
    - **The Ark**: Interstellar courier ship in Deep Sleep.

    - **Key Console**: Slot Ark Keys to prepare launch sequence.

---

## Gmeplay Modes

### Story

Structured Metroidvania-style experience focused on mapping the unknown.

- **Goal**: Reach the Ark and escape the planet.

- **Structure**: Print into a biome and locate a Sync Terminal (Sub-Station).
  Activating it creates a permanent fast-travel/reprint point.

- **Progression**: Discovery gated by hardware requirements and environmental
  hazards that need specific Rig upgrades.

### Endless

Procedural high-intensity mode focused on resource farming and survival.

- **Goal**: Maximum Siphon Yield.

- **Collapse Mechanic**: Each biome has a shared collapse timer visible on the
  Holo-Globe.

- **Escalation**: Deeper runs increase risk and multipliers.

- **Reprint Threshold**: Die without reaching a Sync Point and unsynced loot is
  lost. Drone must physically return before timer expires or it is lost.

---

## Combat & Customization

### Equipment System

Modular hardware components that interface with your Neural Lattice.

- **Guns**:
    - **Frame**: Determines archetype and Core Sockets (1–3).

    - **Barrel**: Projectile type, range, accuracy.

    - **Muzzle**: Recoil and detection.

    - **Stock**: Handling while moving.

    - **Magazine**: Capacity, reload, ammo types.

    - **Optics**: Zoom and weak-point highlighting.

- **Swords**:
    - **Handle**: Swing archetype and guard mechanic.

    - **Blade**: Reach and special effects.

### Drone System

Physical tool to secure loot without returning to Hub. Spawn drone, load
Scrap/Cores, send it back. You are vulnerable while it travels. It must
physically return to you. Upgradable: max distance, fly speed, carry weight. Can
be intercepted by Slimes. Must beat biome collapse timer.

### Modification System

- **Fusion Process**: At Socket Station — permanently hard-wire Slime Core into
  a weapon part.

- **Visual Feedback**: 3-color system. Secondary color overridden by Core’s
  glow. Multiple same-type cores unlock synergy perks (e.g., 3 Volt Cores =
  Chain Lightning).

### Slimiary

Slimes categorized by yield:

- **Volt (Yellow)**: Fast skirmishers. Yields: **Fire Rate**, **Reload Speed**,
  **Movement**.

- **Bulwark (Blue)**: Tanky, shielded blockers. Yields: **Damage Resistance**,
  **Mag Size**, **Knockback**.

- **Magma (Red)**: Unstable area-denial units. Yields: **AOE Radius**,
  **Explosive Damage**.

- **Caustic (Green)**: Bio-hazard trail-layers. Yields: **DoT (Damage over
  Time)**, **Armor-Melting**.

- **Phase (Purple)**: Teleporting ambushers. Yields: **Piercing**, **Bullet
  Velocity**.

- **Prism (Rainbow)**: "Mimics" that are invisible until scanned or attacking.
  Yields: **Evasion**, **Critical Hits**.

### Core Utility Matrix

| Element         | Environmental Key                    | Weapon Infusion           |
| --------------- | ------------------------------------ | ------------------------- |
| Volt (Yellow)   | Powers Dead Terminals / Elevators    | Fire Rate / Reload Speed  |
| Bulwark (Blue)  | Resists High-Pressure Wind-Zones     | Mag Size / Knockback      |
| Magma (Red)     | Melts Overgrowth / Vitrified Ice     | AOE / Splash Damage       |
| Caustic (Green) | Neutralizes Alkali Fog / Melts Locks | Armor Strip / DoT         |
| Phase (Purple)  | Shifts through Fans / Laser Grids    | Velocity / Piercing       |
| Prism (Rainbow) | Bypasses Motion-Sensing Turrets      | Evasion / Critical Chance |

### Character Progression

The Siphon Pilot features 3 internal Rig Slots for core-driven upgrades:

- **Movement**: Core-driven abilities.
    - _Volt_: Speed Burst (Wall-run velocity).

    - _Phase_: Warp Dash (Blink through obstacles like fans/grates).

    - _Caustic_: Slide Trail (Damaging slick).

- **Utility**: Passive survival.
    - _Volt_: Scan Pulse (Highlights Mimics and hidden chests).

    - _Magma_: Thermal Shield (Lava/Heat floor resistance).

    - _Prism_: Optical Scrambler (Delays turret lock-on).

- **Combat**: Suit-integrated weapons or overclocks.
    - _Bulwark_: Armor Plating (Increased HP at the cost of speed).

    - _Magma_: Heat Sink (Prevents weapon overheat).

    - _Prism_: Critical Sync (Reveals Boss weak points in real-time).

---

## Economy & Resources

### Resource Tables

| Resource          | Type       | Source                  | Purpose                                |
| ----------------- | ---------- | ----------------------- | -------------------------------------- |
| Liquid Essence    | Volatile   | Kills / Siphons         | Stabilization, Core printing           |
| Scrap             | Persistent | Dismantling Parts       | Printing modules, upgrading blueprints |
| Volatile Points   | Volatile   | Objectives / Loot       | Becomes Stabilized Points              |
| Stabilized Points | Persistent | Banking Volatile Points | Hub evolution, Ark power               |
| Cores             | Physical   | High-Tier Chests / Loot | Hardware infusion                      |

### Risk vs. Reward

- **Siphon Multiplier**: Deeper runs increase interference and Essence yield.

- **Signal Stabilization (Safe Zones)**: Spend Essence in Repeater Shelters to
  extend time before collapse.

- **Volatile vs. Stabilized**: Carried resources lost on death until
  successfully extracted at Hub lift.

- **Penalty**: Death leaves chassis and equipped gear at Crash Site. Recover
  before biome collapse timer or lost forever.

- **Dead Zones**: No radio/HUD/drone support. Death here = permanent loss of
  that chassis progress.

- **Weight & Logistics**: Physical weight affects movement speed and stamina.
  Drone has upgraded carry limits.

- **The Death Penalty**: Body stays at Crash Site. Miss the biome timer =
  consumed.

---

## Level Design & Biomes

### Environmental Philosophy

Dark subterranean expanse. Veins are claustrophobic shifting tunnels. Labs are
fixed, color-coded industrial strongholds. Discovery peels back fog of war.

- **Veins**: These act as the "Roads." They are dark, claustrophobic, and
  shifting. Navigation is a survival mechanic; players must manage battery and
  pressure while tracking "Resonance Pings" to find their destination.

- **Labs**: These are the "Cities." Massive, hand-crafted industrial complexes
  embedded in the rock. Discovering a lab is the reward for surviving the
  tunnels. Each lab has a distinct monochromatic identity, a dedicated slime
  species, and a Boss Arena.

- **Visual Gating**: You don't "level up" to see new areas; you find them. The
  planet is a fog of war that only peels back as you physically discover the
  entrance to a colored bastion.

### Biome Catalog

- **Lab Yellow (The Kinetic Lab)**: A high-voltage power grid filled with
  massive turbines and sparking capacitors.
    - _Identity_: Loud, mechanical, buzzing.

    - _Enemy_: Volt Slimes.

    - _POI_: The Generator Core (Boss).

- **Lab Blue (The Cryo Lab)**: A cooling array defined by frost-shattered glass,
  liquid nitrogen vats, and vitrified floors.
    - _Identity_: Silent, brittle, frozen.

    - _Enemy_: Bulwark Slimes.

    - _POI_: The Zero-Point Vat (Boss).

- **Lab Red (The Thermal Lab)**: A deep-mantle siphon built into volcanic rock
  with orange "heat-veins" and obsidian plating.
    - _Identity_: Oppressive, glowing, industrial.

    - _Enemy_: Magma Slimes.

    - _POI_: The Mantle Drill (Boss).

- **Lab Green (The Chemical Lab)**: A bio-processing plant where slimes were
  first synthesized. Filled with emerald emergency lights and thick toxic fog.
    - _Identity_: Wet, fluorescent, hazardous.

    - _Enemy_: Caustic Slimes.

    - _POI_: The Catalyst Tank (Boss).

- **Lab Purple (The Resonance Vault)**: A high-tech laboratory where the
  "Breach" occurred. Gravity is unstable, and architecture shifts out of phase.
    - _Identity_: Eerie, shifting, violet.

    - _Enemy_: Phase Slimes.

    - _POI_: The Void Anchor (Boss).

### Procedural Logic

- **Spoke & Hub Generation**: The world generates "Labs" as fixed, high-detail
  chunks. The generator then "spins" a web of procedurally generated tunnels
  (The Veins) to connect them.

- **Resonance Tracking**: Players carry a tracker that tunes into specific color
  frequencies. The closer you get to Lab Red, the more the HUD flickers orange.

- **Looping Shortcuts**: Clearing a Lab unlocks one-way transit pipe shortcuts.

---

## Objectives & Grading

### Primary Objectives

- **Lab Infiltration**: Locate and reach inner sanctum of a Lab.

- **Key Extraction**: Defeat Researcher Boss to secure Ark Key.

- **Siphon Defense**: Deploy extractor and defend while harvesting Essence.

### Optional Goals

- **Cartography**: Fully map a lab.

- **Data Recovery**: Retrieve audio logs.

- **Asset Recovery**: Recover lost pilot backpacks.

### Reward Tiers

- **Bronze**: Basic Volatile Points and Essence.

- **Silver**: Bonus Scrap and random attachment.

- **Gold**: High-tier Frame/Blade and Core Shard.

- **Platinum** (S-Rank): Guaranteed Slime Core.

---

## Endgame & Explanation

### Final Act

Collect Ark Keys and enough Stabilized Points. Descend to Floor 0. Upload
consciousness from printed chassis back into original human body in cryostasis.
Board the Ark and launch, leaving the planet. Game ends.

### Post-Game

- **Optional**: After credits, you can spawn back in the Hub (Ark is gone) for
  continued Endless play if desired. No further story progression.

- **Play Again**: Choose to play again, but at a different difficulty level.

## Future Roadmap

- **Multiplayer Atrium**: The Atrium becomes a shared social space where you can
  see other Pilots and their customized Rigs before heading out into the Veins.

- **Co-op Expeditions**: Squad-based missions into "Mega-Veins" where the
  environment requires two or more specific Core abilities (e.g., Phase and
  Magma) to be activated simultaneously to progress.

- **Rival Scavengers**: AI-controlled "Rogue Automata" appearing in the tunnels
  during Endless runs, attempting to steal your backpack before you reach the
  Vacuum Vent.

- **Expansion Biome**: The Sub-Sea Pipes: A new subterranean ocean biome where
  water-pressure mechanics and low-visibility "Deep-Dives" introduce the Aquatic
  (Teal) Core.
