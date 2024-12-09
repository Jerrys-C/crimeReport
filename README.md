# Realistic NPC Crime Report

## Features

- Native game event support (such as fights, gunshots, reckless driving, carjacking, etc.).
- No need for continuous loops, events are triggered by in-game actions.
- Valid witness checks to ensure accurate reports.
- Special event logic checks to prevent unnecessary reports.
- Currently integrated dispatch support: rcore_dispatch.

## Dependency
- ox_lib

## Compatibility
- ESX
- QBCore (Not tested)
- QBX

## Requirements
- The Dispatch part must be implemented by yourself.
- Fivemanage: To capture screenshots during crimes, ensure that setr screenshot_basic_api_token is properly set in your server configuration.

## Built-in Supported Dispatch System

- rcore_dispatch

## Player Job Integration

- Currently, Qbox is used to get the player's job information.
- To adapt to other frameworks, simply modify function getPlayerJob().

## Credits
- Based on modifications and development from y_dispatch[https://github.com/TonybynMp4/y_dispatch].
