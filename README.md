# Cosmic-Expansion
Really simple game created in [Godot Game Engine](https://godotengine.org/). It's evolution of this tutorial game [link](https://www.youtube.com/watch?v=QoNukqpolS8) 

---
Work on: [Linux](https://github.com/Chimi70/Cosmic-Expansion?tab=readme-ov-file#linux) and [Windows](https://github.com/Chimi70/Cosmic-Expansion?tab=readme-ov-file#windows)

## Screenshot
![](Screenshot.png)

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
### How install 
1. Install git
```winget install --id Git.Git -e --source winget```
2. Reopen PowerShell
3. Go to Documents
```cd C:\Users\YourUsername\Documents```
4. Clone repo
```git clone https://github.com/Chimi70/Cosmic-Expansion```

### How launch
```
cd Documents\Cosmic-Expansion\export\0.2\win
.\cosmic_expansion.exe
```
### How Update to the newest version
```cd C:\Users\YourUsername\Documents```
```rmdir /s /q Cosmic-Expansion```
```git clone https://github.com/Chimi70/Cosmic-Expansion```
### How uninstall
```cd C:\Users\YourUsername\Documents```
```rmdir /s /q Cosmic-Expansion```

## Commands
1. Run specific turn, command example:
./game_file --turn=turn_number (choose number from 1 to 4)
