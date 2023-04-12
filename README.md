# mullvad-docker-proxy
A proxy server to route requests through Mullvad WireGuard
[![🏗️📤 Build and publish 🐳 images](https://github.com/TheBoatyMcBoatFace/mullvad-docker-proxy/actions/workflows/dockerize-me.yml/badge.svg)](https://github.com/TheBoatyMcBoatFace/mullvad-docker-proxy/actions/workflows/dockerize-me.yml)

This uses a random Mullvad Wireguard profile based in the US. To adjust your profiles, change the content of teh `/profiles` directory. You _should_ be able to replace the `PRIVATE_KEY` with your own key to get it up and running.

## To Yeet

**REMOVE YOUR PRIVATE KEYS IN MULLVLAD PROFILES**

## Docker Envs

- PRIVATE_KEY   | Your Mullvad WireGuard Key


Runs on Port 3128

/Volumes/Macintosh Hd/Users/Shared/GitHub/Orgs/TheBoatyMcBoatFace/mullvlad-docker-proxy/Dockerfile