#!/bin/bash

# ==========================================================
#                       ELCIN TOOL
#                  NMAP ASSISTANT TOOL
# ==========================================================

clear

banner() {
    clear
    echo "============================================================"
    echo "                         ELCIN TOOL"
    echo "                    NMAP ASSISTANT TOOL"
    echo "============================================================"
    echo
}

check_nmap() {
    if ! command -v nmap >/dev/null 2>&1; then
        echo "[!] Nmap is not installed on the system."
        echo "[*] To install Nmap:"
        echo "    sudo apt install nmap"
        exit 1
    fi
}

target_input() {
    echo
    echo "============================================================"
    read -rp "Enter Target IP / Host: " TARGET

    if [[ -z "$TARGET" ]]; then
        echo "[!] Target cannot be empty."
        read -rp "Press Enter to continue..."
        return 1
    fi

    return 0
}

port_input() {
    read -rp "Enter Port(s) (e.g. 22,80,443): " PORTS

    if [[ -z "$PORTS" ]]; then
        echo "[!] Port cannot be empty."
        return 1
    fi

    if [[ ! "$PORTS" =~ ^[0-9,-]+$ ]]; then
        echo "[!] Port format can only contain numbers, commas, and hyphens."
        return 1
    fi

    return 0
}

run_scan() {
    local DESCRIPTION="$1"
    shift

    echo
    echo "------------------------------------------------------------"
    echo "Selected function:"
    echo "$DESCRIPTION"
    echo "------------------------------------------------------------"
    echo
    echo "Nmap command:"
    printf 'nmap'
    printf ' %q' "$@"
    echo
    echo
    echo "Starting scan..."
    echo "------------------------------------------------------------"
    echo

    nmap "$@"

    echo
    echo "------------------------------------------------------------"
    read -rp "Press Enter to continue..."
}

# ==========================================================
# 1. PORT SCANNING
# ==========================================================

port_scans() {

    while true; do
        banner

        echo "================== PORT SCANNING =================="
        echo
        echo "[1] Fast port scan"
        echo "    Quickly checks the most commonly used ports."
        echo
        echo "[2] Scan specific ports"
        echo "    Checks the status of selected ports."
        echo
        echo "[3] Scan all ports"
        echo "    Checks TCP ports from 1-65535."
        echo
        echo "[4] TCP SYN scan"
        echo "    Checks ports using TCP SYN packets."
        echo
        echo "[5] TCP Connect scan"
        echo "    Checks ports by establishing a full TCP connection."
        echo
        echo "[6] UDP scan"
        echo "    Checks UDP ports."
        echo
        echo "[7] FIN scan"
        echo "    Performs a TCP scan using the FIN flag."
        echo
        echo "[8] Xmas scan"
        echo "    Performs a scan using a combination of TCP flags."
        echo
        echo "[9] Null scan"
        echo "    Performs a scan without TCP flags."
        echo
        echo "[10] ACK scan"
        echo "     Helps analyze firewall/filter rules."
        echo
        echo "[0] Return to main menu"
        echo
        echo "======================================================"

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "Fast port scan" -F "$TARGET"
                ;;

            2)
                target_input || continue
                port_input || continue
                run_scan "Scan specific ports" -p "$PORTS" "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "Scan all TCP ports" -p- "$TARGET"
                ;;

            4)
                target_input || continue
                run_scan "TCP SYN scan" -sS "$TARGET"
                ;;

            5)
                target_input || continue
                run_scan "TCP Connect scan" -sT "$TARGET"
                ;;

            6)
                target_input || continue
                run_scan "UDP scan" -sU "$TARGET"
                ;;

            7)
                target_input || continue
                run_scan "FIN scan" -sF "$TARGET"
                ;;

            8)
                target_input || continue
                run_scan "Xmas scan" -sX "$TARGET"
                ;;

            9)
                target_input || continue
                run_scan "Null scan" -sN "$TARGET"
                ;;

            10)
                target_input || continue
                run_scan "ACK scan" -sA "$TARGET"
                ;;

            0)
                return
                ;;

            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 2. SERVICE / VERSION
