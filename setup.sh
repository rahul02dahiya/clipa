#!/bin/bash

TARGET_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$TARGET_DIR"
mkdir -p "$AUTOSTART_DIR"

echo "Welcome to the Clipa Setup Installer"

# SYSTEM DEPENDENCY CHECK
echo "Checking system dependencies..."

# Determine needed tools based on active display server environment
if [ -n "$WAYLAND_DISPLAY" ]; then
    REQUIRED_TOOLS=("rofi" "wl-copy" "wl-paste")
    INSTALL_CMD="sudo apt update && sudo apt install -y rofi wl-clipboard"
else
    REQUIRED_TOOLS=("rofi" "xclip")
    INSTALL_CMD="sudo apt update && sudo apt install -y rofi xclip"
fi

MISSING_TOOLS=()
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

# If there are missing system tools, print the exact command and exit
if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo "Error: The following required tools are missing: ${MISSING_TOOLS[*]}"
    echo "-------------------------------------------------------"
    echo "Please copy and run the following command to fix this:"
    echo "   $INSTALL_CMD"
    echo "-------------------------------------------------------"
    exit 1
else
    echo "All core system dependencies are satisfied."
fi

# DEPLOYMENT ENGINE SETUP
echo "Deploying components to local user space..."
cp clipa-monitor "$TARGET_DIR/clipa-monitor"
cp clipa-menu "$TARGET_DIR/clipa-menu"

chmod +x "$TARGET_DIR/clipa-monitor"
chmod +x "$TARGET_DIR/clipa-menu"

# Dynamically link execution profiles if path environment is missing
if [[ :$PATH: != *:"$HOME/.local/bin":* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    echo "System PATH updated. Please run 'source ~/.bashrc' after installation!"
fi

# Generate the background execution loader desktop entry
echo "Configuring background startup manager..."
cat <<EOF > "$AUTOSTART_DIR/clipa-monitor.desktop"
[Desktop Entry]
Type=Application
Exec=$TARGET_DIR/clipa-monitor
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Clipa Monitor
Comment=Lightweight cross-platform clipboard engine
EOF

echo "-------------------------------------------------------"
echo "Clipa Local Components Configured Successfully"
echo "Ubuntu/Wayland Environment: Setup is 100% complete."
echo "Kali/X11 Environment: Place your pre-compiled 'clipnotify' binary in: $TARGET_DIR/"
echo "-------------------------------------------------------"
echo "1. Run: source ~/.bashrc"
echo "2. Launch the daemon instantly by running: clipa-monitor &"
echo "3. Bind the command 'clipa-menu' to your [Super + V] keyboard shortcut settings."
