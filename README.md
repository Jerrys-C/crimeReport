# Realistic NPC Crime Report

## Features

- Native game event support (such as fights, gunshots, reckless driving, carjacking, etc.).
- No need for continuous loops, events are triggered by in-game actions.
- Valid witness checks to ensure accurate reports.
- Special event logic checks to prevent unnecessary reports.
- NPC phone call to report to the police with corresponding animation, which can be interrupted to cancel the report.

## Dependency
- ox_lib

## Compatibility
- ESX
- QBCore (Not tested)
- QBX
- To adapt to other frameworks, simply modify function getPlayerJob().

## Requirements
- The Dispatch part must be implemented by yourself.
- Fivemanage: To capture screenshots during crimes, ensure that setr screenshot_basic_api_token is properly set in your server configuration.

## Built-in Supported Dispatch System

- rcore_dispatch
- origen_police (Integrated by [IOxee](https://github.com/IOxee))

## Credits
- Based on modifications and development from y_dispatch[https://github.com/TonybynMp4/y_dispatch].
