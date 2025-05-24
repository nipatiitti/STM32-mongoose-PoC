# STM32 / Mongoose.ws + SvelteKit => PoC

This porject is basicly the barebones Mongoose.ws Wizard STM32 Nucleo-H7 example project, but with custom frontend using SvelteKit.

It has a simple example api, you can use to change the red led blinking speed of the board, and a simple frontend to control it.

## Installation

First make sure you have installed all the tools listed [here](https://mongoose.ws/documentation/tutorials/tools/) for your relevant build environment. You also need to install `yarn` to install and build the SvelteKit frontend.

To build and flash this project run:

```bash
make build
make flash
```

This will run build the frontend, pack it to a embedded filesystem, compile the firmware and flash it to the STM32 Nucleo-H7 board.

Currently the project is configured for a static IP address of

```c
#define MG_TCPIP_IP MG_IPV4(192, 168, 1, 55)     // IP
#define MG_TCPIP_GW MG_IPV4(192, 168, 1, 1)      // Gateway
#define MG_TCPIP_MASK MG_IPV4(255, 255, 255, 0)  // Netmask
```

If you comment these lines from the `mongoose/mongoose_config.h` file, the firmware will use DHCP to get an IP address.

## Development

To develop the frontend, you can run the SvelteKit dev server:

```bash
cd ui
yarn install
yarn dev
```

And add the ip address of your STM32 board to a `.env` file in the `ui` directory:

```
VITE_MG_IP=192.168.1.55 # or whatever IP you set in mongoose_config.h
```

Then you can access the frontend at `http://localhost:5173` and it will connect to the STM32 board at the IP address you specified in the `.env` file.

