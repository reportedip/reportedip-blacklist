# ReportedIP Blacklist

Community-driven IP threat intelligence, updated daily.

**[https://reportedip.de](https://reportedip.de)**

> **Die hier veroeffentlichten Daten haben eine Verzoegerung von 48 Stunden gegenueber dem Live-System.**
> Fuer Echtzeit-Bedrohungsdaten per API wenden Sie sich an: **1@reportedip.de**
>
> **The data published here is delayed by 48 hours compared to the live system.**
> For real-time threat intelligence via API, contact: **1@reportedip.de**

---

## Repository-Struktur / Repository Structure

```
reportedip-blacklist/
├── README.md
├── LICENSE                         CC BY 4.0
├── metadata.json                   Version, SHA-256 Checksums, Stats
│
├── blacklist-all.txt               All IPs, one per line
├── blacklist-all.json              All IPs with confidence + categories
├── blacklist-all.csv               ip, confidence, categories, last_reported
│
├── lists/                          Thematic lists
│   ├── spam.txt                    Web / Email / Blog Spam
│   ├── brute-force.txt             FTP / SSH / Login Brute-Force
│   ├── cms-login.txt               WordPress / Drupal / CMS Backend Login
│   ├── web-attacks.txt             SQLi, Hacking, Bots, WebApp Attacks
│   ├── malware.txt                 Ransomware, Trojans, Crypto-Mining
│   ├── ddos.txt                    DDoS, Ping of Death
│   ├── fraud.txt                   Phishing, Fraud, Spoofing
│   ├── infrastructure.txt          DNS Abuse, Open Proxy, Port Scan
│   └── apt.txt                     IoT Botnet, Supply Chain, Zero-Day, APT
│
└── formats/                        Firewall-ready configs
    ├── nginx-deny.conf
    ├── apache-htaccess.txt
    └── iptables.sh
```

---

## Thematische Listen / Thematic Lists

| Datei / File | Beschreibung / Description | Kategorien / Categories |
|---|---|---|
| `lists/spam.txt` | Web-, E-Mail- und Blog-Spam / Web, email & blog spam | 10, 11, 12 |
| `lists/brute-force.txt` | FTP-, SSH- und Login-Brute-Force / FTP, SSH & login brute-force | 5, 18, 22 |
| `lists/cms-login.txt` | WordPress-, Drupal- und CMS-Backend-Login-Angriffe / WordPress, Drupal & CMS backend login attacks | 5, 15, 18, 19, 21 |
| `lists/web-attacks.txt` | SQL-Injection, Hacking, Bots, WebApp-Angriffe / SQLi, hacking, bots, web app attacks | 15, 16, 19, 21 |
| `lists/malware.txt` | Ransomware, Trojaner, Crypto-Mining / Ransomware, trojans, crypto-mining | 20, 24, 25, 26, 27 |
| `lists/ddos.txt` | DDoS-Angriffe, Ping of Death / DDoS attacks, ping of death | 4, 6 |
| `lists/fraud.txt` | Phishing, Betrug, Spoofing / Phishing, fraud, spoofing | 3, 7, 8, 17 |
| `lists/infrastructure.txt` | DNS-Missbrauch, Open Proxy, Port-Scan / DNS abuse, open proxy, port scan | 1, 2, 9, 14 |
| `lists/apt.txt` | IoT-Botnet, Supply-Chain, Zero-Day, staatliche APT / IoT botnet, supply chain, zero-day, nation-state APT | 23, 28, 29, 30 |

Eine IP kann in mehreren thematischen Listen gleichzeitig erscheinen.
An IP may appear in multiple thematic lists at the same time.

---

## Dateiformate / File Formats

### blacklist-all.txt

Einfache Textdatei, eine IP-Adresse pro Zeile. Kommentare beginnen mit `#`.

Plain text, one IP address per line. Comments start with `#`.

### blacklist-all.json

```json
[
  {
    "ip": "1.2.3.4",
    "confidence": 92,
    "categories": ["brute-force", "web-attacks"],
    "last_reported": "2026-02-26T12:00:00+00:00"
  }
]
```

| Feld / Field | Beschreibung / Description |
|---|---|
| `ip` | IPv4- oder IPv6-Adresse bzw. CIDR-Bereich / IPv4 or IPv6 address or CIDR range |
| `confidence` | Vertrauenswert 0 – 100 (hoeher = boesartiger) / Confidence score 0 – 100 (higher = more malicious) |
| `categories` | Zugehoerige thematische Listen / Associated thematic lists |
| `last_reported` | Letzter Meldezeitpunkt (ISO 8601) / Last report timestamp (ISO 8601) |

### blacklist-all.csv

```
ip,confidence,categories,last_reported
1.2.3.4,92,"brute-force;web-attacks",2026-02-26T12:00:00+00:00
```

### metadata.json

Enthaelt Versions-Info, Gesamtanzahl, Aufschluesselung pro Liste und SHA-256-Pruefsummen aller Dateien.

Contains version info, total counts, per-list breakdown, and SHA-256 checksums for all files.

---

## Verwendung / Usage

### Download

```bash
# Alle IPs / All IPs
wget https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/blacklist-all.txt

# Nur Brute-Force-IPs / Brute-force IPs only
curl -sO https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/lists/brute-force.txt

# JSON mit Metadaten / JSON with metadata
curl -s https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/blacklist-all.json | jq '.[0:5]'
```

### iptables (Linux)

```bash
wget -q https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/formats/iptables.sh \
  -O /tmp/reportedip-block.sh
chmod +x /tmp/reportedip-block.sh
sudo /tmp/reportedip-block.sh
```

### Nginx

```bash
wget -q https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/formats/nginx-deny.conf \
  -O /etc/nginx/conf.d/reportedip-deny.conf
sudo nginx -t && sudo nginx -s reload
```

```nginx
# In Ihrem server-Block / In your server block:
include /etc/nginx/conf.d/reportedip-deny.conf;
```

### Apache

```bash
wget -q https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/formats/apache-htaccess.txt \
  -O /tmp/reportedip-deny.txt
```

Fuegen Sie den Inhalt in Ihre `.htaccess` oder `httpd.conf` ein.
Merge the content into your `.htaccess` or `httpd.conf`.

### Automatische Updates (Cron)

```bash
# Taeglich um 04:00 UTC aktualisieren / Update daily at 04:00 UTC
0 4 * * * wget -q https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/formats/iptables.sh -O /tmp/reportedip-block.sh && chmod +x /tmp/reportedip-block.sh && /tmp/reportedip-block.sh
```

---

## Datenqualitaet / Data Quality

- Alle IPs stammen aus dem **ReportedIP Community-Reputationssystem** mit Confidence-Score-Berechnung. / All IPs come from the **ReportedIP community reputation system** with confidence score calculation.
- Nur IPs mit einem Confidence-Score von **>= 75%** werden aufgenommen. / Only IPs with a confidence score of **>= 75%** are included.
- **Whitelist-Pruefung**: Bekannte legitime IPs (z. B. grosse Suchmaschinen, CDN-Anbieter) werden ausgeschlossen. / **Whitelist check**: Known legitimate IPs (e.g. major search engines, CDN providers) are excluded.
- **48-Stunden-Verzoegerung**: Neue Meldungen erscheinen erst nach 48 Stunden in diesen Listen, um Fehlalarme zu reduzieren. / **48-hour delay**: New reports appear in these lists only after 48 hours, reducing false positives.
- **Taegliche Aktualisierung**: Das Repository wird einmal taeglich automatisch aktualisiert. / **Daily updates**: The repository is updated automatically once daily.

---

## Haftungsausschluss / Disclaimer

**Deutsch:** Diese Blacklists werden ohne jegliche Gewaehrleistung bereitgestellt ("as is"). Die Nutzung erfolgt auf eigenes Risiko. Der Betreiber uebernimmt keine Haftung fuer Schaeden, die durch die Verwendung dieser Listen entstehen. Es liegt in der Verantwortung des Nutzers, die Daten vor dem Einsatz in Produktionsumgebungen zu pruefen und zu validieren.

**English:** These blacklists are provided as-is, without any warranty of any kind, express or implied. Use at your own risk. The operator assumes no liability for any damages arising from the use of these lists. It is the user's responsibility to review and validate the data before deploying it in production environments.

---

## Kontakt / Contact

Fehlerhafte Eintraege melden oder eine IP melden / Report a false positive or report an IP:

- **E-Mail:** [abuse@reportedip.de](mailto:abuse@reportedip.de)
- **Web:** [https://reportedip.de](https://reportedip.de)

---

## Lizenz / License

Copyright (c) 2026 ReportedIP / Patrick Schlesinger

Dieses Werk ist lizenziert unter der [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

This work is licensed under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

Sie duerfen das Material teilen und anpassen, solange Sie **ReportedIP** ([reportedip.de](https://reportedip.de)) als Quelle angeben.

You are free to share and adapt the material, as long as you give appropriate credit to **ReportedIP** ([reportedip.de](https://reportedip.de)).

---

*Automatisch generiert von [ReportedIP](https://reportedip.de) am 2026-03-08 / Auto-generated by [ReportedIP](https://reportedip.de) on 2026-03-08*