# ==========================================================

service_scans() {

    while true; do
        banner

        echo "================ SERVICE / VERSION =================="
        echo
        echo "[1] Service and version detection"
        echo "    Shows services and versions running on open ports."
        echo
        echo "[2] Aggressive version detection"
        echo "    Performs a more extensive version detection."
        echo
        echo "[3] Default scripts + version"
        echo "    Combines default NSE scripts with version detection."
        echo
        echo "[4] Version detection on selected ports"
        echo "    Shows service information for specific ports."
        echo
        echo "[5] Web services"
        echo "    Checks HTTP/HTTPS ports and their versions."
        echo
        echo "[6] SSH service"
        echo "    Checks the SSH service version."
        echo
        echo "[7] FTP service"
        echo "    Checks the FTP service version."
        echo
        echo "[8] SMB service"
        echo "    Checks SMB service versions."
        echo
        echo "[9] SMTP service"
        echo "    Checks SMTP service versions."
        echo
        echo "[10] Service + OS"
        echo "     Provides service version and OS information together."
        echo
        echo "[0] Return to main menu"
        echo
        echo "====================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "Service and version detection" -sV "$TARGET"
                ;;

            2)
                target_input || continue
                run_scan "Aggressive version detection" -sV --version-intensity 9 "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "Default scripts + version" -sC -sV "$TARGET"
                ;;

            4)
                target_input || continue
                port_input || continue
                run_scan "Version detection on selected ports" -sV -p "$PORTS" "$TARGET"
                ;;

            5)
                target_input || continue
                run_scan "Web services" -sV -p 80,443 "$TARGET"
                ;;

            6)
                target_input || continue
                run_scan "SSH service" -sV -p 22 "$TARGET"
                ;;

            7)
                target_input || continue
                run_scan "FTP service" -sV -p 21 "$TARGET"
                ;;

            8)
                target_input || continue
                run_scan "SMB service" -sV -p 139,445 "$TARGET"
                ;;

            9)
                target_input || continue
                run_scan "SMTP service" -sV -p 25,465,587 "$TARGET"
                ;;

            10)
                target_input || continue
                run_scan "Service + OS" -sV -O "$TARGET"
                ;;

            0)
                return
                ;;

            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 3. OS DETECTION
# ==========================================================

os_detection() {

    while true; do
        banner

        echo "=================== OS DETECTION ====================="
        echo
        echo "[1] OS detection"
        echo "    Attempts to identify the target operating system."
        echo
        echo "[2] OS + service versions"
        echo "    Checks OS and service versions together."
        echo
        echo "[3] Aggressive detection"
        echo "    Collects OS, service, script, and traceroute information."
        echo
        echo "[4] OS fingerprint"
        echo "    Analyzes OS fingerprint information."
        echo
        echo "[5] OS + default scripts"
        echo "    Combines OS detection with default NSE scripts."
        echo
        echo "[6] OS guess"
        echo "    Provides an OS guess based on fingerprinting."
        echo
        echo "[7] OS + traceroute"
        echo "    Shows OS information together with the route."
        echo
        echo "[8] OS + version + scripts"
        echo "    Collects OS, service, and NSE information together."
        echo
        echo "[9] Aggressive OS guess"
        echo "    Performs OS detection with a more extensive guess."
        echo
        echo "[10] OS + all TCP"
        echo "     Combines OS detection with all TCP ports."
        echo
        echo "[0] Return to main menu"
        echo
        echo "====================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "OS detection" -O "$TARGET"
                ;;

            2)
                target_input || continue
                run_scan "OS + service versions" -O -sV "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "Aggressive detection" -A "$TARGET"
                ;;

            4)
                target_input || continue
                run_scan "OS fingerprint" -O "$TARGET"
                ;;

            5)
                target_input || continue
                run_scan "OS + default scripts" -O -sC "$TARGET"
                ;;

            6)
                target_input || continue
                run_scan "OS guess" -O --osscan-guess "$TARGET"
                ;;

            7)
                target_input || continue
                run_scan "OS + traceroute" -O --traceroute "$TARGET"
                ;;

            8)
                target_input || continue
                run_scan "OS + version + scripts" -O -sV -sC "$TARGET"
                ;;

            9)
                target_input || continue
                run_scan "Aggressive OS guess" -O --osscan-guess -T4 "$TARGET"
                ;;

            10)
                target_input || continue
                run_scan "OS + all TCP" -O -p- "$TARGET"
                ;;

            0)
                return
                ;;

            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 4. FIREWALL / FILTER
