# MAC.sh

A command line that displays the MAC address of every network interface on
the machine, one address per line.

**Requirements:** `ifconfig` (from the classic `net-tools` package). Some
minimal Linux distros ship only `ip` (`iproute2`) by default — see the
"If `ifconfig` isn't available" section below if `MAC.sh` produces no output.

## The command

```sh
ifconfig | grep ether | awk '{print $2}'
```

## How it works

| Part | Role |
|---|---|
| `ifconfig` | Lists every network interface along with its details — IP address, MAC address, flags, etc. |
| `grep ether` | Filters that output down to only the lines that contain a MAC address, which `ifconfig` labels with the word `ether` (e.g. `ether aa:bb:cc:dd:ee:ff txqueuelen 1000 (Ethernet)`). This doesn't accidentally match `inet6` lines, since `ether` isn't a substring of `inet6`. |
| `awk '{print $2}'` | Prints just the second whitespace-separated field of each remaining line — the MAC address itself — dropping the `ether` label and any trailing flags. |

Each match naturally ends up on its own line, since `grep` and `awk`
process input line by line — so the "each address followed by a line
break" requirement is satisfied automatically, with no extra formatting
needed.

## Usage

```sh
sh MAC.sh
```

or make it executable:

```sh
chmod +x MAC.sh
./MAC.sh
```

## Sample output

```
$ ./MAC.sh
aa:bb:cc:dd:ee:ff
00:00:00:00:00:00
```

(The number of lines depends on how many network interfaces your machine
has — typically one physical/Wi-Fi interface plus the loopback interface,
which usually reports `00:00:00:00:00:00`.)

## If `ifconfig` isn't available

Some newer or minimal Linux systems no longer ship `ifconfig` by default,
replacing it with the `ip` command from `iproute2`. If `MAC.sh` produces no
output, check first:

```sh
which ifconfig
```

If that returns nothing, the equivalent using `ip` is:

```sh
ip link | grep ether | awk '{print $2}'
```

`ip link` lists interfaces in a similar way, and the `ether` keyword still
marks the line containing the MAC address, so the rest of the pipeline
works the same way.

## Testing

Run the script and visually confirm the output looks like valid MAC
addresses — six pairs of hex digits separated by colons:

```sh
sh MAC.sh
```

Cross-check against a known address using a system tool, to make sure
nothing was mis-parsed:

```sh
ifconfig | grep -A1 "<your interface name>"
```

or on macOS:

```sh
ifconfig en0 | grep ether
```
