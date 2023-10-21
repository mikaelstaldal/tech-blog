---
title: How to enable multi-platform Docker builds on Ubuntu 22.04
author: Mikael Ståldal
type: post
date: 2023-02-10T13:56:09+00:00
url: /2023/02/10/how-to-enable-multi-platform-docker-builds-on-ubuntu-22-04/
categories:
  - Docker
  - Linux
  - Ubuntu

---
Docker&#8217;s [official documentation][1] on how to enable multi-platform Docker builds is a bit intimidating, suggesting you to run the Docker image `tonistiigi/binfmt` in privileged mode on your machine. I searched for alternatives on Ubuntu, and found [this very detailed description][2]. However, with recent versions of Ubuntu and Docker, it is now much easier than that:

  1. Install QEMU&#8217;s static user mode emulation binaries:  
    `sudo apt install qemu-user-static`
  2. Install Docker Engine with Buildx support according instructions [here][3] (do not install `docker-ce` or `docker.io` from Ubuntu&#8217;s standard repository).
  3. Create a Docker Buildx builder:  
    `docker buildx create --name multiplatform --bootstrap --use`
  4. Verify it:  
    `docker buildx inspect`

Then you can do multi-platform Docker builds like this:  
`docker buildx build --platform linux/amd64,linux/arm64 .`

 [1]: https://docs.docker.com/build/building/multi-platform/
 [2]: https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408
 [3]: https://docs.docker.com/engine/install/ubuntu/