# ==========================================================

firewall_scans() {

    while true; do
        banner

        echo "============= FIREWALL / FILTER TESTING ============="
        echo
        echo "[1] ACK scan"
        echo "    Helps analyze firewall/filter behavior."
        echo
        echo "[2] SYN scan"
        echo "    Performs a SYN-based port scan."
        echo
        echo "[3] FIN scan"
        echo "    Checks filter behavior using FIN packets."
        echo
        echo "[4] Xmas scan"
        echo "    Checks filter behavior using Xmas flags."
        echo
        echo "[5] Null scan"
        echo "    Performs a TCP scan without flags."
        echo
        echo "[6] TCP Connect"
        echo "    Checks ports using a normal TCP connection."
        echo
        echo "[7] Fragmented packets"
        echo "    Performs a scan using packet fragmentation."
        echo
        echo "[8] Ping bypass"
        echo "    Skips host discovery and performs the scan."
        echo
        echo "[9] No ping + SYN"
        echo "    Performs a SYN scan without pinging the target."
        echo
        echo "[10] ACK + traceroute"
        echo "     Provides ACK scan and route information together."
        echo
        echo "[0] Return to main menu"
        echo
        echo "====================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in
            1)
                target_input || continue
                run_scan "ACK firewall test" -sA "$TARGET"
                ;;
            2)
                target_input || continue
                run_scan "SYN firewall test" -sS "$TARGET"
                ;;
            3)
                target_input || continue
                run_scan "FIN firewall test" -sF "$TARGET"
                ;;
            4)
                target_input || continue
                run_scan "Xmas firewall test" -sX "$TARGET"
                ;;
            5)
                target_input || continue
                run_scan "Null firewall test" -sN "$TARGET"
                ;;
            6)
                target_input || continue
                run_scan "TCP Connect filter test" -sT "$TARGET"
                ;;
            7)
                target_input || continue
                run_scan "Fragmented packets" -f "$TARGET"
                ;;
            8)
                target_input || continue
                run_scan "Ping bypass" -Pn "$TARGET"
                ;;
            9)
                target_input || continue
                run_scan "No ping + SYN" -Pn -sS "$TARGET"
                ;;
            10)
                target_input || continue
                run_scan "ACK + traceroute" -sA --traceroute "$TARGET"
                ;;
            0)
                return
                ;;
            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 5. NSE SCRIPT SCANNING
# ==========================================================

