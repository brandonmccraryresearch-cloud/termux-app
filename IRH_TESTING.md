# IRH Implementation Testing Guide

This document provides testing instructions for the Intrinsic Resonance Holography (IRH) modifications to the Termux app.

## Prerequisites

- Android device or emulator running Android 7.0 or higher
- Android SDK and build tools installed
- Ability to build and install the modified Termux APK

## Building the Modified APK

### Debug Build
```bash
cd termux-app
./gradlew assembleDebug
```

The APK will be in: `app/build/outputs/apk/debug/`

### Release Build
```bash
cd termux-app
./gradlew assembleRelease
```

The APK will be in: `app/build/outputs/apk/release/`

## Test Plan

### Test 1: Clean Installation
**Purpose:** Verify IRH setup runs automatically on first launch

**Steps:**
1. Completely uninstall any existing Termux installation
2. Install the modified Termux APK
3. Launch the app
4. Wait for bootstrap installation to complete
5. Open a terminal session

**Expected Results:**
- Bootstrap completes successfully
- Terminal session starts
- IRH setup script runs automatically
- Progress messages display for each phase:
  - [1/5] Updating package lists
  - [2/5] Installing Python and system dependencies
  - [3/5] Upgrading pip
  - [4/5] Installing IRH Python packages
  - [5/5] Setting up IRH project structure
- Setup completion message appears
- User prompted to restart Termux

**Verification:**
```bash
# Check IRH setup marker
ls -la ~/.irh_setup_complete

# Check IRH setup script
ls -la ~/.irh_setup.sh

# Check bash profile
cat ~/.bash_profile | grep -A 5 "IRH"

# Check workspace
ls -la ~/irh-workspace

# Check demo script
test -x ~/irh-workspace/irh_demo.py && echo "Demo script exists and is executable"
```

### Test 2: IRH Welcome Message
**Purpose:** Verify welcome message displays on subsequent launches

**Steps:**
1. After Test 1 completes, close and reopen Termux
2. Start a new terminal session

**Expected Results:**
- IRH welcome message displays automatically
- Message shows:
  - IRH title banner
  - List of installed packages
  - Workspace location
  - Usage instructions

**Verification:**
```bash
# Check welcome marker
ls -la ~/.irh_welcome_shown

# Manually trigger welcome
python ~/irh-workspace/irh_demo.py
```

### Test 3: IRH Environment Variables
**Purpose:** Verify environment is configured correctly

**Steps:**
1. Open a terminal session
2. Check environment variables

**Expected Results:**
```bash
echo $IRH_HOME          # Should show: /data/data/com.termux/files/home/irh-workspace
echo $IRH_VERSION       # Should show: 1.0.0
```

### Test 4: IRH Aliases
**Purpose:** Verify aliases work correctly

**Steps:**
1. Open a terminal session
2. Test each alias

**Expected Results:**
```bash
# Test irh alias
irh
# Should navigate to workspace and show welcome message

# Test irh-demo alias
irh-demo
# Should run demonstration showing:
# - Matrix operations
# - Signal processing
# - Statistical analysis
```

### Test 5: Python Packages
**Purpose:** Verify all required packages are installed

**Steps:**
1. Open a terminal session
2. Test package imports

**Expected Results:**
```bash
python -c "import numpy; print('NumPy:', numpy.__version__)"
python -c "import scipy; print('SciPy:', scipy.__version__)"
python -c "import matplotlib; print('Matplotlib:', matplotlib.__version__)"
python -c "import pandas; print('Pandas:', pandas.__version__)"
python -c "import sklearn; print('Scikit-learn:', sklearn.__version__)"
python -c "import PIL; print('Pillow:', PIL.__version__)"
```

All imports should succeed and display version numbers.

### Test 6: Demo Script Functionality
**Purpose:** Verify demo script works correctly

**Steps:**
1. Run the demo script with different options

**Expected Results:**
```bash
# Display welcome
python ~/irh-workspace/irh_demo.py
# Should show welcome message

# Run demo
python ~/irh-workspace/irh_demo.py --demo
# Should display:
# - Matrix operations with determinant
# - Signal processing with sine wave
# - Statistical analysis with mean and std dev
```

### Test 7: Error Handling
**Purpose:** Verify app doesn't crash if IRH setup fails

**Steps:**
1. Create a scenario where IRH setup might fail (e.g., no network)
2. Install and launch the app

**Expected Results:**
- Bootstrap completes successfully
- App remains functional even if IRH setup fails
- Error logged but app doesn't crash
- User can still use Termux normally

**Verification:**
```bash
# Check logs
logcat | grep -i "IRH\|TermuxInstaller"
```

### Test 8: Reinstallation
**Purpose:** Verify IRH setup doesn't run on reinstall if already complete

**Steps:**
1. After IRH setup completes once, reinstall the app (keeping data)
2. Launch the app

**Expected Results:**
- IRH setup does not run again
- Existing IRH environment remains intact
- `.irh_setup_complete` marker prevents re-run

### Test 9: Manual Setup Trigger
**Purpose:** Verify manual setup execution works

**Steps:**
1. Remove the setup complete marker
2. Manually run the setup script

**Expected Results:**
```bash
rm ~/.irh_setup_complete
bash ~/.irh_setup.sh
# Setup should run successfully
```

### Test 10: File Permissions
**Purpose:** Verify all files have correct permissions

**Steps:**
1. After setup, check file permissions

