# ReportedIP Blacklist

A daily snapshot of the IP addresses the ReportedIP community currently rates as attackers. Free under CC BY 4.0.

> **This repository is a snapshot, not a live feed.** It is rebuilt once a day, and a new address only shows up here 48 hours after its first report. An attacker who started this morning is not in these files yet. To block with current data, take it from the source:

| You protect | Use | Data | Cost |
|---|---|---|---|
| **A WordPress site** | [ReportedIP Hive](https://reportedip.com/products/wordpress-plugin/), the WordPress security plugin | Live reputation lookups against the network, plus 16 local attack sensors, a firewall and 2FA | Free |
| **A Linux server** (web, mail, FTP, DNS) | [ReportedIP Agent](https://reportedip.com/products/linux-agent/), one static binary | The community list in ipset or nftables, refreshed every 15 minutes, plus detection in your own logs | One server included from Professional |
| **Your own firewall, SIEM or script** | The [ReportedIP API](https://reportedip.com/products/api/) | `GET /check` per address in real time, `GET /blacklist` as a current list with ETag | `/check` free, 1,000 per day. `/blacklist` from Contributor |

A free account takes a minute: **[reportedip.com/register](https://reportedip.com/register/)**

Use the files in this repository where a daily list is good enough: a lab, a one-off import, research, or a firewall that cannot reach an API.

---

## Kurz auf Deutsch

Dieses Repository ist ein **täglicher Schnappschuss** der ReportedIP-Blacklist. Neue Angreifer erscheinen hier erst nach 48 Stunden. Für aktuellen Schutz gibt es die Live-Quellen:

- **WordPress:** [ReportedIP Hive](https://reportedip.com/products/wordpress-plugin/), kostenlos, prüft jede Anfrage live gegen das Netzwerk.
- **Linux-Server:** [ReportedIP Agent](https://reportedip.com/products/linux-agent/), lädt die Liste alle 15 Minuten in ipset oder nftables und meldet Angriffe aus den eigenen Logs.
- **Eigene Integration:** die [ReportedIP API](https://reportedip.com/products/api/). Einzelprüfungen sind kostenlos, die Live-Liste gibt es ab Contributor.

Die Dateien hier eignen sich für Tests, einmalige Importe, Forschung oder Firewalls ohne API-Zugang.

---

## How an address gets in, and out

- Every address comes from the ReportedIP reputation engine: reports from WordPress sites, Linux servers and honeypots, weighted by age, reporter diversity, severity and honeypot evidence. How the score works: [Confidence score](https://reportedip.com/docs/api/confidence-score/).
- Only addresses with a confidence score of **75 or higher** are listed.
- Known legitimate networks (major search engines, CDNs) are excluded.
- **Addresses leave on their own.** Two weeks after the last report, a score starts to halve every 30 days. An address that stops attacking drops out of this list within a few weeks. If new reports lift it back to 75, it returns with the next daily snapshot, the 48-hour wait only applies to its first report. This is also why the file can shrink from one day to the next.
- Listed in error? [Request a delisting](https://reportedip.com/docs/support/ip-delisting/).

---

## Files

```
reportedip-blacklist/
├── blacklist-all.txt        All addresses, one per line
├── blacklist-all.json       All addresses with confidence and category ids
├── blacklist-all.csv        ip, confidence, categories, last_reported
├── lists/                   The same addresses, split by attack type
├── formats/                 Ready-made nginx, Apache and iptables configs
├── metadata.json            Version, counts per list, SHA-256 checksums
└── LICENSE                  CC BY 4.0
```

### Thematic lists

| File | Attack type | Category ids |
|---|---|---|
| `lists/spam.txt` | Web, email and blog spam | 10, 11, 12 |
| `lists/brute-force.txt` | FTP, SSH and login brute force | 5, 18, 22 |
| `lists/cms-login.txt` | WordPress, Drupal and CMS backend logins | 5, 15, 18, 19, 21 |
| `lists/web-attacks.txt` | SQL injection, hacking, bad bots, web app attacks | 15, 16, 19, 21 |
| `lists/malware.txt` | Ransomware, trojans, crypto mining | 20, 24, 25, 26, 27 |
| `lists/ddos.txt` | DDoS, ping of death | 4, 6 |
| `lists/fraud.txt` | Phishing, fraud, spoofing | 3, 7, 8, 17 |
| `lists/infrastructure.txt` | DNS abuse, open proxy, port scan | 1, 2, 9, 14 |
| `lists/apt.txt` | IoT botnet, supply chain, zero day, nation-state APT | 23, 28, 29, 30 |

An address can appear in several lists. All category ids and their names: [Threat categories](https://reportedip.com/docs/api/threat-categories/).

### blacklist-all.json

```json
{
  "meta": { "totalIPs": 1, "generatedAt": "2026-10-06T04:20:00+00:00" },
  "entries": [
    { "ip": "1.2.3.4", "confidence": 92, "categories": [18, 31], "source": "dynamic" }
  ]
}
```

### blacklist-all.csv

```
ip,confidence,categories,last_reported
1.2.3.4,92,"18;31","2026-10-06 04:20:00"
```

`categories` holds category ids separated by semicolons.

---

## Usage

```bash
# All addresses
curl -sO https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/blacklist-all.txt

# One attack type
curl -sO https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/lists/brute-force.txt
```

### nginx

```bash
curl -s https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/formats/nginx-deny.conf \
  -o /etc/nginx/conf.d/reportedip-deny.conf
sudo nginx -t && sudo nginx -s reload
```

### Apache

Merge `formats/apache-htaccess.txt` into your `.htaccess` or `httpd.conf`.

### iptables

```bash
curl -s https://raw.githubusercontent.com/reportedip/reportedip-blacklist/main/formats/iptables.sh -o /tmp/reportedip-block.sh
sudo sh /tmp/reportedip-block.sh
```

The repository is rebuilt once a day around 04:20 UTC, so pulling more often gains nothing. A cron job that pulls a snapshot is the point where the [ReportedIP Agent](https://reportedip.com/products/linux-agent/) does the same job every 15 minutes, with sets per service and an atomic swap. For a hand-built setup against the live API, see [Network-level blocking](https://reportedip.com/docs/blocking/firewall/).

---

## Where the data comes from

```
  WordPress sites (ReportedIP Hive)  |
  Linux servers (ReportedIP Agent)   +-->  ReportedIP API  -->  reputation engine  -->  live API, Agent, Hive
  Honeypots                          |                                            \-->  this repository (daily)
```

Source code on GitHub: [reportedip-hive](https://github.com/reportedip/reportedip-hive), [reportedip-hive-light](https://github.com/reportedip/reportedip-hive-light), [honeypot-server](https://github.com/reportedip/honeypot-server).

---

## Disclaimer

These lists are provided as is, without warranty of any kind. Check the data before you use it in production. The operator is not liable for damage caused by using these lists.

Diese Listen werden ohne Gewähr bereitgestellt. Prüfen Sie die Daten vor dem produktiven Einsatz. Der Betreiber haftet nicht für Schäden durch die Nutzung.

## Contact

False positive or abuse report: [abuse@reportedip.com](mailto:abuse@reportedip.com) · Website: [reportedip.com](https://reportedip.com)

## License

Copyright (c) 2026 ReportedIP / Patrick Schlesinger. Licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). You may share and adapt the data as long as you credit **ReportedIP** ([reportedip.com](https://reportedip.com)).

*Generated by [ReportedIP](https://reportedip.com) on 2026-10-06.*