nse_scans() {

    while true; do
        banner

        echo "================ NSE SCRIPT SCANNING ================="
        echo
        echo "[1] Default NSE"
        echo "    Runs the standard NSE scripts."
        echo
        echo "[2] Safe NSE"
        echo "    Runs scripts from the safe category."
        echo
        echo "[3] Discovery NSE"
        echo "    Collects information using discovery scripts."
        echo
        echo "[4] Version + NSE"
        echo "    Runs service version detection and NSE scripts."
        echo
        echo "[5] HTTP NSE"
        echo "    Runs NSE scripts related to HTTP."
        echo
        echo "[6] SSH NSE"
        echo "    Runs NSE scripts related to SSH."
        echo
        echo "[7] SMB NSE"
        echo "    Runs NSE scripts related to SMB."
        echo
        echo "[8] FTP NSE"
        echo "    Runs NSE scripts related to FTP."
        echo
        echo "[9] DNS NSE"
        echo "    Runs NSE scripts related to DNS."
        echo
        echo "[10] Vulnerability NSE"
        echo "     Runs scripts from the vulnerability category."
        echo
        echo "[0] Return to main menu"
        echo
        echo "======================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in
            1)
                target_input || continue
                run_scan "Default NSE" -sC "$TARGET"
                ;;
            2)
                target_input || continue
                run_scan "Safe NSE" --script safe "$TARGET"
                ;;
            3)
                target_input || continue
                run_scan "Discovery NSE" --script discovery "$TARGET"
                ;;
            4)
                target_input || continue
                run_scan "Version + NSE" -sV -sC "$TARGET"
                ;;
            5)
                target_input || continue
                run_scan "HTTP NSE" --script 'http-*' "$TARGET"
                ;;
            6)
                target_input || continue
                run_scan "SSH NSE" --script 'ssh-*' -p 22 "$TARGET"
                ;;
            7)
                target_input || continue
                run_scan "SMB NSE" --script 'smb-*' -p 139,445 "$TARGET"
                ;;
            8)
                target_input || continue
                run_scan "FTP NSE" --script 'ftp-*' -p 21 "$TARGET"
                ;;
            9)
                target_input || continue
                run_scan "DNS NSE" --script 'dns-*' -p 53 "$TARGET"
                ;;
            10)
                target_input || continue
                run_scan "Vulnerability NSE" --script vuln "$TARGET"
                ;;
            0)
                return
                ;;
            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 6. NETWORK DISCOVERY AND TOPOLOGY
# ==========================================================

network_discovery() {

    while true; do
        banner

        echo "============= NETWORK DISCOVERY AND TOPOLOGY ============="
        echo
        echo "[1] Host discovery"
        echo "    Helps identify active hosts."
        echo
        echo "[2] Ping scan"
        echo "    Checks hosts that respond to discovery probes."
        echo
        echo "[3] ARP discovery"
        echo "    Discovers hosts on a local network using ARP."
        echo
        echo "[4] ICMP echo discovery"
        echo "    Checks hosts using ICMP Echo requests."
        echo
        echo "[5] TCP SYN discovery"
        echo "    Performs host discovery using TCP SYN packets."
        echo
        echo "[6] TCP ACK discovery"
        echo "    Performs host discovery using TCP ACK packets."
        echo
        echo "[7] UDP discovery"
        echo "    Performs host discovery using UDP packets."
        echo
        echo "[8] Version detection"
        echo "    Checks service information using version detection."
        echo
        echo "[9] Traceroute"
        echo "    Shows the route to the target."
        echo
        echo "[10] Version + traceroute"
        echo "     Shows service versions and the route."
        echo
        echo "[0] Return to main menu"
        echo
        echo "==========================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in
            1)
                target_input || continue
                run_scan "Host discovery" -sn "$TARGET"
                ;;
            2)
                target_input || continue
                run_scan "Ping scan" -sn "$TARGET"
                ;;
            3)
                target_input || continue
                run_scan "ARP discovery" -PR "$TARGET"
                ;;
            4)
                target_input || continue
                run_scan "ICMP echo discovery" -PE "$TARGET"
                ;;
            5)
                target_input || continue
                run_scan "TCP SYN discovery" -PS "$TARGET"
                ;;
            6)
                target_input || continue
                run_scan "TCP ACK discovery" -PA "$TARGET"
                ;;
            7)
                target_input || continue
                run_scan "UDP discovery" -PU "$TARGET"
                ;;
            8)
                target_input || continue
                run_scan "Version detection" -sV "$TARGET"
                ;;
            9)
                target_input || continue
                run_scan "Traceroute" --traceroute "$TARGET"
                ;;
            10)
                target_input || continue
                run_scan "Version + traceroute" -sV --traceroute "$TARGET"
                ;;
            0)
                return
                ;;
            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 7. TIMING / SPEED
# ==========================================================

