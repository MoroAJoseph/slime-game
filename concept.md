# Slime Game Concept Document

## Table of Contents

- [Identity](#identity)
- [Pillars](#pillars)
- [Themes](#themes)
- [Narrative](#narrative)
- [Core Mechanics](#core-mechanics)
- [Player Mechanics](#player-mechanics)
- [Drone Mechanics](#drone-mechanics)
- [Environmental Mechanics](#environmental-mechanics)
- [Game Loops](#game-loops)
- [Objectives](#objectives)
- [Items](#items)
- [Replay-Ability](#replayability)
- [Development Roadmap](#development-roadmap)

---

# Identity

The game is a systemic survival-action experience built around constrained
resource optimization under escalating environmental pressure.

## Genre Classification

- Systemic Survival Action
- Resource-driven Combat RPG
- Extraction-based Risk Sandbox

## Core Comparisons (Design References)

- Combat pressure and stamina economy → Monster Hunter-like engagement pacing
- Extraction and risk-loop structure → Escape-from-Tarkov-like tension model
- System interdependence and build optimization → ARPG-style scaling systems
- Environmental hostility and traversal risk → survival roguelike structures

## Core Identity Statement

The player is not clearing content.  
The player is sustaining operation under systemic degradation.

Progression is defined by:

- Efficiency under constraint
- Route mastery
- System synergy optimization

Not power accumulation.

---

# Pillars

Pillars are non-negotiable system laws. All mechanics must conform to them.

## Systemic Cost Requirement

All actions must carry meaningful cost.  
No sustained advantage exists without tradeoff.

## Interdependent Systems

No system operates in isolation.  
All advantages require cross-system interaction.

## Temporary Power States

High-output states are unstable and time-limited.  
Sustained dominance is structurally disallowed.

## Environmental Control

The world actively constrains player capability.  
Traversal and combat are shaped by external systems.

## Persistent Consequence

Failure produces lasting spatial and material impact.  
Recovery is required for progression continuity.

## Learnable Instability

Systems remain consistent, but conditions vary.  
Mastery is achieved through adaptation, not memorization.

---

# Themes

Themes define experiential reality. They describe how systems feel during play.

## Controlled Instability

Stability is temporary and conditional.  
The player operates near collapse at all times.

## Scarcity Pressure

Resources are never sufficient for comfort.  
Efficiency is mandatory for survival.

## Earned Mastery

Knowledge replaces raw power.  
Skill is built through repetition under constraint.

## Risk-Driven Progress

Advancement requires exposure to danger.  
Safety reduces opportunity for growth.

## Systemic Tension

Every advantage introduces a competing failure state.  
No gameplay state is fully resolved or stable.

---

# Narrative

Aura-5 is a deep industrial mining world centered on Prism Lab, a large-scale
extraction and processing facility.

Industrial lubrication systems used in deep drilling reacted with rare
subsurface minerals under extreme heat and pressure. The reaction produced
Slime, a self-propagating material that absorbs and restructures surrounding
matter into adaptive formations.

Slime spreads through infrastructure and terrain, replacing industrial systems
with unstable, self-organizing growth. It does not contaminate in a biological
sense—it repurposes and reconstructs.

A Resonance Breach inside Prism Lab caused a system-wide failure that
accelerated Slime propagation beyond containment. The facility collapsed into
fragmented, unstable zones governed by Slime activity and environmental
instability.

Personnel were affected in three ways: death during collapse, entrapment within
sealed or absorbed zones, or biological alteration from prolonged exposure.
Altered personnel are no longer stable humans and exist as hostile or inactive
entities integrated into Slime-controlled regions.

A corporate recovery mission was deployed after contact was lost. It failed
during atmospheric entry due to environmental instability and Slime
interference. Its wreckage is scattered throughout the world and partially
embedded in Slime structures.

The Ark, located beneath the Hub, is an evacuation system requiring genetic
authentication from all command-tier personnel. Their DNA functions as
system-level access keys. Without all required sequences, the Ark remains
locked.

The player is reactivated as the last operational node. Their objective is to
recover command-tier genetic data across the system. Targets may be alive, dead,
or altered. Alive targets can be escorted, dead targets require genetic
extraction, and altered targets must be neutralized to recover usable material.

Recovered equipment and mission fragments are distributed across the world
within Slime-affected zones.

The Ark activates only when all required genetic data is registered at the Hub.

---

# Core Mechanics

Core mechanics define the fundamental rules governing interaction, survival, and
system behavior. These rules apply universally across all gameplay layers.

## Resource Dependency

All meaningful actions are governed by a single unified resource.

### Principles

- No action is free unless explicitly defined as passive
- All systems must either:
    - Consume energy
    - Modify energy efficiency
    - Convert energy into another form (Heat, Mass, Output)

### Design Role

Enforces continuous resource evaluation across all gameplay states.  
Every decision directly impacts long-term survivability.

---

## Risk-Weighted Action System

All player actions exist on a defined risk-to-reward spectrum.

### Structure

- Low cost → low impact
- High cost → high impact

### Examples

- Basic Melee: zero cost, low risk, resource recovery
- Empowerment: sustained cost, high combat output
- Overdrive: extreme mobility, high systemic instability

### Design Rule

High-impact actions must introduce proportional systemic risk.  
No system provides sustained advantage without cost escalation.

---

## Spatial Commitment

Traversal is a constrained system governed by resource state and load.

### Rules

- Mass directly affects movement efficiency
- Energy defines movement sustainability
- Overdrive provides temporary constraint override at systemic cost

### Outcome

Players must optimize routes based on:

- Energy availability
- Carry weight
- Environmental pressure timing

Traversal efficiency is a primary expression of player skill.

---

## System Interdependence

All major systems are interconnected and cannot be optimized independently.

### Relationships

- Energy ↔ Combat output
- Mass ↔ Mobility efficiency
- Heat ↔ System stability
- Overdrive ↔ Mass and Energy override

### Design Principle

Player performance is determined by multi-system optimization, not isolated
decision-making.

---

## State Pressure System

The game applies continuous overlapping pressure through multiple systems.

### Pressure Sources

- Energy depletion
- Mass accumulation
- Heat buildup
- Environmental Instability Cycle

### Effect

Forces:

- Constant prioritization
- Risk evaluation under constraint
- Route-level strategic planning

---

## Recovery Dependency

Progression is persistent and recovery-based.

### Rules

- Death results in physical resource loss at location
- Recovery requires re-entry into the failure point
- Failure increases loss cost based on distance and exposure

### Design Role

Risk extends beyond immediate failure and affects future decision-making.

---

## Information Scarcity

Player knowledge is limited and must be acquired through interaction.

### Rules

- Hazards and optimal paths are not fully visible by default
- Information is gained through traversal and tool usage
- Repetition improves efficiency

### Outcome

Mastery is defined by knowledge acquisition and execution precision.

---

## System Constraint Hierarchy

When multiple systems conflict, resolution follows strict priority:

1. Survival (Low Power Mode)
2. Energy integrity
3. Mobility constraints (Mass / Overdrive)
4. Combat systems
5. Utility systems (Drone, tools)

### Purpose

Prevents system exploitation and ensures consistent behavior under stress
conditions.

---

## Thermal System (Heat + Cooling)

Heat is a unified systemic instability layer applied across all subsystems
(Player, Weapon, Drone). It governs sustained high-output behavior and enforces
recovery pacing.

### Heat Generation Sources

Heat is accumulated through:

- Overcharge (Energy amplification state)
- Overdrive usage (mobility override)
- Empowerment usage (weapon infusion)
- Drone operational activity (mode-dependent scaling)
- High-output environmental zones (thermal Slime regions)

### Heat Behavior

- Heat builds progressively during sustained high-performance activity
- Heat reduces system efficiency as it increases
- Heat applies globally but is tracked per-subsystem (Player / Weapon / Drone)

### Thermal Threshold

At maximum Heat capacity:

- The affected subsystem enters **Thermal Lockdown**
- High-consumption actions within that subsystem are disabled or degraded

### Cooling State

Cooling is a forced recovery state triggered per subsystem after threshold
breach.

During Cooling:

- Energy efficiency is reduced in favor of stabilization
- Affected subsystem actions are degraded or restricted
- Other subsystems remain operational unless also overheated

### Design Role

Heat functions as a shared constraint framework that still preserves subsystem
autonomy. It prevents sustained optimization without collapsing the entire
system state.

---

# Player Mechanics

Player Mechanics define how the player executes actions within system
constraints. These mechanics translate Core Systems into direct,
moment-to-moment gameplay.

## Movement System

Movement is a constrained system governed by energy, mass, and environmental
pressure.

### Baseline Behavior

- Directional movement is always available under normal conditions
- Movement speed is dynamically modified by system states

### Movement Constraints

Movement is affected by:

- **Mass System:** reduces speed and disables advanced mobility when over
  threshold
- **Energy State:** limits duration of sustained movement actions
- **Thermal State:** restricts Overdrive usage under high Heat

### Design Role

Movement is not a default state—it is a managed resource.  
Efficiency of movement directly determines survival and success.

---

## Sprinting

Sprinting increases traversal speed at a continuous energy cost.

### Behavior

- Increases movement speed above baseline
- Applies constant energy drain
- Amplifies Heat generation when combined with Overdrive

### Tradeoffs

- Improves short-term traversal efficiency
- Reduces total operational time

### Design Role

Sprinting is a controlled acceleration tool, not a sustained movement state.

---

## Combat System

Combat operates as a closed resource loop rather than a standalone damage
system.

### Core Loop

1. **Engage:** Use weapons or melee to damage targets
2. **Convert:** Execute enemies to recover energy (Siphoning)
3. **Reinvest:** Use recovered energy for Empowerment or mobility
4. **Overextend:** Excessive output generates Heat and instability

### Melee / Siphoning

- Always available (no energy cost)
- Primary method of energy recovery
- Requires close-range commitment

### Ranged Combat

- Uses limited ammunition resources
- Scales in effectiveness through Shard configuration
- Becomes significantly stronger when combined with Empowerment

### Design Role

Combat is not optional—it is the primary method of sustaining energy.  
Avoidance reduces risk short-term but limits long-term viability.

---

## Overdrive Usage

Overdrive is the player’s primary mobility override tool.

### Player-Controlled Behavior

- Activated manually to bypass Mass constraints
- Used to escape high-risk states or maintain route efficiency

### Practical Use Cases

- Recovering from overburdened states
- Escaping Instability Phase pressure
- Maintaining route timing under load

### Risk Profile

- Rapid energy depletion
- Accelerated Heat buildup
- Loss of availability under system stress (Low Power / Thermal Lockdown)

### Design Role

Overdrive is a recovery and optimization tool—not a default mobility state.

---

## Flashlight Usage

The Flashlight extends player perception in low-visibility conditions.

### Function

- Illuminates traversal paths and environmental hazards
- Reveals interactables and hidden geometry

### Cost

- Continuous energy drain while active

### Environmental Interaction

- Increased importance during Instability Phase
- May increase player visibility to hostile entities

### Design Role

The Flashlight converts energy into information.  
Players must choose between awareness and longevity.

---

## Interaction System

All player interactions are governed by a unified input and validation system.

### Interaction Types

- **Harvesting:** Resource extraction and Siphoning
- **System Access:** Terminals, Forge, environmental controls
- **Object Interaction:** Pickup, activation, manipulation
- **Drone Control:** Mode switching and deployment

### Constraints

Interactions require:

- Physical proximity
- Line-of-sight validation
- Sufficient system state (energy, access conditions)

### Design Role

Interaction is intentional and positional.  
Players must commit to actions within constrained space and time.

---

## Weapon Thermal Degradation

Weapons operate under localized Heat accumulation during extended use.

### Behavior

- Continuous firing or melee chaining increases Weapon Heat
- Empowerment accelerates Weapon Heat buildup
- High Weapon Heat reduces attack speed and responsiveness

### Cooling Impact

During cooling:

- Fire rate is reduced
- Swing speed is reduced
- Empowerment effectiveness is temporarily weakened

### Design Role

Prevents infinite combat throughput and enforces pacing inside encounters.

---

# Drone Mechanics

The Helper Drone is a semi-autonomous logistical support system. Its primary
role is resource management and operational support, not direct combat
replacement.

## Design Role

The Drone is an extension of the player’s operational capacity.

It functions as:

- A logistical amplifier
- A configurable subsystem under shared constraints
- A force multiplier for resource efficiency, not combat dominance

It is not autonomous gameplay replacement; it is player-executed extension
logic.

---

## Operational Modes

The Drone operates in discrete modes. Only one mode may be active at a time.

### Wait Mode

- Enters a passive state at a fixed location
- Acts as a positional anchor for navigation and fallback

**Use Case:**

- Route marking
- Staging area setup

### Defend Mode

- Engages hostile targets within a limited radius
- Prioritizes threats closest to the player

**Constraints:**

- Limited engagement range
- Reduced damage output compared to player weapons

**Role:**

- Supplemental pressure relief, not primary combat solution

### Attack Mode

- Actively seeks nearby hostile targets
- Operates within a defined operational radius

**Constraints:**

- Lower efficiency than player-controlled combat
- High energy consumption rate
- Vulnerable during extended engagements

**Role:**

- Tactical distraction and pressure distribution

### Loot Mode

- Automatically collects nearby resources

**Behavior:**

- Prioritizes proximity-based items
- Transfers items into Drone storage

**Impact:**

- Reduces player exposure time
- Transfers Mass burden to Drone

---

## Energy System

The Drone operates on a finite, independent energy reserve linked to player
systems.

### Behavior

- All active modes consume energy continuously
- Higher-intensity modes (Attack, Defend) increase drain rate

### Recharge Conditions

The Drone can only fully recharge at:

- Labs
- Hub
- Player rig docking state

### Failure State

- At zero energy, the Drone becomes inactive
- Cannot perform actions until recharged

---

## Transit System

The Drone can transport stored resources to a Lab or Hub.

### Function

- Initiates autonomous delivery of stored cargo

### Risk Conditions

- Player death during transit
- Player energy depletion during transit

### Failure Outcome

- Drone crashes
- All cargo is permanently lost

### Design Role

Transit introduces delayed risk, forcing players to:

- Evaluate timing
- Commit to transport decisions
- Accept potential loss for efficiency gain

---

## Mass Interaction

The Drone directly interacts with the Mass System.

### Offloading

- Transferring items to the Drone reduces player Mass
- Enables improved movement and route efficiency

### Docked State

While attached to the player for charging:

- Drone mass and stored cargo are added to player Mass

### Tradeoff

- Mobility vs logistical capacity
- Safety vs efficiency

---

## Deployment Constraints

Drone usage is intentionally limited to prevent abuse.

### Mode Switching

- Switching modes is not instantaneous
- May require short delay or positional stability

### Operational Range

- Drone effectiveness is limited by distance from player
- Exceeding range reduces responsiveness or disables functions

### Vulnerability

- Drone performance degrades under high-pressure conditions:
    - Instability Phase
    - Hazard zones
    - Energy starvation

---

## Design Summary

The Drone is:

- A logistical amplifier
- A risk management tool
- A mobility support system

It is not:

- A primary combat system
- A replacement for player skill
- A zero-cost automation layer

---

## Drone Thermal Behavior (Integrated Rule)

The Drone does not have a separate Thermal System. Instead, it contributes to
and is constrained by the global Thermal System.

### Behavior

- Drone Heat generation is mode-dependent:
    - Attack Mode: highest contribution
    - Defend Mode: moderate contribution
    - Loot Mode: low contribution

- Drone cannot exceed system-wide Thermal Lockdown constraints

### Design Role

Ensures the Drone is a subsystem of the player’s architecture rather than an
independent balance layer.

---

## Drone Energy + Heat Interaction

- Energy governs _duration of operation_
- Heat governs _quality and stability of operation_

Both must be managed simultaneously.

---

# Environmental Mechanics

Environmental Mechanics define how the world applies pressure, shapes traversal,
and enforces risk through terrain, hazards, and Slime propagation.

## Instability System

The world operates on a cyclical pressure model that alters environmental
behavior over time.

### Stability Phase

- Reduced enemy density
- Minimal environmental interference
- Stable traversal conditions

**Role:** Supports exploration, route learning, and resource planning.

### Instability Phase

- Increased Slime activity and enemy density
- Active environmental disruption
- Reduced visibility
- Increased passive energy drain

**Role:** Forces execution under pressure and disrupts optimized routes.

---

## Slime System

Slime is the primary environmental and enemy force. Each Slime type represents a
distinct elemental behavior that affects both combat and terrain.

### Design Structure

Each Slime type defines:

- **Combat Behavior**
- **Environmental Effect**
- **Player Tradeoff (Advantage vs Disadvantage)**

---

## Slime Types

### Volt Slime (Electric)

**Combat Behavior:**

- Chains electrical damage between targets
- Can briefly disrupt player systems

**Environmental Effect:**

- Electrified surfaces and conductive zones
- Interacts with powered machinery

**Advantage:**

- Can power inactive systems or shortcuts
- Enables access to energy-based traversal routes

**Disadvantage:**

- Causes intermittent energy instability or drain
- Disrupts drone and system reliability

### Bulwark Slime (Kinetic / Cryo)

**Combat Behavior:**

- High resistance to stagger
- Applies impact-based knockback or slow effects

**Environmental Effect:**

- Creates hardened or frozen terrain
- Reduces movement speed and traction

**Advantage:**

- Stabilizes fragile terrain or collapsing paths
- Can create temporary safe traversal surfaces

**Disadvantage:**

- Slows player movement significantly
- Increases traversal cost and reduces escape options

### Magma Slime (Thermal)

**Combat Behavior:**

- Applies burn damage over time
- Creates area denial through heat zones

**Environmental Effect:**

- Generates thermal vents and burning terrain
- Increases ambient Heat gain

**Advantage:**

- Activates thermal systems and sealed pathways
- Can clear environmental obstructions

**Disadvantage:**

- Accelerates Heat accumulation
- Forces early Thermal Lockdown if unmanaged

### Caustic Slime (Corrosive)

**Combat Behavior:**

- Applies damage over time
- Reduces player defensive stability

**Environmental Effect:**

- Creates toxic zones and corrosive pools
- Degrades safe traversal areas

**Advantage:**

- Dissolves barriers and blocked routes
- Opens alternate paths

**Disadvantage:**

- Drains durability in hazardous zones
- Forces rapid movement or avoidance

### Phase Slime (Gravity)

**Combat Behavior:**

- Applies slow, pull, or displacement effects
- Alters projectile and movement behavior

**Environmental Effect:**

- Distorts gravity fields and traversal space
- Creates unstable movement zones

**Advantage:**

- Enables access to otherwise unreachable areas
- Reduces effective Mass in specific zones

**Disadvantage:**

- Disrupts movement control
- Increases traversal unpredictability

### Prism Slime (Adaptive)

**Combat Behavior:**

- Adapts to player behavior or damage type
- Exploits weaknesses dynamically

**Environmental Effect:**

- Mimics environment and conceals structures or paths
- Alters visibility and perception

**Advantage:**

- Reveals hidden caches or alternate routes
- Can expose high-value resources

**Disadvantage:**

- Increases encounter unpredictability
- Reduces reliability of learned routes

---

## Hazard Integration

Slime types define environmental hazards rather than existing as isolated
enemies.

### Rules

- Hazard zones are tied to dominant Slime presence
- Multiple Slime types may overlap, creating compounded effects
- Hazard intensity increases during Instability Phase

---

## Visibility & Navigation

Environmental visibility is a controlled variable.

### Behavior

- Reduced visibility in high Slime density zones
- Further reduced during Instability Phase

### Player Tools

- Flashlight mitigates visibility loss at energy cost
- Route memorization reduces dependency over time

---

## Environmental Design Principles

- The world is static in structure but dynamic in pressure
- Systems modify traversal conditions, not layout
- Optimal routes exist but are conditionally safe

---

## Design Summary

The environment functions as:

- A pressure system
- A traversal constraint layer
- A risk amplifier

Slime is not just an enemy—it is the mechanism through which the world enforces
all core systems.

---

---

## World Structure

The environment is composed of four primary zone types:

- Hub (Adaptive Control Zone)
- Labs (Stabilized Legacy Zones)
- Mines (Unstable Resource Zones)
- Terrain (Hostile Traversal Space)

Each zone serves a distinct mechanical role.

---

## Hub (Adaptive Zone)

- Fully controlled environment
- No environmental hazards
- All advanced systems available

**Role:**

- Progression and system modification

---

## Labs (Stabilized Zones)

Labs are partially reclaimed legacy facilities.

### Characteristics

- Dominated by a single Slime type (~90%)
- Predictable hazard behavior
- Fixed environmental conditions

### Function

- Safe zone after clearance
- Full recharge and system access
- Reliable navigation anchor

### Design Role

- Reinforces mastery through repetition
- Teaches element-specific adaptation

---

## Mines (Unstable Zones)

Mines are degraded excavation networks overrun by mixed Slime activity.

### Characteristics

- Multi-element Slime presence (no dominant type)
- High environmental instability
- Reduced visibility and spatial clarity

### Environmental Behavior

- Overlapping hazard effects
- Intermittent terrain disruption
- Dynamic pressure escalation during Instability Phase

### Resource Profile

- Increased Core density
- Higher chance of rare materials
- Access to limited high-value consumables

### Player Ownership (Soft Familiarity System)

Mines are not permanently secured, but they are **learnable spaces**.

- Enemy spawns and resource nodes follow semi-persistent logic
- Players can develop **repeatable farming routes**
- “Clearing” a mine reduces short-term pressure but does not permanently
  stabilize it
- Over time, players form **preferred extraction zones**

### Constraints

- Cannot be permanently secured
- No full system recovery
- No guaranteed long-term safety

### Exit Risk

- Entry is low commitment
- Exit requires resource and route management

### Design Role

- Supports mastery through repetition under instability
- Enables farming identity without removing systemic pressure
- Encourages route optimization and memory-based efficiency

---

## Terrain (Traversal Layer)

The terrain connects all zones and acts as the primary gameplay space.

### Characteristics

- Fixed structure with variable pressure
- Vertical design emphasis
- Route efficiency defines player success

### Modifiers

- Slime presence alters traversal conditions
- Instability Cycle modifies safety and visibility
- Hazard zones reshape movement decisions

---

## Slime Distribution Model

Slime presence varies by zone type:

- **Labs:** Single-element dominance
- **Mines:** Multi-element overlap
- **Terrain:** Mixed but regionally biased

---

## Environmental Design Principles

- Structure is static; conditions are dynamic
- Mastery is based on route optimization
- Instability disrupts optimal play patterns
- Risk increases with deviation from controlled zones

---

## Design Summary

- **Hub:** Control and progression
- **Labs:** Stability and mastery
- **Mines:** Instability and opportunity
- **Terrain:** Execution and traversal

Together, these systems create a layered environment where players must
continuously balance safety, efficiency, and risk.

---

# Game Loops

## Pressure Execution Loop

1. Detect threat / opportunity
2. Engage using weapon or melee
3. Generate Heat through output systems
4. Convert kills via Siphoning (energy recovery)
5. Reinvest energy into:
    - Empowerment (burst output)
    - Movement (Overdrive / reposition)
    - Drone support (optional pressure relief)
6. Escalating Heat forces transition into:
    - reduced efficiency state
    - tactical slowdown
    - reposition or disengage

---

## Extraction Loop (Local Run Cycle)

1. Enter zone (Mine / Lab / Terrain segment)
2. Assess instability + Slime distribution
3. Establish temporary route logic (learn pattern / identify density zones)
4. Engage Slimes in dense clusters (combat loop embedded)
5. Extract resources:
    - Cores
    - Materials
    - Energy via Siphoning
6. Manage constraints:
    - Mass accumulation
    - Heat buildup
    - Drone capacity (loot/logistics support)
7. Decide:
    - Continue deeper (risk escalation)
    - Extract and return (secure gain)
8. Exit or collapse into recovery scenario

---

## Adaptation Loop (Meta Progression)

1. Enter unstable environment (Mine / Lab chain)
2. Learn:
    - Slime behavior patterns
    - Heat thresholds
    - Drone configurations
    - Route efficiencies
3. Optimize:
    - Build loadouts (Shards, Suit Cores)
    - Adjust Drone profiles
    - Refine traversal routes
4. Fail or succeed in extraction cycles
5. Return to Hub / Lab
6. Upgrade systems:
    - efficiency improvements
    - new configurations
    - expanded operational capacity
7. Re-enter world at higher complexity threshold

---

# Objectives

Objectives are not quest chains. They are player-defined operational goals
executed under systemic constraints.

## Run Objectives

Before each excursion, the player implicitly or explicitly defines intent:

- Core extraction (Cores, materials, rare drops)
- Build acquisition (Suit Cores, Shards, components)
- Route learning (mapping Mines / Labs behavior)
- Resource farming (repeatable extraction zones)

Objectives are not tracked by the system as directives, but validated by
outcome.

---

## Environmental Objectives

Certain zones impose implicit goals:

- Stabilize traversal routes temporarily
- Clear high-density Slime zones for access
- Survive Instability Phase cycles
- Extract before system collapse (Heat / Energy / Mass failure)

---

## Recovery Objectives

Failure generates forced objectives:

- Retrieve dropped resources from death location
- Re-establish route viability
- Recover lost efficiency through repetition

---

# Items

Items are systemic modifiers, not rewards. Each item alters how the player
interacts with constraints.

## Design Rules for Items

- No item removes system constraints
- All items modify tradeoffs
- All items interact with at least one core system (Energy, Heat, Mass, Space,
  or Information)

---

## Field Core Extractor

A limited-use adaptation tool for in-field system modification.

### Function

- Allows removal or swapping of Suit Cores outside safe zones

### Constraints

- Does not affect Weapon Shards
- Limited availability per run
- High strategic value due to timing flexibility

### Design Role

Enables mid-run build correction without breaking commitment systems.

---

## Suit Cores

Primary structural modifiers for player capability.

### Function

- Define core stat behavior (Energy efficiency, Heat tolerance, Mass handling,
  etc.)
- Determine playstyle identity under constraint systems

### Constraint Interaction

- Always interact with at least one global system (Heat, Energy, Mass)

### Design Role

Long-term build architecture. Defines how a player survives systemic pressure.

---

## Weapon Shards

Combat system modifiers embedded into weapons.

### Function

- Modify attack behavior, scaling, or efficiency loops
- Influence Heat generation and resource conversion in combat

### Constraint Interaction

- Directly affects Weapon Heat system
- Alters risk-reward balance of combat output

### Design Role

Defines combat identity without decoupling from systemic cost structure.

---

## Resource Materials

Core economic inputs from Mines, Labs, and Terrain zones.

### Types

- Cores (progression / system upgrades)
- Scrap (conversion / crafting base)
- Rare materials (high-tier system modifications)

### Design Role

Fuel for adaptation loop. Always tied to risk exposure.

---

## Consumables

Temporary system modifiers with short-term effects.

### Function

- Energy restoration
- Heat suppression or redistribution
- Mass reduction or offloading effects

### Constraint

- Always introduces a compensating cost or future inefficiency

---

# Replay-Ability

Replayability is not content repetition. It is systemic re-entry into unstable
optimization spaces.

## Recovery Loop (Core Replay Structure)

Upon death or extraction failure:

- All equipment and inventory remain at death location
- Player must re-enter zone to recover assets
- Loss scales with distance and instability exposure

### Effect

Creates spatial memory pressure and route optimization repetition.

---

## Run Variation System

Each run differs through:

- Slime distribution variance
- Instability Phase timing shifts
- Resource node relocation
- Heat accumulation pacing differences
- Player build evolution (Suit Cores / Shards)

---

## Mastery Loop

Long-term replay structure is driven by:

1. Enter unstable system (Mine / Lab / Terrain chain)
2. Execute extraction under constraint pressure
3. Fail or succeed under Heat / Energy / Mass limits
4. Recover or optimize route knowledge
5. Return to Hub/Lab for system modification
6. Re-enter at higher efficiency threshold

---

## Farming Loop Emergence (Mines)

Mines develop semi-persistent player familiarity:

- Resource clusters remain semi-consistent
- Enemy density patterns become learnable
- Players form repeatable extraction routes
- Efficiency increases through memorization under instability

This creates _structured farming identity inside unstable systems_.

# Development Roadmap

## Prototype

- Core player systems only
- Movement (mass/energy), melee siphoning, Overdrive, basic Heat
- One ranged weapon, one melee weapon, one Slime type, simple Instability cycle
- Death + resource drop/recovery
- **Goal:** Validate tense 5-minute systemic loop

## Vertical Slice

- Fully tuned player loop (sprint, flashlight, combat)
- 2 Slime types
- One Lab zone + Terrain segment
- Basic Hub (recharge only)
- Minimal progression (1-2 Suit Cores)
- **Goal:** Complete, polished 15-minute run showing core identity

## Alpha

- Mines zone with mixed Slimes
- All 6 Slime types + full Instability Phase
- Drone added (start with Loot + Wait modes)
- Basic recovery loop + multiple Labs
- Expanded Suit Cores and Weapon Shards
- **Goal:** End-to-end playable build with meaningful tradeoffs

## MVP

- Full Drone (all modes + Transit)
- Hub upgrades and crafting
- 3-4 connected zones with repeatable routes
- Polish, balance, and basic UI
- **Goal:** Minimum shippable version with strong replayability
