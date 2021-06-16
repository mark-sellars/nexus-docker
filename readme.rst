==============================
Nexus OSS 3 in Docker / Podman
==============================

.. |VERSION| replace:: 1.0
.. header:: ###Title### Version |VERSION|
.. footer:: ###Page### of ###Total###

.. role:: bash(code)
          :language: bash

.. raw:: pdf

        PageBreak

.. contents:: Table of Contents
.. section-numbering::

.. raw:: pdf

        PageBreak

Abstract
========
- Deployment of Nexus OSS in docker or podman with nginx for reverse proxy. Centos 8 was used with podman-compose
  however this should work on any platform that runs docker-compose files. 

Hardware requirements
=====================
- For more detailed refereance see: `https://help.sonatype.com/repomanager3/installation/system-requirements`

cpu
---
- Minimum CPUs: 4
- Recommended CPUs: 8+

RAM
---
small, personal
~~~~~~~~~~~~~~~
repositories < 20
total blobstore size < 20GB
single repository format type

8GB minimum

medium, team
~~~~~~~~~~~~
repositories < 50
total blobstore size < 200GB
a few repository formats

16GB

large, enterprise
~~~~~~~~~~~~~~~~~
repositories > 50
total blobstore size > 200GB
diverse set of repository formats 

32GB+

Preperation
===========

Software
--------
After installing the OS setup the enviornment for docker-compose or podman-compose. For centos 8 there is a setup
script "cent8_inst.sh". This will install podman-compose and some required componets. This will also set the
firewall, do some OS tweeks, and install some programs like tmux, webmind, cockpit. Edit to your likeing. 

To use the script simply run :bash:`sudo sh ./cent8_inst.sh`

Storage
-------
A folder needs to be made for nexus to store its files. This docker compose file places it in /srv/nexus-data.
The directory nexus-data must be created and the permissions set. The user will be 200.

.. code:: bash
        chown 200:200 /srv/nexus-data
        chmod 770 /srv/nexus-data

nginx
-----
nginx's worker proccesses should be set to how many CPU cores are available. Edit the number on the 
line "worker_processes  4; in nginx.conf to match how many CPU cores you have.

For the max upload size edit the line client_max_body_size 25G; in mysite.template. 

SSL
---
- The docker-compose file with automatically make a self signed SSL cert. Edit the line that starts with "Command"
  You will need to edit "/C=US/ST=California/L=San Diego/O=some name/OU=IT/CN=yourdomain.com'" with the correct
  information. 

- The certs can be found in ./nginx/certs.

- Also note that after you run docker-compose for the first time you will want to remove this line otherwise it
  will run every time you run docker compose. 

- If you have your own certs place them in ./nginx/certs. The cert names are "nexus.key" and "nexus.cert" if you have
  other cert files please edit the nginx config files accordingly.  

Running Nexus
=============
The fallowing examples are with podman-compose. If your using docker the commands for docker-compose will be similar. 
These commands are ran within the folder with docker-compose file

- starting the server :bash:`sudo podman-compose up -d` 
- stopping the server :bash:`sudo podman-compose down`

If the containers or the pod get stuck these commands might help

.. code:: bash
        sudo podman pod list
        sudo podman pod stop nexus
        sudo podman pod rm -a

Admin password
--------------
When you run nexus for the first time a temporary admin password is located in the nexus-data folder. You will be
prompt to change it on the first login. 

Upgrading Nexus
===============
1. Backup your nexus instance 
2. Tear down the entire stack :bash:`sudo podman-compose down`
3. Pull new images: :bash:`sudo podman-compose pull`
4. Start podman-compose :bash:`sudo podman-compose up`


Referances
==========
- Nexus - `https://help.sonatype.com/repomanager3`
- nginx - `https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/`
- podman-compose - `https://github.com/containers/podman-compose`
- podman- `http://docs.podman.io/en/latest/`