timing_scans() {

    while true; do
        banner

        echo "================ TIMING / SPEED ========================"
        echo
        echo "[1] Paranoid timing - T0"
        echo "    One of the slowest timing modes."
        echo
        echo "[2] Sneaky timing - T1"
        echo "    A slow scanning mode."
        echo
        echo "[3] Polite timing - T2"
        echo "    Attempts to reduce the load on the network."
        echo
        echo "[4] Normal timing - T3"
        echo "    Standard timing mode."
        echo
        echo "[5] Aggressive timing - T4"
        echo "    Performs faster scans."
        echo
        echo "[6] Insane timing - T5"
        echo "    Very aggressive speed mode."
        echo
        echo "[7] Minimum rate"
        echo "    Sets the minimum packet rate."
        echo
        echo "[8] Maximum rate"
        echo "    Limits the maximum packet rate."
        echo
        echo "[9] Host timeout"
        echo "    Sets a timeout for the host."
        echo
        echo "[10] Aggressive + version"
        echo "     Combines T4 timing with service version detection."
        echo
        echo "[0] Return to main menu"
        echo
        echo "========================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in
            1)
                target_input || continue
                run_scan "Paranoid timing" -T0 "$TARGET"
                ;;
            2)
                target_input || continue
                run_scan "Sneaky timing" -T1 "$TARGET"
                ;;
            3)
                target_input || continue
                run_scan "Polite timing" -T2 "$TARGET"
                ;;
            4)
                target_input || continue
                run_scan "Normal timing" -T3 "$TARGET"
                ;;
            5)
                target_input || continue
                run_scan "Aggressive timing" -T4 "$TARGET"
                ;;
            6)
                target_input || continue
                run_scan "Insane timing" -T5 "$TARGET"
                ;;
            7)
                target_input || continue
                run_scan "Minimum packet rate" --min-rate 100 "$TARGET"
                ;;
            8)
                target_input || continue
                run_scan "Maximum packet rate" --max-rate 100 "$TARGET"
                ;;
            9)
                target_input || continue
                run_scan "Host timeout" --host-timeout 30s "$TARGET"
                ;;
            10)
                target_input || continue
                run_scan "Aggressive + version" -T4 -sV "$TARGET"
                ;;
            0)
                return
                ;;
            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 8. TARGET SPECIFICATION
# ==========================================================

target_scans() {

    while true; do
        banner

        echo "================ TARGET SPECIFICATION ================="
        echo
        echo "[1] Single host"
        echo "    Scans one IP address or hostname."
        echo
        echo "[2] CIDR network"
        echo "    Scans a network in CIDR format."
        echo
        echo "[3] IP range"
        echo "    Scans an IP address range."
        echo
        echo "[4] Multiple targets"
        echo "    Scans multiple targets together."
        echo
        echo "[5] Hostname + version"
        echo "    Checks service versions using a hostname."
        echo
        echo "[6] IPv6 target"
        echo "    Scans an IPv6 target."
        echo
        echo "[7] Exclude host"
        echo "    Excludes a selected host from the scan."
        echo
        echo "[8] Target list file"
        echo "    Scans targets listed in a file."
        echo
        echo "[9] Random targets"
        echo "    Performs a scan using randomly selected IPs."
        echo
        echo "[10] Network + version"
        echo "     Checks service versions on the specified target/network."
        echo
        echo "[0] Return to main menu"
        echo
        echo "========================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "Single host" "$TARGET"
                ;;

            2)
                target_input || continue
                run_scan "CIDR network" -sn "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "IP range" -sn "$TARGET"
                ;;

            4)
                read -rp "Enter targets (e.g. 192.168.1.1 192.168.1.2): " -a TARGETS

                if [[ ${#TARGETS[@]} -eq 0 ]]; then
                    echo "[!] No targets entered."
                    read -rp "Press Enter..."
                    continue
                fi

                run_scan "Multiple targets" "${TARGETS[@]}"
                ;;

            5)
                target_input || continue
                run_scan "Hostname + version" -sV "$TARGET"
                ;;

            6)
                target_input || continue
                run_scan "IPv6 target" -6 "$TARGET"
                ;;

            7)
                target_input || continue
                read -rp "Host to exclude: " EXCLUDE

                if [[ -z "$EXCLUDE" ]]; then
                    echo "[!] Exclude host cannot be empty."
                    read -rp "Press Enter..."
                    continue
                fi

                run_scan "Exclude host" --exclude "$EXCLUDE" "$TARGET"
                ;;

            8)
                read -rp "Path to target list file: " TARGET_FILE

                if [[ ! -f "$TARGET_FILE" ]]; then
                    echo "[!] File not found."
                    read -rp "Press Enter..."
                    continue
                fi

                run_scan "Target list file" -iL "$TARGET_FILE"
                ;;

            9)
                read -rp "Number of random targets: " COUNT

                if [[ ! "$COUNT" =~ ^[0-9]+$ ]] || (( COUNT < 1 )); then
                    echo "[!] Enter a positive number."
                    read -rp "Press Enter..."
                    continue
                fi

                run_scan "Random targets" -iR "$COUNT"
                ;;

            10)
                target_input || continue
                run_scan "Network + version" -sV "$TARGET"
                ;;

            0)
                return
                ;;

            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 9. SPOOFING / FRAGMENTATION
