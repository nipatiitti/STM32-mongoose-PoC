# Bare-metal SvelteKit PoC with STM32 MCU & Mongoose.ws

This project combines the Mongoose.ws embedded web server with a modern SvelteKit frontend running on an STM32 Nucleo-H7 board. It demonstrates how to build a responsive web interface for embedded systems with a compact footprint.

## Features

- Embedded web server using Mongoose.ws library
- Modern reactive UI built with SvelteKit
- API for controlling LED blinking speeds
- Efficient packed filesystem for web assets
- Ethernet connectivity with static IP or DHCP

## Prerequisites

- ARM GCC toolchain (arm-none-eabi-gcc)
- STM32 Programmer CLI for flashing
- [Build tools listed here](https://mongoose.ws/documentation/tutorials/tools/)
- Node.js and Yarn for frontend development
- STM32 Nucleo-H7 development board
- Ethernet connection

## Project Structure

- `/mongoose/` - Mongoose.ws library and configuration
- `/ui/` - SvelteKit frontend application
- `/tools/` - Utilities for packing the filesystem
- `/cmsis_*` - STM32 hardware abstraction layer

## Installation

First, install all required tools mentioned in the prerequisites section.

Build and flash the firmware:

```bash
make build   # Builds frontend and firmware
make flash   # Flashes firmware to STM32 board
```

The build process:
1. Builds the SvelteKit frontend
2. Compresses the frontend files
3. Packs them into an embedded filesystem
4. Compiles the firmware with the embedded files
5. Creates the flashable binary

## Network Configuration

By default, the firmware uses a static IP configuration:

```c
#define MG_TCPIP_IP MG_IPV4(192, 168, 1, 55)     // IP
#define MG_TCPIP_GW MG_IPV4(192, 168, 1, 1)      // Gateway
#define MG_TCPIP_MASK MG_IPV4(255, 255, 255, 0)  // Netmask
```

To use DHCP instead, comment these lines in mongoose_config.h.

After flashing, access the web interface by navigating to the board's IP address in your browser.

## Development

### Frontend Development

For frontend development with hot-reloading:

```bash
cd ui
yarn install
yarn dev
```

Create a `.env` file in the ui directory with the IP of your STM32 board:

```
VITE_MG_IP=192.168.1.55 # or whatever IP you set in mongoose_config.h
```

Access the development server at `http://localhost:5173`. Changes will be proxied to the STM32 board's API.

### Backend Development

To modify the API endpoints or embedded server logic:
- Edit mongoose_impl.c to change API handlers
- Adjust mongoose_config.h for server configuration
- Update main.c for core application logic

After changes, rebuild and reflash the firmware.

### vscode

To develop this project in Visual Studio Code, you can use the following c/c++ intellisense settings in `c_cpp_properties.json`:

```json
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "${workspaceFolder}/**"
            ],
            "defines": [],
            "compilerPath": "/usr/bin/arm-none-eabi-gcc",
            "cStandard": "c17",
            "cppStandard": "gnu++17",
            "intelliSenseMode": "gcc-arm"
        }
    ],
    "version": 4
}
```

and the following `launch.json` for debugging:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug w/ ST-Link",
            "cwd": "${workspaceFolder}",
            "type": "cortex-debug",
            "executable": "firmware.elf",
            "request": "launch",
            "servertype": "stlink",
            "device": "STM32H755ZI-Q",
            "interface": "swd",
            "runToEntryPoint": "main",
            "svdFile": "${env:STM32CLT_PATH}/STMicroelectronics_CMSIS_SVD/STM32H755_CM7.svd",
            "serverpath": "${env:STM32CLT_PATH}/STLink-gdb-server/bin/ST-LINK_gdbserver",
            "stm32cubeprogrammer": "${env:STM32CLT_PATH}/STM32CubeProgrammer/bin",
            "stlinkPath": "${env:STM32CLT_PATH}/STLink-gdb-server/bin/ST-LINK_gdbserver",
            "armToolchainPath": "${env:STM32CLT_PATH}/GNU-tools-for-STM32/bin",
            "gdbPath": "${env:STM32CLT_PATH}/GNU-tools-for-STM32/bin/arm-none-eabi-gdb",
            "serverArgs": [
                "-m",
                "1",
            ],
        },
        {
            "type": "cortex-debug",
            "request": "launch",
            "servertype": "stutil",
            "cwd": "${workspaceRoot}",
            "executable": "./firmware.elf",
            "name": "Debug (ST-Util)",
            "device": "STM32H755ZI-Q",
            "v1": false
        }
    ],
}
```

You will need the `cortex-debug` extension for Visual Studio Code, which can be installed from the marketplace.

## License

This project uses code from Mongoose.ws which is dual-licensed under GPL or commercial license.
Check [Mongoose licensing](https://mongoose.ws/licensing/) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
