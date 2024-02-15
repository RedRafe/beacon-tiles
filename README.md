# Beacon Tiles

Replaces all beacon entities with tiles with the same effects instead

---

# Main features

- Replace all 3x3 vanilla beacons with tiles with the same transmission effects
- *Tile beacons* are 1x1 beacons with 50% module transmission, and consume ~1/9th of regular beacon's power
- Tiles have increased/reduced bonus speed based on the applied module's speed/productivity effects
- Tiles have positive/negative pollution absorption capacity based on the applied module's pollution/consumption effects
- Fully customizable via mod settings: *enable/disable* vanilla beacon restrictions, *enable/disable* placing productivity inside tile beacons

# Balance

- A fully vanilla-beaconed assembler machine receives effects from 12 beacons, 2 modules each, at 50% transmission => 12 x 2 x 0.5 => 12 modules' effects
- A fully tile-beaconed assembler machine receives effects from 25 tiles, 1 module each, at 50% transmission => 25 x 1 x 0.5 => 12.5 modules' effects

**Pros** - it's easier to design fully-beaconed designs (direct insertion, trains, arrays...)
**Cons** - it's harder to tile and share beacon effects, resulting in higher and expensive building costs

![rainbow_tiles](https://assets-mod.factorio.com/assets/be7e9e8d91f4287ebf9f9d6856993159cc672e68.png)

---

# Future development
- add settings for separated item/recipe/tile that includes beacon + tile costs for a tile beacon
- add color support for other modded beacons, based on their effects

# Known bugs & compatibility
- Although compatible with any modded module / beacon outside vanilla, **Beacon Tiles** currently supports specific tile colors for vanilla modules only (default color for unknown modules: brown, their custom effects still apply)
- Please feel free to report any issue on the mod portal page, on GitHub, or over on my Discord.

*Join my [Discord](https://discord.gg/pq6bWs8KTY)*