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
        echo "[!] Nmap sistemde qurasdirilmiyib."
        echo "[*] Qurasdirmag ucun:"
        echo "    sudo apt install nmap"
        exit 1
    fi
}

target_input() {
    echo
    echo "============================================================"
    read -rp "Target IP / Host daxil edin: " TARGET

    if [[ -z "$TARGET" ]]; then
        echo "[!] Target bos ola bilmez."
        read -rp "Davam etmek ucun Enter basin..."
        return 1
    fi

    return 0
}

port_input() {
    read -rp "Port(lar) daxil edin (mes: 22,80,443): " PORTS

    if [[ -z "$PORTS" ]]; then
        echo "[!] Port bos ola bilmez."
        return 1
    fi

    if [[ ! "$PORTS" =~ ^[0-9,-]+$ ]]; then
        echo "[!] Port formatinda yalniz reqem, vergul ve tire istifade edin."
        return 1
    fi

    return 0
}

run_scan() {
    local DESCRIPTION="$1"
    shift

    echo
    echo "------------------------------------------------------------"
    echo "Secilmis funksiya:"
    echo "$DESCRIPTION"
    echo "------------------------------------------------------------"
    echo
    echo "Nmap emri:"
    printf 'nmap'
    printf ' %q' "$@"
    echo
    echo
    echo "Scan basladilir..."
    echo "------------------------------------------------------------"
    echo

    nmap "$@"

    echo
    echo "------------------------------------------------------------"
    read -rp "Davam etmek ucun Enter basin..."
}

# ==========================================================
# 1. PORT TARAMALARI
# ==========================================================

port_scans() {

    while true; do
        banner

        echo "================== PORT TARAMALARI =================="
        echo
        echo "[1] Sürətli port taramasi"
        echo "    En çox istifade olunan portlari tez yoxlayir."
        echo
        echo "[2] Müeyyen portlari tarama"
        echo "    Seçilmis portlarin veziyyetini yoxlayir."
        echo
        echo "[3] Bütün portlari tarama"
        echo "    1-65535 araligindaki TCP portlarini yoxlayir."
        echo
        echo "[4] TCP SYN scan"
        echo "    TCP SYN paketleri ile portlari yoxlayir."
        echo
        echo "[5] TCP Connect scan"
        echo "    Tam TCP bağlantisi yaradaraq portu yoxlayir."
        echo
        echo "[6] UDP scan"
        echo "    UDP portlarini yoxlayir."
        echo
        echo "[7] FIN scan"
        echo "    FIN flag esasli TCP scan aparir."
        echo
        echo "[8] Xmas scan"
        echo "    TCP flag kombinasiyasi ile scan edir."
        echo
        echo "[9] Null scan"
        echo "    TCP flag olmadan scan aparir."
        echo
        echo "[10] ACK scan"
        echo "     Firewall/filter qaydalarini analiz etmeye komek edir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "======================================================"

        read -rp "Seciminizi daxil edin: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "Sürətli port taramasi" -F "$TARGET"
                ;;

            2)
                target_input || continue
                port_input || continue
                run_scan "Müeyyen portlari tarama" -p "$PORTS" "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "Bütün TCP portlarini tarama" -p- "$TARGET"
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
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 2. SERVIS / VERSIYA
# ==========================================================

