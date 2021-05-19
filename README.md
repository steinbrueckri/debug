# The DEBUG container for any moment in life

[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=steinbrueckri/debug)](https://dependabot.com)
![test-build-release](https://github.com/steinbrueckri/debug/workflows/test-build-release/badge.svg)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/steinbrueckri/debug)
![Docker Pulls](https://img.shields.io/docker/pulls/steinbrueckri/debug)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/steinbrueckri/debug)

## Why

Sometimes in life you need a container in a K8s Cluster or on a Docker machine to debug some things.
In this situation this image helps you alot! 🎉 🙌

## How

For convinience you can use the shell you like the most, you can choose the following options:

- zsh
- fish
- bash
- sh

### Build locally

```sh
docker build -t debug:local . -f src/Dockerfile
```

### Man page

Inside the container you can open the man page with `man debug`.
The man page will give you some hints what is installed and some code snippets.

### Run in docker context

#### Interactive Mode

```sh
docker run -it --rm --entrypoint /bin/zsh
```

#### Server Mode

```sh
docker run -d --rm -p2222:22 -p8080:80 steinbrueckri/debug
```

### Run in K8s context

#### Interactive Mode

```sh
kubectl run --namespace default -i --tty debug --image=steinbrueckri/debug --restart=Never --rm=true -- zsh
```

You can also alias that command within your `.zshrc`or `.bashrc` by adding the following line:

```sh
alias kdebug='kubectl run --namespace default -i --tty debug --image=steinbrueckri/debug --restart=Never --rm=true -- zsh'
```

*NOTE:* Feel free to replace ZSH with the shell of your choice. We have sh, Bash, ZSH, fish

#### Server Mode

TBD

## Configuration

### Environment variables

#### General Options

- `SSHUSERS` github users split by whitespaces for publickey deployment

## Contributions

- Contributions are welcome!
- Give :star: - if you want to encourage me to work on a project
- Don't hesitate create issue for new feature you dream of or if you suspect some bug

## Testing

For testing the [bats](https://github.com/bats-core/bats-core#installation) testing framework is used.

```bash
git clone https://github.com/steinbrueckri/debug.git
./tests/run.bats
```

## Project versioning

Project use [Semantic Versioning](https://semver.org/).
We recommended to use the latest and specific release version.

In order to keep your project dependencies up to date you can watch this repository *(Releases only)*
or use automatic tools like [Dependabot](https://dependabot.com/).

## Release

- create new branch
- make your changes, if needed
- commit your changes like
  - Patch Release: `fix(script): validate input file to prevent empty files`
  - Minor Release: `feat(dockerimage): add open for multiple input files`
  - Major Release [look her](https://github.com/mathieudutour/github-tag-action/blob/master/README.md)
