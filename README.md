# ELCIN TOOL

## NMAP ASSISTANT TOOL

ELCIN TOOL — Bash ilə hazırlanmış, Nmap istifadəsini daha rahat və sistemli etmək üçün yaradılmış terminal əsaslı köməkçi alətdir.

Tool istifadəçiyə müxtəlif Nmap scan seçimlərini menyu vasitəsilə təqdim edir. İstifadəçi uyğun seçimi etdikdən sonra target IP və ya hostname daxil edir və tool uyğun Nmap əmrini icra edir.

## Xüsusiyyətlər

* 10 əsas scan kateqoriyası
* 100 fərqli Nmap seçimi
* Menyu əsaslı istifadə
* Target IP və hostname dəstəyi
* Port scanning
* Service və version detection
* OS detection
* Firewall/filter yoxlamaları
* NSE script scanning
* Network discovery
* Timing və sürət seçimləri
* Müxtəlif scan kombinasiyaları
* Sadə və istifadəsi rahat Bash interfeysi

## Kateqoriyalar

1. Port Taramaları
2. Servis / Versiya Məlumatı
3. OS Təyini
4. Firewall / Filter Kontrolleri
5. NSE Script Taramaları
6. Şəbəkə Kəşfi və Topologiya
7. Sürət / Timing Ayarları
8. Target Təyini
9. Spoofing / Fragmentation
10. Kombinasiya Scanləri

## Quraşdırma

Repository-ni klonla:

```bash
git clone https://github.com/sariyevtural01-eng/ECIN-TOOL.git
```

Layihə qovluğuna daxil ol:

```bash
cd ECIN-TOOL
```

Toola icra icazəsi ver:

```bash
chmod +x elcin.sh
```

## İstifadə

Toolu başlad:

```bash
./elcin.sh
```

Daha sonra menyudan istədiyin kateqoriyanı və scan seçimini seç.

Məsələn:

```text
1) Port Taramalari
2) Servis / Versiya Melumati
3) OS Tesbiti
...
99) Cixis
```

Seçim etdikdən sonra target daxil edilir və uyğun Nmap əmri icra olunur.

## Tələblər

* Linux
* Bash
* Nmap

Nmap-ın sistemdə olub-olmadığını yoxlamaq üçün:

```bash
nmap --version
```

## Qeyd

Bəzi Nmap scan növləri administrator/root səlahiyyəti tələb edə bilər.

Məsələn:

```bash
sudo ./elcin.sh
```

## Təhlükəsizlik və qanuni istifadə

Bu tool yalnız sahib olduğunuz və ya test etməyə açıq şəkildə icazəniz olan sistemlərdə istifadə edilməlidir.

TryHackMe, Hack The Box və şəxsi laboratoriya mühitləri kimi icazəli test mühitlərində istifadə üçün uyğundur.

İcazəsiz sistemləri scan etmək qanun pozuntusu ola bilər.

## Məqsəd

Bu layihənin əsas məqsədi Nmap komandalarını öyrənən istifadəçilər üçün müxtəlif scan seçimlərini bir menyu altında toplamaq və Nmap istifadəsini daha rahat etməkdir.

## License

Bu layihə MIT License altında yayımlanır.
=