service_scans() {

    while true; do
        banner

        echo "================ SERVIS / VERSIYA =================="
        echo
        echo "[1] Servis ve versiya tesbiti"
        echo "    Açiq portlarda işləyən servis ve versiyalari gösterir."
        echo
        echo "[2] Aqressiv versiya tesbiti"
        echo "    Daha geniş versiya yoxlamasi aparir."
        echo
        echo "[3] Default script + versiya"
        echo "    Default NSE scriptleri ve versiya melumatini birlesdirir."
        echo
        echo "[4] Secilmis portda versiya"
        echo "    Müeyyen portun servis melumatini gösterir."
        echo
        echo "[5] Web servisleri"
        echo "    HTTP/HTTPS portlarini ve versiyalarini yoxlayir."
        echo
        echo "[6] SSH servisi"
        echo "    SSH servisinin versiyasini yoxlayir."
        echo
        echo "[7] FTP servisi"
        echo "    FTP servisinin versiyasini yoxlayir."
        echo
        echo "[8] SMB servisi"
        echo "    SMB servislerinin versiyasini yoxlayir."
        echo
        echo "[9] SMTP servisi"
        echo "    SMTP servislerinin versiyasini yoxlayir."
        echo
        echo "[10] Servis + OS"
        echo "     Servis versiyasi ve OS melumatini birlikde verir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "====================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "Servis ve versiya tesbiti" -sV "$TARGET"
                ;;

            2)
                target_input || continue
                run_scan "Aqressiv versiya tesbiti" -sV --version-intensity 9 "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "Default script + versiya" -sC -sV "$TARGET"
                ;;

            4)
                target_input || continue
                port_input || continue
                run_scan "Secilmis portda versiya" -sV -p "$PORTS" "$TARGET"
                ;;

            5)
                target_input || continue
                run_scan "Web servisleri" -sV -p 80,443 "$TARGET"
                ;;

            6)
                target_input || continue
                run_scan "SSH servisi" -sV -p 22 "$TARGET"
                ;;

            7)
                target_input || continue
                run_scan "FTP servisi" -sV -p 21 "$TARGET"
                ;;

            8)
                target_input || continue
                run_scan "SMB servisi" -sV -p 139,445 "$TARGET"
                ;;

            9)
                target_input || continue
                run_scan "SMTP servisi" -sV -p 25,465,587 "$TARGET"
                ;;

            10)
                target_input || continue
                run_scan "Servis + OS" -sV -O "$TARGET"
                ;;

            0)
                return
                ;;

            *)
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 3. OS TESBITI
# ==========================================================

os_detection() {

    while true; do
        banner

        echo "=================== OS TESBITI ====================="
        echo
        echo "[1] OS tesbiti"
        echo "    Hedef sistemin ehtimal olunan OS-unu müəyyən edir."
        echo
        echo "[2] OS + servis versiyalari"
        echo "    OS ve servis versiyalarini birlikde yoxlayir."
        echo
        echo "[3] Aqressiv tesbit"
        echo "    OS, servis, script ve traceroute melumatlari toplayir."
        echo
        echo "[4] OS fingerprint"
        echo "    OS fingerprint melumatlarini analiz edir."
        echo
        echo "[5] OS + default scripts"
        echo "    OS yoxlamasini default NSE scriptleri ile birlesdirir."
        echo
        echo "[6] OS guess"
        echo "    OS fingerprint melumatindan ehtimal verir."
        echo
        echo "[7] OS + traceroute"
        echo "    OS melumati ile marşrutu birlikde gösterir."
        echo
        echo "[8] OS + version + scripts"
        echo "    OS, servis ve NSE melumatlarini birlikde toplayir."
        echo
        echo "[9] Aggressive OS guess"
        echo "    OS tesbitini daha geniş guess ile aparir."
        echo
        echo "[10] OS + all TCP"
        echo "     Bütün TCP portlari ile OS tesbitini birlesdirir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "====================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

        case "$CHOICE" in

            1)
                target_input || continue
                run_scan "OS tesbiti" -O "$TARGET"
                ;;

            2)
                target_input || continue
                run_scan "OS + servis versiyalari" -O -sV "$TARGET"
                ;;

            3)
                target_input || continue
                run_scan "Aqressiv tesbit" -A "$TARGET"
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
                echo "[!] Yanlis seçim."
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

        echo "============= FIREWALL / FILTER KONTROLLERI ============="
        echo
        echo "[1] ACK scan"
        echo "    Firewall/filter veziyyetini analiz etmeye komek edir."
        echo
        echo "[2] SYN scan"
        echo "    SYN esasli port yoxlamasi aparir."
        echo
        echo "[3] FIN scan"
        echo "    FIN paketleri ile filter davranisini yoxlayir."
        echo
        echo "[4] Xmas scan"
        echo "    Xmas flagleri ile filter davranisini yoxlayir."
        echo
        echo "[5] Null scan"
        echo "    Flag olmadan TCP scan aparir."
        echo
        echo "[6] TCP Connect"
        echo "    Normal TCP connection ile portlari yoxlayir."
        echo
        echo "[7] Fragmented packets"
        echo "    Paket fragmentasiyasi ile scan edir."
        echo
        echo "[8] Ping bypass"
        echo "    Host discovery-i kecerek scan edir."
        echo
        echo "[9] No ping + SYN"
        echo "    Ping etmədən SYN scan aparir."
        echo
        echo "[10] ACK + traceroute"
        echo "     ACK scan ve marşrut melumatini birlikde verir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "========================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

        case "$CHOICE" in
            1)
                target_input || continue
                run_scan "ACK firewall testi" -sA "$TARGET"
                ;;
            2)
                target_input || continue
                run_scan "SYN firewall testi" -sS "$TARGET"
                ;;
            3)
                target_input || continue
                run_scan "FIN firewall testi" -sF "$TARGET"
                ;;
            4)
                target_input || continue
                run_scan "Xmas firewall testi" -sX "$TARGET"
                ;;
            5)
                target_input || continue
                run_scan "Null firewall testi" -sN "$TARGET"
                ;;
            6)
                target_input || continue
                run_scan "TCP Connect filter testi" -sT "$TARGET"
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
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 5. NSE SCRIPT TARAMALARI
# ==========================================================

