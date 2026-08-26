# Final Fantasy VI Worlds Collide EmoTracker package

An EmoTracker Community package for FF6 Worlds Collide, with SNI/NWA memory
auto-tracking, a running completed-check counter, and a major-check world map.

The initial item selection and layout are based on Eatitup_86's FF6WC tracker.
RAM addresses and auto-tracking behavior were adapted from Llisandur's
MIT-licensed FF6 Worlds Collide PopTracker pack.

## Check counter

`CheckCounter` displays only the current completed-check count. Toggle checks
contribute one when active. Every completed stage of a progressive check
contributes one. Character and esper acquisition totals do not contribute;
defeated dragons do because each dragon is a completed check. The counter
updates after manual item changes as well as memory reads.

## Auto-tracking

The package declares both `sni` and `nwa` providers. Its Lua watches SNES WRAM
in the `$7E:xxxx` address space.

Phoenix Cave is represented as one major check. Its Red Dragon is counted
separately by the progressive dragon counter.

Narshe Moogle Defense is represented as a Mog-gated major check and is
auto-tracked from WRAM address `$7E1EA5`, mask `$40`.

Final Kefka is auto-tracked from the Ultros League battle signature: battle
index 514 at `$7E11E0` together with sound effect 227 at `$7EE9E9`. Because
that signature is transient, the tracker polls it rapidly and latches the
Kefka check once observed.

All eight dragons are individually auto-tracked and hosted at their physical
map locations. Checks sharing a place are stacked into a single marker, such
as the four WoR Narshe checks, Mt. Zozo plus Storm Dragon, and Kefka's Tower
with Atma Weapon, Gold Dragon, and Skull Dragon.

## Map tracker

The default vertical layout places the combined World of Balance and World of
Ruin map on top. Below it is a responsive two-column panel: acquired-character
portraits with character/esper/dragon/check totals underneath on the left, and
the compact major-check grid on the right. Both lower containers span the full
design width and scale their contents to fill their allocated columns. The
lower panel scales with the available window size, and the root layout has no
fixed pixel dimensions, so
shrinking the window scales its contents instead of clipping them. Map markers
host the same item objects as the grid, so
manual or auto-tracked changes remain synchronized in both views. The map
contains major checks only; treasure locations are not yet included. Major
checks are character-gated and do not become accessible/green until their
associated acquired-character portrait is active. Ungated checks remain
available without a character.

## License and attribution

Auto-tracking logic and the imported image set are derived from
Llisandur/FF6-Worlds-Collide-PopTracker-pack under the MIT License. See
`LICENSE` and `THIRD_PARTY_NOTICES.md`.
