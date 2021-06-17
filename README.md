# esp32-easy-menuconfig

esp32-easy-menuconfig is a tool for dealing with [esp32-arduino-lib-builder](https://github.com/espressif/esp32-arduino-lib-builder.git) build process. Seamsly build and install custom [arduino-esp32](https://github.com/espressif/arduino-esp32) sdk libraries into [Arduino](https://arduino.cc/) and [platformio](https://platform.io/).

I inverted serveral time trying to get a custom buil of esp32 arduino libraries to my project, and made this tool for simplify the process.
 

Works in linux (tested on Ubuntu / Elementary OS ).  I think libraries compiled in linux will work also on windows too. Feel free to open an issue about this.




Build process launch **menuconfig dialog** allowing you make changes on esp32 options. ***Get Fun!***

## Prerequisites

esp32-easy-menuconfig will install all necesaries tools to build the libraries. 

Anyway, you need to get installed **arduinoespressif32** in platformio 

platformio.ini example
```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino

```

On Arduino, install **ESP32 by Espressif Systems** version 1.0.6. [Example tutorial to archieve this can be found here](https://randomnerdtutorials.com/installing-the-esp32-board-in-arduino-ide-windows-instructions/) prior running this. Remember to install the lastets (1.0.6) version. 



## Build process

Clone the repo, and run build.sh

```bash
git clone https://github.com/sabado/esp32-easy-menuconfig.git
./build.sh
```
Full process can take more than an hour to finish, be noticed.




## Install builded libraries

When internal build process finish, the tool ask you to install it in Platformio, Arduino IDE's, or both.  In case of the paths don't are the regular ones, will find and list possible matches. 

The output builded files are located into base/out directory 


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.


## License
[MIT](https://choosealicense.com/licenses/mit/)
