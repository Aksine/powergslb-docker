# Docker image for PowerGSLB

An updated Docker image for PowerGSLB from https://github.com/acudovs/powergslb/tree/master

The following changes were made:
* Separated database into a separate container and autoconfigure a database container.
* Switched to using supervisord to start PowerDNS and PowerGSLB.
* Exposed environment variables to configure Database settings.


To use this and run this:

Make the changes in the environment variables in docker-compose.yml 

Run the following
```
git clone https://github.com/Aksine/powergslb-docker
cd powergslb-docker
docker compose up -d
```

If you want to build, uncomment the build lines in docker-compose.yml

```
docker compose up -d --build
```
