# Abah's Helper

Addon for a Elder Scrolls: Online that helps speed up the process of farming Abah's Watch motifs.

## Features

- Auto accept `The Covetous Countess` quest
- Auto decline other Tip Board quests
- Skip chatter with Countess and Kari

## TODO

- [x] Open quest reward
- [ ] ~~Interact with Tip Board until correct quest is accepted~~ (not achievable)
- [ ] Abandon `The Covetous Countess` quest if you don't have laundered items
- [x] Don't register chater start callbacks if quest isn't active
- [x] Correctly close Countess' chatter

## Changelog

- 1.1
    - All dialogues are skipped
    - Quest reward is opened upon completion
    - Debug messages won't spam chat anymore
    - Addon listens for conversation open only if `The Covetous Countess` quest is active