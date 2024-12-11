> ```
>   __ _       _      _
>  / _(_) __ _| | ___| |_
> | |_| |/ _` | |/ _ \ __|
> |  _| | (_| | |  __/ |_
> |_| |_|\__, |_|\___|\__|
>        |___/
> ```

## [figlet](http://www.figlet.org/) as a static binary or as a Docker stage, only 200kB

## Features

* Less than 200kB.
* Use as a Docker stage.
* Use as a GitHub action.
* Static binary for any Alpine Linux version from an Alpine repo.
* Static binary for any Linux, download and uncompress manually.
* Supported platforms: `amd64` (`x86_64`), `arm64` (`aarch64`), `s390x`,
  `386` (`x86`), `arm/v6`, `arm/v7`, `ppc64le`.
* Fonts included.
* Shortcuts for better looking Dockerfiles.

## Usage

### Docker

[[GHCR]](https://github.com/gaborcsardi/figlet)
[[Docker Hub]](https://hub.docker.com/r/gaborcsardi/figlet)

Copy the `/usr/local/` directory into your Docker image.
Then run `figlet` or one of the other shortcuts, e.g. `:::` or `-----`,
see below:

```Dockerfile
COPY --from=ghcr.io/gaborcsardi/figlet /usr/local /usr/local
RUN ::: Building && : ------------------------------------------- && \
    echo command with a lot of output ... && \
    echo another command ... && \
    echo more commands ... && \
    ----- # ----------------------------------------------------------
```
will produce the output:
```
#8 [stage-0 3/3] RUN ::: Building && : ------------------------------------------- &&     echo command with a lot of output ... &&     echo another command ... &&     echo more commands ... &&     ----- # ----------------------------------------------------------
#8 0.262  ____        _ _     _ _
#8 0.262 | __ ) _   _(_) | __| (_)_ __   __ _
#8 0.262 |  _ \| | | | | |/ _` | | '_ \ / _` |
#8 0.262 | |_) | |_| | | | (_| | | | | | (_| |
#8 0.262 |____/ \__,_|_|_|\__,_|_|_| |_|\__, |
#8 0.262                                |___/
#8 0.262 command with a lot of output ...
#8 0.262 another command ...
#8 0.262 more commands ...
#8 0.263
#8 0.263 ________________________________________________________________
#8 0.263
#8 0.263
#8 DONE 0.3s
```

#### Shortcuts

`--` (two dashes) and `:::` are aliases (symbolic links) to `figlet`, so
you can write nice headings. `-----` (five dashes) produces a long
horizontal line, you can use this to mark the end of blocks:

```sh
-- This is a heading # --------------------------------
...
----- # -----------------------------------------------
```

### GitHub Action

You can use the Docker image as a container action on GitHub Actions.
For example:

```yaml
steps:
- uses: gaborcsardi/figlet@v2
  with:
    text: "Hello world!"
```

To change the font, use the `font` input parameter:

```yaml
steps:
- uses: gaborcsardi/figlet@v2
  with:
    text: "Hello world!"
    font: slant
```

### Alpine Linux

Install my public key, and install the figlet package from my repo:

```sh
wget https://raw.githubusercontent.com/gaborcsardi/figlet/refs/heads/main/gaborcsardi-673e2275.rsa.pub \
    -O /etc/apk/keys/gaborcsardi-673e2275.rsa.pub
apk add figlet \
    -X https://github.com/gaborcsardi/figlet/releases/download/latest
```

### Other Linux

Select the right platform at [the releases page](
  https://github.com/gaborcsardi/figlet/releases/latest) and uncompress
the apk file with `tar`:

```sh
URL="https://github.com/gaborcsardi/figlet/releases/download/2.2.5-r3/figlet-2.2.5-r3-aarch64.apk"
wget -O- "$URL" | tar xz -C /
```
or use `curl`:
```sh
URL="https://github.com/gaborcsardi/figlet/releases/download/2.2.5-r3/figlet-2.2.5-r3-aarch64.apk"
curl -Ls "$URL" | tar xz -C /
```
## License

BSD-3-Clause (C) 1991-2012 Glenn Chappell, Ian Chai, John Cowan,
Christiaan Keet and Claudio Matsuoka