nse_scans() {

    while true; do
        banner

        echo "================ NSE SCRIPT TARAMALARI ================="
        echo
        echo "[1] Default NSE"
        echo "    Standart NSE scriptlerini işledir."
        echo
        echo "[2] Safe NSE"
        echo "    Safe kateqoriyasindaki scriptleri işledir."
        echo
        echo "[3] Discovery NSE"
        echo "    Discovery scriptleri ile melumat toplayir."
        echo
        echo "[4] Version + NSE"
        echo "    Servis versiyasi ve NSE scriptlerini işledir."
        echo
        echo "[5] HTTP NSE"
        echo "    HTTP ile bagli NSE scriptlerini işledir."
        echo
        echo "[6] SSH NSE"
        echo "    SSH ile bagli NSE scriptlerini işledir."
        echo
        echo "[7] SMB NSE"
        echo "    SMB ile bagli NSE scriptlerini işledir."
        echo
        echo "[8] FTP NSE"
        echo "    FTP ile bagli NSE scriptlerini işledir."
        echo
        echo "[9] DNS NSE"
        echo "    DNS ile bagli NSE scriptlerini işledir."
        echo
        echo "[10] Vulnerability NSE"
        echo "     Vulnerability kateqoriyasini işledir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "========================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

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
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 6. AG KESFI VE TOPOLOGIYA
# ==========================================================

network_discovery() {

    while true; do
        banner

        echo "================ AG KESFI VE TOPOLOGIYA ================="
        echo
        echo "[1] Host discovery"
        echo "    Aktiv hostlari aşkar etmeye komek edir."
        echo
        echo "[2] Ping scan"
        echo "    Cavab veren hostlari yoxlayir."
        echo
        echo "[3] ARP discovery"
        echo "    Lokal şebekede ARP ile hostlari aşkar edir."
        echo
        echo "[4] ICMP echo discovery"
        echo "    ICMP Echo ile hostlari yoxlayir."
        echo
        echo "[5] TCP SYN discovery"
        echo "    TCP SYN ile host discovery edir."
        echo
        echo "[6] TCP ACK discovery"
        echo "    TCP ACK ile host discovery edir."
        echo
        echo "[7] UDP discovery"
        echo "    UDP paketleri ile host discovery edir."
        echo
        echo "[8] Discovery + version"
        echo "    Host discovery ve servis melumatini birlikde yoxlayir."
        echo
        echo "[9] Traceroute"
        echo "    Hedefe gedən marşrutu gösterir."
        echo
        echo "[10] Version + traceroute"
        echo "     Servis versiyasi ve marşrutu gösterir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "========================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

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
                run_scan "Discovery + version" -sV "$TARGET"
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
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 7. HIZ / ZAMANLAMA
# ==========================================================

timing_scans() {

    while true; do
        banner

        echo "================ HIZ / ZAMANLAMA ======================="
        echo
        echo "[1] Paranoid timing - T0"
        echo "    En yavaş timing rejimlerinden biridir."
        echo
        echo "[2] Sneaky timing - T1"
        echo "    Yavaş scan rejimidir."
        echo
        echo "[3] Polite timing - T2"
        echo "    Şebekeye daha az yük vermeye çalışir."
        echo
        echo "[4] Normal timing - T3"
        echo "    Standart timing rejimidir."
        echo
        echo "[5] Aggressive timing - T4"
        echo "    Daha sürətli scan aparir."
        echo
        echo "[6] Insane timing - T5"
        echo "    Çox aqressiv sürət rejimidir."
        echo
        echo "[7] Minimum rate"
        echo "    Minimum paket sürətini təyin edir."
        echo
        echo "[8] Maximum rate"
        echo "    Maksimum paket sürətini məhdudlaşdırır."
        echo
        echo "[9] Host timeout"
        echo "    Host üçün timeout təyin edir."
        echo
        echo "[10] Aggressive + version"
        echo "     T4 ve servis versiya tesbitini birlesdirir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "========================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

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
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 8. HEDEF BELIRLEME
# ==========================================================

target_scans() {

    while true; do
        banner

        echo "================ HEDEF BELIRLEME ======================="
        echo
        echo "[1] Single host"
        echo "    Bir IP veya hostname tarayir."
        echo
        echo "[2] CIDR network"
        echo "    CIDR formatinda şebekeni tarayir."
        echo
        echo "[3] IP range"
        echo "    IP araligini tarayir."
        echo
        echo "[4] Multiple targets"
        echo "    Bir neçe targeti birlikde tarayir."
        echo
        echo "[5] Hostname + version"
        echo "    Hostname üzerinden servis versiyasini yoxlayir."
        echo
        echo "[6] IPv6 target"
        echo "    IPv6 hədəfi tarayir."
        echo
        echo "[7] Exclude host"
        echo "    Seçilmiş hostu scan-dan çıxarır."
        echo
        echo "[8] Target list file"
        echo "    Faylda olan targetleri tarayir."
        echo
        echo "[9] Random targets"
        echo "    Random IP-lər seçərək scan aparir."
        echo
        echo "[10] Network + version"
        echo "     Şebekede servis versiyalarini yoxlayir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "========================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

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
                read -rp "Targetleri daxil edin (mes: 192.168.1.1 192.168.1.2): " -a TARGETS

                if [[ ${#TARGETS[@]} -eq 0 ]]; then
                    echo "[!] Target daxil edilmeyib."
                    read -rp "Enter basin..."
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
                read -rp "Exclude ediləcək host: " EXCLUDE

                if [[ -z "$EXCLUDE" ]]; then
                    echo "[!] Exclude host bos ola bilmez."
                    read -rp "Enter basin..."
                    continue
                fi

                run_scan "Exclude host" --exclude "$EXCLUDE" "$TARGET"
                ;;

            8)
                read -rp "Target faylinin yolu: " TARGET_FILE

                if [[ ! -f "$TARGET_FILE" ]]; then
                    echo "[!] Fayl tapilmadi."
                    read -rp "Enter basin..."
                    continue
                fi

                run_scan "Target list file" -iL "$TARGET_FILE"
                ;;

            9)
                read -rp "Neçə random target: " COUNT

                if [[ ! "$COUNT" =~ ^[0-9]+$ ]] || (( COUNT < 1 )); then
                    echo "[!] Musbet reqem daxil edin."
                    read -rp "Enter basin..."
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
                echo "[!] Yanlis seçim."
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
        echo "    Paketleri fragmentlere bölür."
        echo
        echo "[2] Double fragment"
        echo "    Daha kiçik fragmentlərdən istifadə edir."
        echo
        echo "[3] Decoy scan"
        echo "    Decoy ünvanlari ile scan görüntüsü yaradir."
        echo
        echo "[4] Decoy + SYN"
        echo "    Decoy ve SYN scan birlikde işledilir."
        echo
        echo "[5] Decoy + version"
        echo "    Decoy ve version detection birlikde işleyir."
        echo
        echo "[6] Source port"
        echo "    Mənbə portunu təyin edir."
        echo
        echo "[7] Fragment + SYN"
        echo "    Fragment edilmiş SYN scan aparir."
        echo
        echo "[8] Fragment + version"
        echo "    Fragment ve version detection birlikde işleyir."
        echo
        echo "[9] Custom decoys"
        echo "    İstifadəçi decoy parametri daxil edir."
        echo
        echo "[10] Fragment + traceroute"
        echo "     Fragment scan ve traceroute birlikde işleyir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "========================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

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
                    echo "[!] Port 1-65535 araliginda olmalidir."
                    read -rp "Enter basin..."
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
                read -rp "Decoy parametri (mes: RND:5): " DECOYS

                if [[ -z "$DECOYS" ]]; then
                    echo "[!] Decoy bos ola bilmez."
                    read -rp "Enter basin..."
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
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# 10. KOMBINASIYA SCANLERI
# ==========================================================

combination_scans() {

    while true; do
        banner

        echo "================ KOMBINASIYA SCANLERI =================="
        echo
        echo "[1] SYN + Version"
        echo "    SYN scan ve servis versiyasini birlesdirir."
        echo
        echo "[2] SYN + OS"
        echo "    SYN scan ve OS tesbitini birlesdirir."
        echo
        echo "[3] SYN + OS + Version"
        echo "    SYN, OS ve servis melumatlarini toplayir."
        echo
        echo "[4] Aggressive scan"
        echo "    Geniş enumeration scanidir."
        echo
        echo "[5] SYN + Default scripts"
        echo "    SYN ve default NSE scriptlerini birlesdirir."
        echo
        echo "[6] All TCP + Version"
        echo "    Bütün TCP portlari ve versiyalari yoxlayir."
        echo
        echo "[7] All TCP + OS"
        echo "    Bütün TCP portlari ve OS tesbitini birlesdirir."
        echo
        echo "[8] UDP + Version"
        echo "    UDP portlari ve servis versiyalarini yoxlayir."
        echo
        echo "[9] Full enumeration"
        echo "    OS, version, scripts ve traceroute melumatlarini verir."
        echo
        echo "[10] Fast enumeration"
        echo "     Sürətli port ve versiya enumeration aparir."
        echo
        echo "[0] Esas menyuya qayit"
        echo
        echo "========================================================="

        read -rp "Seciminizi daxil edin: " CHOICE

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
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

# ==========================================================
# ESAS MENU
# ==========================================================

main_menu() {

    check_nmap

    while true; do

        banner

        echo "[1]  Port Taramalari"
        echo "[2]  Servis / Versiya Melumati"
        echo "[3]  OS Tesbiti"
        echo "[4]  Firewall / Filter Kontrolleri"
        echo "[5]  NSE Script Taramalari"
        echo "[6]  Ag Kesfi ve Topologiya"
        echo "[7]  Hiz / Zamanlama Ayarlari"
        echo "[8]  Hedef Belirleme"
        echo "[9]  Spoofing / Fragmentation"
        echo "[10] Kombinasiya Scanleri"
        echo
        echo "[99] Cixis"
        echo
        echo "============================================================"

        read -rp "Seciminizi daxil edin: " MENU

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
                echo "                    Proqramdan cixilir..."
                echo "============================================================"
                echo
                exit 0
                ;;

            *)
                echo
                echo "[!] Yanlis seçim."
                sleep 1
                ;;
        esac
    done
}

main_menu
