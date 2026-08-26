# Final Fantasy VI Worlds Collide By Zellydev Games

Final Fantasy VI Worlds Collide By Zellydev Games is an EmoTracker Community
package for FF6 Worlds Collide, with SNI/NWA memory auto-tracking, a running
completed-check counter, and a major-check world map.

The initial item selection and layout are based on
[Eatitup_86's FF6WC EmoTracker](https://github.com/Eatitup86/emotracker).
RAM addresses and auto-tracking behavior were adapted from
[Llisandur's FF6 Worlds Collide PopTracker pack](https://github.com/Llisandur/FF6-Worlds-Collide-PopTracker-pack),
which is MIT-licensed.

## Installing an unpublished build

Builds that are not yet published through an EmoTracker package repository can
be installed manually:

1. Download the package ZIP from this project's
   [GitHub Releases page](https://github.com/ZellyDev-Games/emotracker-pack-ff6wc/releases).
   You only need the zip file, not the source.
2. Close EmoTracker.
3. Copy the package ZIP, without extracting it, into the `packs` directory
   inside your EmoTracker user directory. EmoTracker commonly uses
   `Documents/EmoTracker/packs`; if that does not exist, check the platform's
   application-data directory for `EmoTracker/packs`.
4. Remove or move aside any older manually installed ZIP for this package.
   Multiple archives with the same package UID can cause EmoTracker to load the
   wrong build.
5. Start EmoTracker again so it rescans the installed packages.
6. Open **Installed Packages**, expand **Final Fantasy VI**, select
   **Final Fantasy VI Worlds Collide By Zellydev Games**, and choose either
   **Map Tracker** or **Gated Tracker**.

For development, the unpacked project directory may be placed in the same
`packs` directory instead of a ZIP. The directory itself must contain
`manifest.json` at its top level. Restart EmoTracker after replacing files.

## Check counter

The chest counter is now replaced with a check counter to better suit the competitive rulesets.  It still uses the old chest icon.

## Auto-tracking

The package declares both `sni` and `nwa` providers.

Final Kefka check has been added (it becomes available when you meet the conditions of the ruleset) and is auto-tracked when he is defeated.

## Layouts

A gated tracker that shows only characters, checks, dragons, and totals is available as well as a map tracker which shows available locations based on what characters you have.

## License and attribution

Auto-tracking logic and the imported image set are derived from
Llisandur/FF6-Worlds-Collide-PopTracker-pack under the MIT License. See
`LICENSE` and `THIRD_PARTY_NOTICES.md`.
