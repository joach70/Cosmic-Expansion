# Cosmic-Expansion
Really simple game created in [Godot Game Engine](https://godotengine.org/). It's evolution of this tutorial game [link](https://www.youtube.com/watch?v=QoNukqpolS8) 

---
Work on: 
- [Linux](https://github.com/Chimi70/Cosmic-Expansion?tab=readme-ov-file#linux)
- [Windows](https://github.com/Chimi70/Cosmic-Expansion?tab=readme-ov-file#windows)
- [In Browser](https://github.com/Chimi70/Cosmic-Expansion?tab=readme-ov-file#browser)

## Screenshot
![](./screenshots/Screenshot.png)

## Browser
link: https://chimi70.itch.io/cosmic-expansion

## Linux
### How install 
```
git clone https://github.com/Chimi70/Cosmic-Expansion &&
cd Cosmic-Expansion
echo "#!/usr/bin/bash
./export/0.2/linux/cosmic_expansion.x86_64" > launch.sh &&
chmod +x launch.sh &&
```
### How launch
```
cd &&
Cosmic-Expansion./launch.sh
```
### How Update to the newest version
```
cd &&
sudo rm -r Cosmic-Expansion
git clone https://github.com/Chimi70/Cosmic-Expansion &&
echo "#!/usr/bin/bash
./export/0.2/linux/cosmic_expansion.x86_64" > launch.sh &&
chmod +x launch.sh &&
```
### How uninstall
```
cd &&
sudo rm -r Cosmic-Expansion
```
## Windows
### How install (using PowerShell)
-  Install git
```
winget install --id Git.Git -e --source winget
```
-  Reopen PowerShell
-  Go to Documents
```
cd C:\Users\YourUsername\Documents
```
-  Clone repo
```
git clone https://github.com/Chimi70/Cosmic-Expansion
```

### How install (without PowerShell)
- Download project (at the top of this page is green button "<>Code" click it then click "Download ZIP)
- Unpack zip
- In export directory is "win" directory, then click newest version, then click "Cosmic Expansion.exe"
### How launch (cml)
```
cd Documents\Cosmic-Expansion\export\0.2\win
.\cosmic_expansion.exe
```
### How Update to the newest version (cml)
```
cd C:\Users\YourUsername\Documents &
rmdir /s /q Cosmic-Expansion &
git clone https://github.com/Chimi70/Cosmic-Expansion
```

### How uninstall (cml)
```cd C:\Users\YourUsername\Documents
rmdir /s /q Cosmic-Expansion
```

## Commands
1. Run specific turn, command example:
```
./game_file --turn=turn_number (choose number from 1 to 4)
```

# What I use
---
- [code](https://www.youtube.com/watch?v=QoNukqpolS8)
- [assets](https://kenney.nl/assets/space-shooter-redux)
- [engine](https://godotengine.org/)