**Expected Results:**
```bash
# Setup script should be executable
ls -la ~/.irh_setup.sh
# Should show: -rwx------

# Demo script should be executable
ls -la ~/irh-workspace/irh_demo.py
# Should show: -rwxr-xr-x or similar

# Bash profile should be readable/writable
ls -la ~/.bash_profile
# Should show: -rw-------
```

## Automated Testing Script

Save as `test_irh.sh`:

```bash
#!/bin/bash
# IRH Testing Script

echo "=== IRH Installation Test Suite ==="
echo ""

FAILED=0

# Test 1: Check setup script exists
if [ -f ~/.irh_setup.sh ]; then
    echo "✓ Setup script exists"
else
    echo "✗ Setup script missing"
    FAILED=$((FAILED + 1))
fi

# Test 2: Check setup complete marker
if [ -f ~/.irh_setup_complete ]; then
    echo "✓ Setup completed"
else
    echo "✗ Setup not completed"
    FAILED=$((FAILED + 1))
fi

# Test 3: Check workspace
if [ -d ~/irh-workspace ]; then
    echo "✓ Workspace exists"
else
    echo "✗ Workspace missing"
    FAILED=$((FAILED + 1))
fi

# Test 4: Check demo script
if [ -x ~/irh-workspace/irh_demo.py ]; then
    echo "✓ Demo script exists and executable"
else
    echo "✗ Demo script missing or not executable"
    FAILED=$((FAILED + 1))
fi

# Test 5: Check environment variables
if [ -n "$IRH_HOME" ]; then
    echo "✓ IRH_HOME is set: $IRH_HOME"
else
    echo "✗ IRH_HOME not set"
    FAILED=$((FAILED + 1))
fi

if [ -n "$IRH_VERSION" ]; then
    echo "✓ IRH_VERSION is set: $IRH_VERSION"
else
    echo "✗ IRH_VERSION not set"
    FAILED=$((FAILED + 1))
fi

# Test 6: Check Python packages
echo ""
echo "Checking Python packages..."
python -c "import numpy" 2>/dev/null && echo "✓ NumPy" || { echo "✗ NumPy"; FAILED=$((FAILED + 1)); }
python -c "import scipy" 2>/dev/null && echo "✓ SciPy" || { echo "✗ SciPy"; FAILED=$((FAILED + 1)); }
python -c "import matplotlib" 2>/dev/null && echo "✓ Matplotlib" || { echo "✗ Matplotlib"; FAILED=$((FAILED + 1)); }
python -c "import pandas" 2>/dev/null && echo "✓ Pandas" || { echo "✗ Pandas"; FAILED=$((FAILED + 1)); }
python -c "import sklearn" 2>/dev/null && echo "✓ Scikit-learn" || { echo "✗ Scikit-learn"; FAILED=$((FAILED + 1)); }
python -c "import PIL" 2>/dev/null && echo "✓ Pillow" || { echo "✗ Pillow"; FAILED=$((FAILED + 1)); }

echo ""
if [ $FAILED -eq 0 ]; then
    echo "=== All tests passed! ==="
    exit 0
else
    echo "=== $FAILED test(s) failed ==="
    exit 1
fi
```

## Performance Testing

### Installation Time
- Measure time from app launch to IRH setup completion
- Expected: 5-15 minutes (varies by device and network)

### Storage Usage
- Check storage before and after IRH setup
- Expected increase: ~300-500 MB

```bash
# Check storage
df -h $PREFIX
du -sh ~/irh-workspace
du -sh ~/.local/lib/python*/site-packages
```

### Memory Usage
- Monitor memory during package installation
- Use Android Studio Profiler or `top` command

## Troubleshooting Common Issues

### Issue: Setup script doesn't run
**Check:**
- Verify `.bash_profile` exists and contains IRH trigger
- Check if `.irh_setup_complete` exists (prevents re-run)
- Run manually: `bash ~/.irh_setup.sh`

### Issue: Package installation fails
**Check:**
- Network connectivity
- Available storage space
- Repository accessibility: `apt update`
- Python installation: `which python`

### Issue: Demo script doesn't work
**Check:**
- Python installation: `python --version`
- Script permissions: `ls -la ~/irh-workspace/irh_demo.py`
- Package imports: `python -c "import numpy"`

### Issue: Environment variables not set
**Check:**
- `.bashrc` contains IRH section
- Current shell is bash: `echo $SHELL`
- Source bashrc: `source ~/.bashrc`

## Reporting Test Results

When reporting test results, include:

1. Device information
   - Device model
   - Android version
   - Available storage

2. Test results
   - Which tests passed/failed
   - Error messages encountered
   - Screenshots if relevant

3. Timing information
   - Bootstrap installation time
   - IRH setup time
   - Total time to ready state

4. Logs
   - Relevant logcat output
   - Setup script output
   - Any error messages

## Continuous Integration

For CI/CD pipelines, consider:

1. Automated APK building
2. Emulator testing with various Android versions
3. Static code analysis (linters)
4. Resource validation
5. Build verification

Example GitHub Actions workflow structure:
```yaml
- name: Build APK
  run: ./gradlew assembleDebug

- name: Start Emulator
  uses: reactivecircus/android-emulator-runner@v2
  
- name: Install and Test
  run: |
    adb install app/build/outputs/apk/debug/*.apk
    # Run automated tests
```

## Conclusion

Thorough testing ensures the IRH modifications work correctly across different devices and scenarios. Follow this guide to verify all functionality before releasing to users.
