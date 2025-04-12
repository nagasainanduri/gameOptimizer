# Game Optimizer Script

A Windows batch script designed to optimize your system for gaming by managing system resources and prioritizing your game processes.

## Overview

This script automatically optimizes your Windows environment for gaming by:
- Setting your game process to high priority
- Clearing RAM cache
- Closing resource-intensive background applications
- Temporarily stopping non-essential Windows services
- Optimizing network settings for your game

When you exit your game, the script automatically restores your system to its original state.

## Requirements

- Windows operating system
- Administrator privileges
- Basic knowledge of editing batch files

## Installation

1. Download or clone the `script.bat` file
2. Right-click the file and select "Edit" to customize it for your specific game
3. Update the following variables:
   ```batch
   set "GAME_PATH=path_of_your_exe_file"  (e.g., C:\Games\MyGame\game.exe)
   set "GAME_EXE=name_of_your_exe"        (e.g., game.exe)
   ```

## Usage

### Method 1: Run Before Starting Your Game
1. Right-click on the script and select "Run as administrator"
2. The script will start your game with optimized settings
3. Keep the script window open while gaming
4. When you exit the game, the script will detect this and restore your system settings

### Method 2: Optimize an Already Running Game
1. Start your game normally
2. Right-click on the script and select "Run as administrator"
3. When prompted, choose 'Y' to optimize the running instance
4. Keep the script window open while gaming
5. When you exit the game, the script will detect this and restore your system settings

## What This Script Modifies

### Temporary Changes (Restored When Game Exits)
- Process priority for your game
- System RAM cache
- Background processes (closes specified applications)
- Windows services (temporarily stops SysMain, Windows Update, DiagTrack, Windows Search)
- Network interface weighting/QoS

## Pros

- **One-Click Optimization**: Automates multiple optimization techniques
- **Automated Restoration**: Automatically returns your system to normal when you finish gaming
- **Configurable**: Can be easily customized to your specific needs
- **No Permanent Changes**: Makes only temporary modifications to your system
- **Process Monitoring**: Actively monitors your game and restores settings when it closes
- **No Additional Software**: Uses only built-in Windows commands

## Cons

- **Requires Administrator Rights**: Must be run with elevated privileges
- **Potential Application Disruption**: Forcibly closes specified background applications
- **Service Disruption**: Temporarily disables some Windows services
- **Manual Configuration Required**: Game path and executable must be manually specified
- **Must Remain Open**: The command window must stay open while gaming
- **Limited Compatibility**: Designed for Windows systems only
- **May Conflict with Other Optimization Tools**: Could interfere with similar software

## Background Processes Closed

The script will forcibly close the following applications in this script:
- OneDrive
- Google Drive
- Chrome
- Microsoft Edge
- Firefox

You can customize this list by editing the script.

## Services Temporarily Stopped

The script temporarily stops these Windows services:
- SysMain (Superfetch)
- Windows Update
- DiagTrack (Connected User Experiences and Telemetry)
- WSearch (Windows Search)

## Customization

You can customize the script by:
1. Adding or removing background processes to close
2. Modifying which services are stopped
3. Changing the process priority (256 = HIGH)

## Troubleshooting

- **"Game executable not found"**: Verify the GAME_PATH variable is correctly set
- **"This script requires administrator privileges"**: Right-click and select "Run as administrator"
- **"Could not find the game process"**: Ensure the GAME_EXE variable matches exactly with what appears in Task Manager

## Disclaimer

This script modifies system settings and forcibly terminates processes. Use at your own risk. The author is not responsible for any potential data loss or system instability that may occur.
Feel free to fork this repository to make any changes !!