# ==========================================================

spoof_scans() {

    while true; do
        banner

        echo "=============== SPOOFING / FRAGMENTATION ==============="
        echo
        echo "[1] Fragment packets"
        echo "    Splits packets into fragments."
        echo
        echo "[2] Double fragment"
        echo "    Uses smaller packet fragments."
        echo
        echo "[3] Decoy scan"
        echo "    Uses decoy addresses during the scan."
        echo
        echo "[4] Decoy + SYN"
        echo "    Combines decoys with a SYN scan."
        echo
        echo "[5] Decoy + version"
        echo "    Combines decoys with version detection."
        echo
        echo "[6] Source port"
        echo "    Specifies the source port."
        echo
        echo "[7] Fragment + SYN"
        echo "    Performs a fragmented SYN scan."
        echo
        echo "[8] Fragment + version"
        echo "    Combines fragmentation with version detection."
        echo
        echo "[9] Custom decoys"
        echo "    Allows the user to enter a custom decoy parameter."
        echo
        echo "[10] Fragment + traceroute"
        echo "     Combines fragmented scanning with traceroute."
        echo
        echo "[0] Return to main menu"
        echo
        echo "========================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "Fragment packets" -f "$TARGET"
                ;;

            2)
                target_input || continue
                run_scan "Double fragment" -ff "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "Decoy scan" -D RND:3 "$TARGET"
                ;;

            4)
                target_input || continue
                run_scan "Decoy + SYN" -D RND:3 -sS "$TARGET"
                ;;

            5)
                target_input || continue
                run_scan "Decoy + version" -D RND:3 -sV "$TARGET"
                ;;

            6)
                target_input || continue
                read -rp "Source port (1-65535): " SPORT

                if [[ ! "$SPORT" =~ ^[0-9]+$ ]] || (( SPORT < 1 || SPORT > 65535 )); then
                    echo "[!] Port must be between 1-65535."
                    read -rp "Press Enter..."
                    continue
                fi

                run_scan "Source port" --source-port "$SPORT" "$TARGET"
                ;;

            7)
                target_input || continue
                run_scan "Fragment + SYN" -f -sS "$TARGET"
                ;;

            8)
                target_input || continue
                run_scan "Fragment + version" -f -sV "$TARGET"
                ;;

            9)
                target_input || continue
                read -rp "Decoy parameter (e.g. RND:5): " DECOYS

                if [[ -z "$DECOYS" ]]; then
                    echo "[!] Decoy cannot be empty."
                    read -rp "Press Enter..."
                    continue
                fi

                run_scan "Custom decoys" -D "$DECOYS" "$TARGET"
                ;;

            10)
                target_input || continue
                run_scan "Fragment + traceroute" -f --traceroute "$TARGET"
                ;;

            0)
                return
                ;;

            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 10. COMBINATION SCANS
