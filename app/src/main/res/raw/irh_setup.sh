#!/data/data/com.termux/files/usr/bin/bash
# Intrinsic Resonance Holography (IRH) Setup Script
# This script automatically sets up the IRH environment with Python and required packages

set -e

# Log file for troubleshooting
LOG_FILE=~/.irh_setup.log
exec > >(tee -a "$LOG_FILE") 2>&1

echo ""
echo "=========================================="
echo "Intrinsic Resonance Holography Setup"
echo "=========================================="
echo ""
echo "Setup log: $LOG_FILE"
echo ""

# Update package lists
echo "[1/5] Updating package lists..."
if ! apt update -y 2>&1 | grep -v "^Get:"; then
    echo "Warning: apt update had some issues, but continuing..."
fi

# Install Python and required system packages
echo "[2/5] Installing Python and system dependencies..."
if ! apt install -y python python-pip git clang make pkg-config libffi openssl 2>&1 | grep -v "^Selecting" | grep -v "^Preparing" | grep -v "^Unpacking" | grep -v "^Setting up"; then
    echo "Error: Failed to install system packages"
    exit 1
fi

# Upgrade pip
echo "[3/5] Upgrading pip..."
pip install --upgrade pip || {
    echo "Warning: Failed to upgrade pip, continuing with existing version"
}

# Install IRH Python packages
echo "[4/5] Installing IRH Python packages..."
FAILED_PACKAGES=""

install_package() {
    local package=$1
    echo "  - Installing $package..."
    if ! pip install --no-cache-dir "$package" 2>&1 | tail -1; then
        echo "    Warning: Failed to install $package"
        FAILED_PACKAGES="$FAILED_PACKAGES $package"
        return 1
    fi
    return 0
}

install_package "numpy"
install_package "scipy"
install_package "matplotlib"
install_package "pandas"
install_package "scikit-learn"
install_package "pillow"

if [ -n "$FAILED_PACKAGES" ]; then
    echo ""
    echo "Warning: Some packages failed to install:$FAILED_PACKAGES"
    echo "You can try installing them manually later with: pip install <package>"
    echo ""
fi

# Create IRH project directory structure
echo "[5/5] Setting up IRH project structure..."
mkdir -p ~/irh-workspace
cd ~/irh-workspace

# Create a sample IRH script
cat > ~/irh-workspace/irh_demo.py << 'EOFPYTHON'
#!/usr/bin/env python3
"""
Intrinsic Resonance Holography Demo Script
"""
import numpy as np
import sys

def display_welcome():
    """Display IRH welcome message"""
    print("\n" + "="*50)
    print("  Intrinsic Resonance Holography (IRH)")
    print("  Python Environment Ready")
    print("="*50)
    print("\nInstalled packages:")
    print("  - NumPy (numerical computing)")
    print("  - SciPy (scientific computing)")
    print("  - Matplotlib (plotting)")
    print("  - Pandas (data analysis)")
    print("  - Scikit-learn (machine learning)")
    print("  - Pillow (image processing)")
    print("\nWorkspace: ~/irh-workspace")
    print("Demo script: ~/irh-workspace/irh_demo.py")
    print("\nTo get started, run: python ~/irh-workspace/irh_demo.py")
    print("="*50 + "\n")

def demonstrate_capabilities():
    """Demonstrate basic IRH capabilities"""
    print("\n--- IRH Capabilities Demo ---\n")
    
    # Demo 1: Matrix operations
    print("1. Matrix Operations:")
    matrix = np.random.rand(3, 3)
    print(f"   Created random 3x3 matrix")
    print(f"   Determinant: {np.linalg.det(matrix):.4f}\n")
    
    # Demo 2: Signal processing basics
    print("2. Signal Processing:")
    t = np.linspace(0, 1, 1000)
    signal = np.sin(2 * np.pi * 5 * t)
    print(f"   Generated sine wave signal")
    print(f"   Signal length: {len(signal)} samples\n")
    
    # Demo 3: Statistical analysis
    print("3. Statistical Analysis:")
    data = np.random.normal(100, 15, 1000)
    print(f"   Generated normal distribution")
    print(f"   Mean: {np.mean(data):.2f}")
    print(f"   Std Dev: {np.std(data):.2f}\n")

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--demo":
        demonstrate_capabilities()
    else:
        display_welcome()
EOFPYTHON

chmod +x ~/irh-workspace/irh_demo.py

# Create IRH bashrc additions (only if not already present)
if ! grep -q "# IRH Environment" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'EOFBASHRC'

# IRH Environment
export IRH_HOME=~/irh-workspace
export IRH_VERSION="1.0.0"
alias irh='cd $IRH_HOME && python irh_demo.py'
alias irh-demo='python $IRH_HOME/irh_demo.py --demo'

# Display IRH welcome on first login
if [ ! -f ~/.irh_welcome_shown ]; then
    python $IRH_HOME/irh_demo.py
    touch ~/.irh_welcome_shown
fi
EOFBASHRC
    echo "IRH environment configured in .bashrc"
else
    echo "IRH environment already configured in .bashrc (skipping)"
fi

# Create marker file to indicate IRH setup is complete
touch ~/.irh_setup_complete

echo ""
echo "=========================================="
echo "IRH Setup Complete!"
echo "=========================================="
echo ""
echo "The Intrinsic Resonance Holography environment"
echo "has been successfully configured."
echo ""
echo "Please restart Termux to load the environment."
echo ""

exit 0
