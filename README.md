## Introduction

Docker container for develpment of redmine plugins.
Pull command:

```
docker pull couchbelag/redmine-plugin-dev
```


## Getting started

Run this image using:
```
docker run -ti -p 3000:3000 -v <abs path containing plugins>:/opt/redmine/plugins couchbelag/redmine-plugin-dev:3.4 /bin/redmine <development|production|test>
```
