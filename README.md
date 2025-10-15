# VolumeLimiter USB Installer Guide

**VolumeLimiter** limits the system-wide audio output to a safe maximum (50%) and installs itself to start automatically with Windows.

This guide explains how to:
- Recreate the installation USB stick for distribution.
- Rebuild the executable for future updates.

---

## Recreate the USB Installer

To create a new installation USB stick for VolumeLimiter:

1. **Format the USB drive**  
   - File system: **FAT32** (recommended)  
   - Volume label: optional

2. **Copy the following folder and files** to the **root** of the USB drive:

The folder named 'finished_build' contains all that is needed for the program to work.
Just copy everything in this folder to the USB so that it looks like this:

```
[USB DRIVE]/
├── Install_VolumeLimiter.bat
├── Uninstall_VolumeLimiter.bat
├── instruktioner.txt
└── InstallationFiles/
    ├── install_volume_limiter.ps1
    ├── uninstall_volume_limiter.ps1
    ├── version_info.txt
    └── volume_limiter.exe
```

3. **Use the installer** on a Windows machine:  
   - Double-click `Install_VolumeLimiter.bat`  
   - The script will automatically request administrator permissions.

After verification, the USB stick is ready for use on other computers.

---

## Rebuilding for Future Development

### 1. Requirements

- **Python 3.11+**
- **PyInstaller**

Install PyInstaller in a virtual environment (recommended):

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install pyinstaller
```

### 2. Build the Executable

From inside the `InstallationFiles` directory:

```powershell
cd InstallationFiles
pyinstaller --onefile --noconsole --version-file version_info.txt volume_limiter.py
```

This creates:

```
InstallationFiles\dist\volume_limiter.exe
```

### 3. Update the Finished Build

Copy the new executable to the distribution folder:

```powershell
Copy-Item .\dist\volume_limiter.exe ..\finished_build\InstallationFiles\ -Force
```

The updated `finished_build` folder can then be copied to a USB stick following the structure above.

---

## Optional: Cleanup Old Build Files

To remove temporary Python build and cache files:

```powershell
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue `
    .venv, "__pycache__", "build", "dist" `
    -Include *.pyc,*.pyo
```

---

## Notes

- Always test the new executable before distributing.  
- Run all `.bat` files as Administrator if prompted.  
- The uninstaller completely removes all files and startup entries.

---


