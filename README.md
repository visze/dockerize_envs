# Docker envs


## Work

### Build

```bash	
 docker build -f work/Dockerfile -t visze/dockerize_envs_work:latest .
 docker push visze/dockerize_envs_work:latest
 ```
Or

```bash
./create_docker_env.sh work
```

Or

```bash
./create_docker_env.sh work latest
```

### Run

Pull first in location of choice

```bash
apptainer pull docker://visze/dockerize_envs_work:latest
```

And then run a command. E.g.

```bash
apptainer exec dockerize_envs_work_latest.sif concat_files.sh
```
