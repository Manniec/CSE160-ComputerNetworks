### Running Docker Container

**For Mac:**
>```
>docker run --name "container_name" -v //c//"location of skelton code":"mount to location" -it image_name /bin/bash 
>```

Example:
```
docker run --name CSE160_p1 -v "/Users/manniec/GitHub/CSE160-ComputerNetworks:/home/cse160" -it ucmercedandeslab/tinyos_debian /bin/bash
```
Files from local computer will now be saved in `cd /home/cse160/`. 
Since macOS allows for directory names with certain special characters wrapping destinations in quotes helps.

Understanding the command:

* **`docker run <options> <imagename>`:** runs image as docker container
* **`--name <containername>`:** (optional) parameter for naming docker container instance, follow with name of instance; name can be used later to specify docker image
* **`-v` / `-volume`:** mount volume; used for creating storage space in docker container separate from container file system. In this case we mount a location on our local computer (our local git repository)
* **`-it`/`-i -t`:** allocate a psuedo terminal (aka: tty or pts) in interactive mode; `-t` allocates the psuedo code, `-i` 


Note: Because your accessing files on your local computer and not a copy, make sure your working on the right branch before launching simulation

## Useful Commands
`docker ps -a` : view all current containers

`docker start <containername/id>` : restart existing/exited container

`docker attach <containername>` : re-enter pseudo terminal for running container

`docker rm <containername>` : delete a container 