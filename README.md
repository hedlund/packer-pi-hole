# Packer: Pi-Hole

A script for building a [Pi Hole](https://pi-hole.net/) image using 
[Packer](https://www.packer.io/).

## Prerequisites

First, [install Packer](https://www.packer.io/docs/install) on your system.
For Debian/Ubuntu based systems:

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

Then you need to install the [ARM image plugin](https://github.com/solo-io/packer-builder-arm-image).
This requires a working install of [Go](https://golang.org/doc/install).

```bash
git clone https://github.com/solo-io/packer-builder-arm-image
cd packer-builder-arm-image
go mod download
go build
```

> There is an alternative Packer ARM plugin if you want more control:
> https://github.com/mkaczanowski/packer-builder-arm.

After building the plugin, you need to copy the binary to a location where
Packer can pick it up (e.g. `$HOME/.packer.d/plugins`). However, you will
most likely run the build a root, so keep that in mind:

```bash
sudo mkdir -p /root/packer.d/plugins/
sudo mv packer-builder-arm-image /root/packer.d/plugins/
```

Lastly, you also need to instrall `kpartx` and `qemu`:

```bash
sudo apt install kpartx qemu-user-static
```

## Building

You need to create a config file named `vars.json` which contains a bit of
configuration:

```json
{
  "user_name": "<user>",
  "user_password": "<password>",
  "user_public_key": "<public ssh key for user>",
  "pi_password": "<another password>",
  "pihole_web_password": "<yet anotehr password>",
  "host_name": "piholr",
  "ipv4_address": "10.0.0.10/24"
}
```

| Variable              | Description                                          |
|-----------------------|------------------------------------------------------|
| `user_name`           | If not empty a new user with this name will created. |
| `user_password`       | The password for the new user.                       |
| `user_public_key`     | The SSH public key for the new user.                 |
| `pi_password`         | A new password for the default `pi` user.            |
| `pihole_web_password` | The password for the Pi-hole web interface.          |
| `host_name`           | The host name (default: `pihole`).                   |
| `ipv4_address`        | The IPv4 address of the machine (used by Pi-hole).   |
| `ipv6_address`        | The IPv6 address of the machine. Can be left empty.  |

When you've created the `vars.json` file you can build the image with:

```bash
sudo make build
```

The resulting image `output-arm-image/image` can be burned to a micro-SD card.
