# Docker image for PowerGSLB

An updated Docker image for PowerGSLB from https://github.com/acudovs/powergslb/tree/master

The following changes were made:
* Separated database into a separate container and autoconfigure a database container.
* Switched to using supervisord to start PowerDNS and PowerGSLB.
* Exposed environment variables to configure Database settings.

### Running PowerGSLB 

Make the changes in the environment variables in docker-compose.yml 
Under powergslb
```
    environment:
      - MYSQL_ROOT_PASSWORD=<YOUR_ROOT_PASSWORD>
      - MYSQL_USER_PASSWORD=<YOUR_USER_PASSWORD>
      - MYSQL_USERNAME=powergslb
      - MYSQL_DATABASE=powergslb
      - MYSQL_HOSTNAME=mariadb
```

Run the following the commands
```
git clone https://github.com/Asksine/powergslb-docker
cd powergslb-docker
docker compose up -d
```

It should be accesible at http://localhost/admin/

### Build from Dockerfile

If you want to build from Dockerfile instead, uncomment the build lines in docker-compose.yml
```
# Uncomment the build lines if you want to build from Dockerfile instead
#    build:
#      context: .
#      dockerfile: Dockerfile
```

Then run the following
```
docker compose up -d --build
```
