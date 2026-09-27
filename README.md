# Clipa

Clipa is a lightweight, resource-efficient clipboard history manager designed for Linux environments. It brings a persistent multi-copy experience similar to the "Windows + V" shortcut to your Linux desktop. 

The project features a dual-engine design optimized to work efficiently across both modern Wayland and classic X11 display servers with minimal memory and CPU footprints.

## Features

* **Multi-Line Support**: Seamlessly captures paragraphs and code snippets, preserving original formatting and structural spacing.
* **Dual Display Server Support**: Utilizes zero-latency native event listeners on Wayland and event-driven triggers via [clipnotify](https://github.com/cdown/clipnotify) on X11.
* **Searchable UI Interface**: Leverages [rofi](https://github.com/davatorium/rofi) for an instantaneous, text-filtered popup interface.
* **History Management**: Includes a secure clear-history pipeline triggered by a custom keybinding (`Alt + c`) with built-in confirmation toggles.
* **Non-Root Execution**: Installs directly into the user space directory (`~/.local/bin/`), avoiding unwanted global system pollution.

## Directory Structure

Ensure your local repository contains the following files before launching the installation process:

```text
├── clipa-monitor   # Background clipboard event listener daemon
├── clipa-menu      # Graphical search and selection interface
└── setup.sh        # Deployment script
```

## Prerequisites

Clipa relies on minimal native tools depending on your display platform:
* **Wayland**: [rofi](https://github.com/davatorium/rofi), [wl-clipboard](https://github.com/bugaevc/wl-clipboard)
* **X11 / Xorg**: [rofi](https://github.com/davatorium/rofi), [xclip](https://github.com/astrand/xclip), [clipnotify](https://github.com/cdown/clipnotify)

The `setup.sh` installer automatically analyzes your system architecture, verifies present configurations, and outputs the precise instructions if any baseline tool is missing.

## Installation

1. Clone or copy the project files to a local directory.
2. Grant execution privileges to the installer script:
   ```bash
   chmod +x setup.sh
   ```
3. Run the installer script:
   ```bash
   ./setup.sh
   ```
4. Refresh your environment variable profile paths:
   ```bash
   source ~/.bashrc
   ```

*Note for Wayland environments (e.g., Ubuntu 22.04): Setup is fully complete at this point.*
*Note for X11 environments (e.g., Kali Linux): You must compile and deploy [clipnotify](https://github.com/cdown/clipnotify) into your execution path using one of the guides below.*

---

## Clipnotify Compilation Guide (X11 Environments)

[clipnotify](https://github.com/cdown/clipnotify) is a specialized utility that hooks directly into the low-level X11 `XFixes` framework. This ensures the background script rests at 0% CPU utilization until a copy event fires. Because it is absent from standard package managers, select one of the compilation options below based on your permission constraints.

### Method A: Native Installation (Requires Sudo Access)

If you have root administrative access on the host operating system, you can compile and register the binary globally across the machine:

1. Update package indices and pull the developer toolchains alongside X11 library header extensions:
   ```bash
   sudo apt update && sudo apt install -y build-essential libx11-dev libxtst-dev git
   ```
2. Fetch the latest utility codebase from source control:
   ```bash
   git clone https://github.com/cdown/clipnotify.git
   ```
3. Navigate into the directory and invoke the compiler engine:
   ```bash
   cd clipnotify
   make
   ```
4. Move the finished binary structure into system application spaces globally:
   ```bash
   sudo make install
   ```
5. Confirm the system pathways resolve the application correctly:
   ```bash
   which clipnotify
   ```
   *Expected output: `/usr/local/bin/clipnotify` or `/usr/bin/clipnotify`*

### Method B: Portable User Space Installation (No Sudo Access)

If you are operating in a restricted user workspace without root credentials, you can pull the raw source file directly and compile it locally within your personal scope using standard `gcc`:

1. Ensure the system administrator has previously installed `gcc` and the X11 expansion headers (`libx11-dev`, `libxtst-dev`).
2. Fetch the latest utility codebase from source control:
   ```bash
   git clone https://github.com/cdown/clipnotify.git
   ```
3. Navigate into the directory:
   ```bash
   cd clipnotify
   ```
4. Execute `gcc` manually, explicitly linking the compiler outputs to your local architecture frameworks:
   ```bash
   gcc clipnotify.c -o clipnotify -lX11 -lXfixes
   ```
5. Deploy the compiled portable binary file straight into your local user execution directory:
   ```bash
   cp clipnotify ~/.local/bin/
   chmod +x ~/.local/bin/clipnotify
   ```
---

## System Configuration & Keybindings

To emulate the "Windows + V" clipboard menu deployment exactly, assign the execution sequence to your global desktop hotkeys:

### XFCE Desktop Integration (Default Kali Linux)
1. Navigate to **Applications** -> **Settings** -> **Keyboard**.
2. Select the **Application Shortcuts** tab and click **Add**.
3. Set the Command target field explicitly to: `clipa-menu`
4. Click **OK** and assign your physical key stroke combination trigger by pressing **`Super Key + V`** (registers visually as `Super+V` or `Mod4+V`).

### GNOME Desktop Integration (Default Ubuntu)
1. Open system **Settings** and head to **Keyboard** -> **Keyboard Shortcuts** -> **View and Customise Shortcuts**.
2. Select **Custom Shortcuts** at the bottom and click the add option.
3. Input the parameters manually:
   * **Name**: Clipa Menu
   * **Command**: clipa-menu
   * **Shortcut**: `Super + V`
