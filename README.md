# BabbleSimDocker
A repository containing Dockerfiles for BabbleSim execution.
The main Dockerfile includes all required dependencies to run compile and run a Zephyr application compiled for the native nrf52_bsim board.
See: [NRF52 simulated board (BabbleSim)](https://docs.zephyrproject.org/latest/boards/posix/nrf52_bsim/doc/index.html)

## Running
### Running a simple Docker Container
You can directly download and run container with:
```bash
docker run --rm -it prathje/babble-sim-docker:latest bash
```
You should then be able to follow the example further below.
### Running with Docker-Compose

The easiest way for development is a docker-compose.yaml file:

```yaml
version: "3.8"

services:
  app:
    image: prathje/babble-sim-docker:latest
    tty: true
    volumes:
      - ./app:/app
```
This will use the latest build of the included Dockerfile and link the directory *./app* to */app* inside the container.

To start the services, run:
```bash
docker-compose up
```
(Press strg+c to stop the services.)
Open a console in the running docker container:
```bash
docker-compose exec app bash
```

## Example

BabbleSim is installed into */bsim* while Zephyr RTOS is installed to */zephyr*. 
Once you started the container, you should be able to build and execute the hello_world sample:
```bash
cd /zephyr/zephyr
west build -b nrf52_bsim samples/hello_world
./build/zephyr/zephyr.exe -nosim
```
You should now be able to follow the [rest of the tutorial](https://docs.zephyrproject.org/latest/boards/posix/nrf52_bsim/doc/index.html#building-and-running) to run a simple BLE application with two devices, however, you can directly start after the hello world compilation.

## Troubleshooting

### Exec format error
If you happen to receive the following error "./build/zephyr/zephyr.exe: cannot execute binary file: Exec format error" your Docker runtime is probably not able to execute 32-bit programs.

## TODO
- [ ] The resulting image should be reduced in size (currently 4.7 GB).
- [ ] Support included X server 
