# Game Design

## High-level concept

Genre: 2D action-platformer roguelite with procedural castles (rooms/biomes), permadeath per run, and meta-progression between runs (heir system + upgrades).

Tone: Challenging, fast-paced, with short runs and long-term growth.

Hook: Each death spawns an heir with one or more randomized traits (positive/negative) that affect gameplay and flavor text.


## Player stats(base) depended on class
| MC stats       | Knight | Barbarian | Archer | Rogue |
| -------------- | ------ | --------- | ------ | ----- |
| HP             | 3      | 4         | 2.5    | 2.5   |
| Speed          | 4.5    | 4         | 5      | 4.5   |
| Mana           | 10     | 6         | 12     | 8     |
| Damage         | 20     | 28        | 20     | 15    |
| Atk.speed      | 1.25   | 1.15      | 1.1    | 1.1   |
| Crit.chance(%) | 5      | 1         | 12     | 18    |


## Status effects

Poison (tick dmg/sec), Burn, Freeze (slow), Stun (time), Knockback (force).


## Rules

Permadeath removes current character, but gold and certain upgrades are kept.

Heirs: get 1–3 traits (see sample list) that modify attributes or add mechanics.

Items: equipment slots (weapon, armor, accessory1, accessory2). Some items are temporary (found in run); others are relics (persist).

## Heir traits system
W.I.P


## Meta-progression categories

House Upgrades (permanent): Sword Smith (+damage), Library (+XP gain), Armory (+armor), Chapel (+HP cap), Vault (+gold cap).

Skill Tree: unlocked talents (double-jump, dash, charge).


## Procedural generation rules (castle)

Chunks/rooms built from a finite set of templates (combat, trap, puzzle, merchant, treasure).

Flow rules: 6–12 rooms per floor, 3–4 floors per run, boss at end.

Difficulty curve: enemies scale by floor number
