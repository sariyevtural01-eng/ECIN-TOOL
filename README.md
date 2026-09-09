# ELCIN TOOL

## NMAP ASSISTANT TOOL

ELCIN TOOL is a terminal-based Nmap assistant tool developed in Bash to make Nmap usage easier, faster, and more organized.

The tool provides users with different Nmap scan options through a menu-based interface. After selecting an option, the user enters a target IP address or hostname, and the tool executes the corresponding Nmap command.

## Features

* 10 main scan categories
* 100 different Nmap options
* Menu-based interface
* IP address and hostname support
* Port scanning
* Service and version detection
* OS detection
* Firewall and filter testing
* NSE script scanning
* Network discovery
* Timing and speed options
* Various scan combinations
* Simple and user-friendly Bash interface

## Categories

1. Port Scanning
2. Service / Version Detection
3. OS Detection
4. Firewall / Filter Testing
5. NSE Script Scanning
6. Network Discovery and Topology
7. Timing / Speed Options
8. Target Specification
9. Spoofing / Fragmentation
10. Combination Scans

## Installation

Clone the repository:

```bash
git clone https://github.com/sariyevtural01-eng/ECIN-TOOL.git
```

Enter the project directory:

```bash
cd ECIN-TOOL
```

Give execution permission to the tool:

```bash
chmod +x elcin.sh
```

## Usage

Start the tool:

```bash
./elcin.sh
```

Then select a category and scan option from the menu.

Example:

```text
1) Port Scanning
2) Service / Version Detection
3) OS Detection
...
99) Exit
```

After selecting an option, enter the target IP address or hostname. The tool will execute the corresponding Nmap command.

## Requirements

* Linux
* Bash
* Nmap

Check if Nmap is installed:

```bash
nmap --version
```

## Note

Some Nmap scan types may require administrator/root privileges.

For example:

```bash
sudo ./elcin.sh
```

## Legal and Ethical Use

This tool should only be used against systems that you own or have explicit permission to test.

It is suitable for authorized environments such as TryHackMe, Hack The Box, and personal security laboratories.

Scanning systems without permission may be illegal.

## Purpose

The main purpose of this project is to help users who are learning Nmap by organizing different Nmap scan options into a single menu-based tool and making Nmap usage easier.

## License

This project is released under the MIT License.