# ==========================================================

combination_scans() {

    while true; do
        banner

        echo "================ COMBINATION SCANS =================="
        echo
        echo "[1] SYN + Version"
        echo "    Combines SYN scanning with service version detection."
        echo
        echo "[2] SYN + OS"
        echo "    Combines SYN scanning with OS detection."
        echo
        echo "[3] SYN + OS + Version"
        echo "    Collects SYN, OS, and service information."
        echo
        echo "[4] Aggressive scan"
        echo "    Performs a broad enumeration scan."
        echo
        echo "[5] SYN + Default scripts"
        echo "    Combines SYN scanning with default NSE scripts."
        echo
        echo "[6] All TCP + Version"
        echo "    Checks all TCP ports and service versions."
        echo
        echo "[7] All TCP + OS"
        echo "    Combines all TCP ports with OS detection."
        echo
        echo "[8] UDP + Version"
        echo "    Checks UDP ports and service versions."
        echo
        echo "[9] Full enumeration"
        echo "    Provides OS, version, scripts, and traceroute information."
        echo
        echo "[10] Fast enumeration"
        echo "     Performs fast port and version enumeration."
        echo
        echo "[0] Return to main menu"
        echo
        echo "======================================================="

        read -rp "Enter your choice: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "SYN + Version" -sS -sV "$TARGET"
                ;;

            2)
                target_input || continue
                run_scan "SYN + OS" -sS -O "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "SYN + OS + Version" -sS -O -sV "$TARGET"
                ;;

            4)
                target_input || continue
                run_scan "Aggressive scan" -A "$TARGET"
                ;;

            5)
                target_input || continue
                run_scan "SYN + Default scripts" -sS -sC "$TARGET"
                ;;

            6)
                target_input || continue
                run_scan "All TCP + Version" -p- -sV "$TARGET"
                ;;

            7)
                target_input || continue
                run_scan "All TCP + OS" -p- -O "$TARGET"
                ;;

            8)
                target_input || continue
                run_scan "UDP + Version" -sU -sV "$TARGET"
                ;;

            9)
                target_input || continue
                run_scan "Full enumeration" -A -p- "$TARGET"
                ;;

            10)
                target_input || continue
                run_scan "Fast enumeration" -F -sV "$TARGET"
                ;;

            0)
                return
                ;;

            *)
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# MAIN MENU
# ==========================================================

main_menu() {

    check_nmap

    while true; do

        banner

        echo "[1]  Port Scanning"
        echo "[2]  Service / Version Detection"
        echo "[3]  OS Detection"
        echo "[4]  Firewall / Filter Testing"
        echo "[5]  NSE Script Scanning"
        echo "[6]  Network Discovery and Topology"
        echo "[7]  Timing / Speed Options"
        echo "[8]  Target Specification"
        echo "[9]  Spoofing / Fragmentation"
        echo "[10] Combination Scans"
        echo
        echo "[99] Exit"
        echo
        echo "============================================================"

        read -rp "Enter your choice: " MENU

        case "$MENU" in

            1)
                port_scans
                ;;

            2)
                service_scans
                ;;

            3)
                os_detection
                ;;

            4)
                firewall_scans
                ;;

            5)
                nse_scans
                ;;

            6)
                network_discovery
                ;;

            7)
                timing_scans
                ;;

            8)
                target_scans
                ;;

            9)
                spoof_scans
                ;;

            10)
                combination_scans
                ;;

            99)
                clear
                echo
                echo "============================================================"
                echo "                         ELCIN TOOL"
                echo "                       Exiting program..."
                echo "============================================================"
                echo
                exit 0
                ;;

            *)
                echo
                echo "[!] Invalid choice."
                sleep 1
                ;;
        esac
    done
}

main_menu
