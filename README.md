# Docker Compose RHEL

Docker Compose script to run Red Hat Enterprise Linux container.

## Usage

### Create a secret file for user name and password

First, create a secret file named `secrets.txt` in the project directory. The contents of the file are as follows:
The first line is the username for the RHEL container, and the second line is the password.

```text
username
password
```

## Build a container

```sh
docker compose build
```

## Run a container

```sh
docker compose up -d
```

## License

[MIT](./LISENCE)

## Author

- Shunya Sasaki
  - Mail: [shunya.sasaki1120@gmail.com](mailto:shunya.sasaki1120@gmail.com)
  - X: [@ShunyaSasaki](https://x.com/ShunyaSasaki)
