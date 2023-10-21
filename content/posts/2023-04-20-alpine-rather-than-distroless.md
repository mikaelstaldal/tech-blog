---
title: Alpine rather than distroless
author: Mikael Ståldal
type: post
date: 2023-04-20T06:10:33+00:00
url: /2023/04/20/alpine-rather-than-distroless/
category:
  - Docker
  - Linux
  - security

---
I have been using the [distroless][1] Docker base images to package my applications, mainly since I want slim and simple image without unnecessary cruft.

However, they are based on [Debian][2], and Debian is unfortunately not so diligent to fix serious security issues as other distributions like Ubuntu or Alpine. If you scan a distroless image with the grype tool, you get this result:

```
$ grype gcr.io/distroless/java17-debian11

NAME             INSTALLED              FIXED-IN     TYPE  VULNERABILITY     SEVERITY
libharfbuzz0b    2.7.4-1                (won't fix)  deb   CVE-2023-25193    High
libjpeg62-turbo  1:2.0.6-4              (won't fix)  deb   CVE-2021-46822    Medium
libssl1.1        1.1.1n-0+deb11u4       (won't fix)  deb   CVE-2023-0464     High
openssl          1.1.1n-0+deb11u4       (won't fix)  deb   CVE-2023-0464     High
```

Furthermore, if small image size is important, distroless is quite overrated. They brags about being so small:

> Distroless images are very small. The smallest distroless image, gcr.io/distroless/static-debian11, is around 2 MiB. That&#8217;s about 50% of the size of alpine (~5 MiB), and less than 2% of the size of debian (124 MiB).

But the `gcr.io/distroless/java17-debian11` image is 231MiB, so saving 3 MiB in the base is insignificant if you depend on Java or some other runtime (Node.js or Python) anyway.

So I decided to go with [Alpine][3] instead. You can easily build your own Java base image:

```
FROM alpine:3.17.3
RUN apk update && apk add openjdk17-jre-headless && rm -rf /var/cache/apk/*`
```

and the result is even smaller than distroless-java, only 198 MiB. I bet it&#8217;s as easy to do the same with Node.js or Python.

I would say that distroless is only relevent if you can use the smallest `gcr.io/distroless/static-debian11` which is indeed very small and does not contain the above vulnerabilities since it does not even contain those packages. All the others are not so small and may contain unpatched vulnerabilities.

 [1]: https://github.com/GoogleContainerTools/distroless
 [2]: https://www.debian.org/
 [3]: https://www.alpinelinux.org/