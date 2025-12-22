# Intrinsic Resonance Holography (IRH) Modifications

This document describes the modifications made to the Termux app to support the Intrinsic Resonance Holography project.

## Overview

The Termux app has been modified to automatically install and configure a complete Python environment with IRH-related packages upon first installation. This provides users with a ready-to-use console for the brandonmccraryresearch-cloud/Intrinsic_Resonance_Holograpy project without requiring any manual setup.

## Modifications Made

### 1. IRH Setup Script (`app/src/main/res/raw/irh_setup.sh`)

A comprehensive bash script that:
- Updates package repositories
- Installs Python and essential system dependencies (git, clang, make, pkg-config, libffi, openssl)
- Installs Python packages:
  - numpy (numerical computing)
  - scipy (scientific computing)
  - matplotlib (plotting)
  - pandas (data analysis)
  - scikit-learn (machine learning)
  - pillow (image processing)
- Creates an IRH workspace directory (`~/irh-workspace`)
- Generates a demo Python script (`irh_demo.py`) showcasing IRH capabilities
- Configures bash environment with IRH-specific aliases and variables
- Displays a welcome message on first login

### 2. Modified TermuxInstaller.java

Updated the bootstrap installation process to:
- Copy the IRH setup script to the Termux home directory (`.irh_setup.sh`)
- Create a `.bash_profile` trigger that automatically runs the setup on first terminal session
- Set proper executable permissions on the setup script
- Log installation progress

#### Key Changes:
- Added `installIRHSetupScript()` method to handle IRH setup script installation
- Modified bootstrap installation flow to call IRH setup after standard bootstrap completion
- Added proper error handling (failures in IRH setup don't prevent app from functioning)

## User Experience

### First Launch
1. User installs and opens the Termux app
2. Standard bootstrap packages install automatically
3. On first terminal session, the IRH setup script runs automatically:
   - Displays progress for each installation phase
   - Shows a completion message when finished
4. User is prompted to restart Termux to load the new environment

### Subsequent Launches
- IRH welcome message displays automatically
- Quick-access aliases available:
  - `irh` - Navigate to workspace and show welcome
  - `irh-demo` - Run capability demonstration

### IRH Environment Variables
- `IRH_HOME` - Path to IRH workspace (`~/irh-workspace`)
- `IRH_VERSION` - Current IRH environment version

## IRH Demo Script

The included `irh_demo.py` script provides:
- Welcome message with installed packages list
- Demonstration of capabilities:
  - Matrix operations using NumPy
  - Signal processing basics
  - Statistical analysis

Usage:
```bash
python ~/irh-workspace/irh_demo.py          # Display welcome
python ~/irh-workspace/irh_demo.py --demo   # Run demo
```

## File Structure

```
termux-app/
├── app/src/main/
│   ├── res/raw/
│   │   └── irh_setup.sh              # IRH setup script
│   └── java/com/termux/app/
│       └── TermuxInstaller.java      # Modified bootstrap installer
└── IRH_MODIFICATIONS.md              # This file
```

## Installation Notes

- The IRH setup is non-blocking - if it fails, the app still functions normally
- Setup only runs once (tracked by `~/.irh_setup_complete` marker file)
- All packages are installed via official Termux repositories and PyPI
- Total installation time depends on device and network speed (typically 5-15 minutes)
- Required storage: approximately 300-500 MB for Python packages

## Customization

To modify the IRH setup:

1. Edit `app/src/main/res/raw/irh_setup.sh` to add/remove packages
2. Update the Python demo script section to customize functionality
3. Rebuild the app to include changes

## Technical Details

### Bootstrap Process Flow
1. Standard Termux bootstrap extraction (unchanged)
2. Environment file creation (unchanged)
3. IRH setup script installation (new)
4. First terminal session triggers IRH package installation
5. Environment configured automatically

### Error Handling
- IRH setup failures are logged but don't prevent app startup
- Users can manually run `~/.irh_setup.sh` if automatic setup fails
- Setup can be re-run by removing `~/.irh_setup_complete` marker file

## Future Enhancements

Potential improvements for future versions:
- Progress indicator during package installation
- Optional IRH setup (user prompt before installation)
- Update mechanism for IRH packages
- Integration with Intrinsic_Resonance_Holograpy repository
- Pre-compiled packages to reduce installation time
- Additional scientific computing packages (SymPy, NetworkX, etc.)

## Troubleshooting

**Setup doesn't run automatically:**
- Check for `~/.irh_setup.sh` file existence
- Verify `.bash_profile` contains IRH trigger code
- Manually run: `bash ~/.irh_setup.sh`

**Package installation fails:**
- Ensure network connectivity
- Check available storage space
- Update repositories: `apt update`
- Try manual installation: `pip install <package>`

**Python not found:**
- Verify bootstrap completed successfully
- Check `$PREFIX/bin/python` exists
- Reinstall: `apt install python`

## Support

For issues related to:
- IRH setup: Contact brandonmccraryresearch-cloud
- Termux app: See main README.md
- Python packages: Refer to respective package documentation
