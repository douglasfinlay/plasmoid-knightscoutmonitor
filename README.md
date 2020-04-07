# KNightscout Monitor

This plasmoid (KDE5 Plasma) gathers CGM readings from a [Nightscout](http://www.nightscout.info) server.


## Screenshots

![KNighscout Monitor in Plasma top panel](https://raw.githubusercontent.com/dougfinl/plasmoid-knightscoutmonitor/master/screenshots/horizontalwidget.png)


## Installation

```
git clone https://github.com/dougfinl/plasmoid-knightscoutmonitor
cd plasmoid-knightscoutmonitor
mkdir build
cd build
cmake .. 
make 
sudo make install
```

Restart plasma to load the plasmoid:
```
killall plasmashell
kstart5 plasmashell
```

or alternatively, preview the plasmoid in a separate window.
```
plasmoidviewer -a com.github.dougfinl.knightscoutmonitor
```

## License
[GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)
