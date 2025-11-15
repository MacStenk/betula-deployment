# 🎯 Betula Railway Deployment - Projekt-Übersicht

## 📦 Enthaltene Dateien

```
betula-railway/
├── Dockerfile                      # Production-ready Multi-stage Docker Build
├── .dockerignore                   # Docker Build Optimierung
├── .gitignore                      # Git Ignore Rules
├── nixpacks.toml                   # Railway Platform Config
├── LICENSE                         # MIT License für Deployment-Setup
├── README.md                       # Haupt-Dokumentation (User-facing)
├── SETUP.md                        # Schritt-für-Schritt Setup-Guide
├── CHEATSHEET.md                   # Quick-Referenz für häufige Befehle
└── .github/
    └── workflows/
        └── docker-test.yml         # GitHub Actions: Automatische Build-Tests
```

## ✨ Features

### Dockerfile
- ✅ Multi-stage Build (Go builder + Alpine runtime)
- ✅ CGO_ENABLED=1 für SQLite-Support (KRITISCH!)
- ✅ Non-root User (Security Best Practice)
- ✅ Healthcheck für Railway Monitoring
- ✅ Optimierte Image-Größe (~20-30 MB)
- ✅ Timezone & CA-Certificates included

### Railway-Konfiguration
- ✅ Volume-Support für persistent SQLite
- ✅ Automatisches HTTPS via Railway
- ✅ GitHub-basiertes Deployment (Push = Deploy)
- ✅ Nixpacks Config (falls nötig)
- ✅ Port 1738 automatisch gemappt

### Dokumentation
- ✅ Umfassende README mit allen Features
- ✅ Detaillierter Setup-Guide (15-20 Min)
- ✅ Cheatsheet für Daily Operations
- ✅ Troubleshooting-Sektion
- ✅ Backup-Strategien
- ✅ ActivityPub/Fediverse-Setup

## 🚀 Quick Start

### 1. Repository erstellen
```bash
# Auf GitHub:
# 1. Create new repository "betula-railway"
# 2. Upload alle Dateien aus diesem ZIP
# 3. Commit & Push

# Oder lokal:
unzip betula-railway.zip
cd betula-railway
git init
git add .
git commit -m "Initial commit: Betula Railway setup"
git remote add origin https://github.com/DEIN-USERNAME/betula-railway.git
git push -u origin main
```

### 2. Railway deployen
1. railway.app → New Project
2. Deploy from GitHub → Wähle dein Repo
3. Volume hinzufügen: `/data` (1 GB)
4. Domain generieren
5. Admin-User erstellen (siehe SETUP.md)

**Fertig!** 🎉

## 📋 Checkliste nach Deployment

- [ ] GitHub Repo ist online
- [ ] Railway Service läuft (Check Logs)
- [ ] Volume ist gemountet (`/data`)
- [ ] Domain ist erreichbar
- [ ] Admin-User erstellt & Passwort geändert
- [ ] Erster Bookmark funktioniert
- [ ] ActivityPub konfiguriert (falls gewünscht)
- [ ] Backup-Strategie dokumentiert

## 🔧 Wichtige Konfigurationen

### Environment Variables
Betula braucht **keine** Env-Vars für Core-Funktionalität!

Optional (für Custom-Setups):
```bash
TZ=Europe/Berlin          # Timezone (optional)
# PORT wird von Railway automatisch gesetzt
```

### Volume Settings
```
Mount Path: /data
Size: 1 GB (start) → skalierbar auf 5-10 GB
File: /data/bookmarks.betula
```

### Ports
```
Container: 1738
Railway: Automatisch gemappt zu Public URL
```

## 📚 Dokumentations-Guide

**Für Erstsetup:** Lies `SETUP.md` (Schritt-für-Schritt)

**Für Daily Operations:** Nutze `CHEATSHEET.md` (Quick-Referenz)

**Für Features & Details:** Lies `README.md` (Comprehensive Guide)

**Für Troubleshooting:** 
1. README.md → Troubleshooting Section
2. CHEATSHEET.md → Troubleshooting Commands
3. Railway Logs checken
4. GitHub Issues öffnen

## 🎯 Deployment-Strategie

### Production-Ready Features
- ✅ SQLite mit WAL-Mode (Performance)
- ✅ Volume-basierte Persistenz (kein Datenverlust)
- ✅ Non-root User (Security)
- ✅ Healthchecks (Monitoring)
- ✅ Optimiertes Image (klein & schnell)
- ✅ HTTPS automatisch (Railway)

### Best Practices
- ✅ Git-based Deployment (Push = Deploy)
- ✅ Environment-agnostic (keine Secrets im Code)
- ✅ Documentation-first (alle Schritte dokumentiert)
- ✅ Template-ready (andere können es nutzen)

## 🔒 Security

### Included
- HTTPS automatisch via Railway/Let's Encrypt
- Non-root Docker User (UID 1000)
- No secrets in repository
- SQLite-only (kein external DB-Zugriff nötig)

### User-Action Required
- Passwort nach erstem Login ändern!
- Backup-Strategie implementieren
- Railway Notifications aktivieren

## 💾 Backup-Empfehlungen

### Railway Volume Backups
Je nach Railway-Plan: Automatische Snapshots

### Manuelle Backups
```bash
# Täglich via Cron (lokal):
0 3 * * * cd /pfad/zu/betula-railway && ./backup.sh
```

Siehe `CHEATSHEET.md` für Backup-Script.

### Restore-Strategie
1. SQLite-Dump restore via Railway CLI
2. Oder: Volume-Snapshot restore via Railway Dashboard

## 🌐 ActivityPub / Fediverse

### Setup
1. Custom Domain konfigurieren (wichtig für Federation!)
2. Betula Settings → Enable ActivityPub
3. Your Handle: `@username@deine-domain.de`

### Testen
```bash
# WebFinger
curl https://deine-domain.de/.well-known/webfinger?resource=acct:admin@deine-domain.de

# Von Mastodon/Fediverse:
# Suche nach: @admin@deine-domain.de
# Follow → Du siehst Bookmarks in Timeline!
```

## 📊 Resource Requirements

### Small (bis 10k Bookmarks)
- RAM: 256 MB
- Volume: 1 GB
- Railway Plan: Hobby ($5/mo ausreichend)

### Medium (bis 50k Bookmarks)
- RAM: 512 MB
- Volume: 5 GB
- Railway Plan: Developer ($20/mo)

### Large (100k+ Bookmarks)
- RAM: 1 GB
- Volume: 10 GB
- Railway Plan: Team ($100/mo)

## 🔄 Update-Strategie

### Betula Updates
```bash
# Dockerfile: Ändere Git-Tag
RUN git clone --branch v1.2.3 https://codeberg.org/bouncepaw/betula.git .

# Commit & Push → Railway deployt automatisch
```

### Railway Platform
Railway updated automatisch. Check Dashboard für Ankündigungen.

### Deployment-Setup Updates
```bash
# Dieses Template-Repo pullen
git pull template main

# Review changes
git diff

# Merge bei Bedarf
```

## 🤝 Als Template nutzen

### Für eigene Instance
1. Fork dieses Repo
2. Passe README.md an (Domain, Name, etc.)
3. Deploy auf Railway
4. Share mit Community!

### Für andere teilen
1. Railway Template erstellen (nach Deploy)
2. Share-Link generieren
3. Andere können 1-Click deployen!

**Railway Template Button:**
```markdown
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/DEIN-SLUG)
```

## 📞 Support & Community

### Betula
- Docs: https://betula.mycorrhiza.wiki/
- Issues: https://codeberg.org/bouncepaw/betula/issues
- Entwickler: @bouncepaw (Mastodon/Fediverse)

### Railway
- Docs: https://docs.railway.app
- Discord: https://discord.gg/railway
- Status: https://status.railway.app

### Dieses Template
- GitHub: [dein-repo-url]
- Issues: [dein-repo-url]/issues
- Contributions: PRs welcome!

## 🎓 Learning Resources

### Betula Deep-Dive
- [Official Wiki](https://betula.mycorrhiza.wiki/)
- [ActivityPub Integration](https://betula.mycorrhiza.wiki/activitypub)
- [API Documentation](https://betula.mycorrhiza.wiki/api)

### Railway Tutorials
- [Volumes Guide](https://docs.railway.app/reference/volumes)
- [Dockerfile Deployment](https://docs.railway.app/deploy/dockerfiles)
- [Custom Domains](https://docs.railway.app/deploy/exposing-your-app)

### Docker Best Practices
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)
- [Docker Security](https://docs.docker.com/engine/security/)
- [Alpine Linux](https://alpinelinux.org/)

## 🚨 Known Issues & Workarounds

### SQLite "Database locked"
**Problem:** Zwei Instances greifen parallel zu
**Fix:** Railway auf 1 Replica skalieren

### Volume nicht gemountet
**Problem:** Daten gehen verloren bei Redeploy
**Fix:** Volume `/data` in Railway Variables checken

### Build fehlschlägt (CGO)
**Problem:** CGO_ENABLED nicht gesetzt
**Fix:** Check Dockerfile, `ENV CGO_ENABLED=1` muss vorhanden sein

### Port 1738 nicht erreichbar
**Problem:** Railway Port-Mapping fehlt
**Fix:** Railway mappt automatisch, kein Action nötig

## ✅ Production-Readiness Checklist

Vor Live-Gang:

- [ ] Volume ist konfiguriert & persistent
- [ ] Backup-Strategie ist aktiv
- [ ] Custom Domain ist konfiguriert (für ActivityPub)
- [ ] HTTPS funktioniert (automatisch via Railway)
- [ ] Admin-Passwort ist sicher & geändert
- [ ] Monitoring/Notifications sind aktiv (Railway)
- [ ] Erste Backups sind erstellt & getestet
- [ ] ActivityPub wurde getestet (falls relevant)
- [ ] Dokumentation ist aktualisiert (Custom URLs, etc.)

## 🎉 Success Criteria

Nach erfolgreichem Deployment solltest du:

- ✅ Betula via öffentlicher URL erreichen
- ✅ Bookmarks erstellen & anzeigen können
- ✅ ActivityPub/Fediverse funktioniert (falls aktiviert)
- ✅ Daten bleiben erhalten bei Redeploys
- ✅ Updates via Git Push deployen können
- ✅ Backups erstellen & restoren können

**Wenn alles ✅ ist: Congratulations! 🚀**

## 📝 Changelog

### v1.0.0 (Initial Release)
- Production-ready Dockerfile
- Railway deployment config
- Comprehensive documentation
- GitHub Actions integration
- Backup strategies
- ActivityPub setup guide

## 🔮 Future Enhancements

### Planned
- [ ] Automated backup script (cron-ready)
- [ ] Railway Template creation
- [ ] Performance monitoring dashboard
- [ ] Multi-user setup guide (falls Betula das supportet)
- [ ] Migration guide (von anderen Bookmark-Tools)

### Contributions Welcome
- Verbesserungen am Dockerfile
- Erweiterte Monitoring-Setups
- Alternative Deployment-Plattformen (Fly.io, Render, etc.)
- Übersetzungen (Deutsch, etc.)

---

**Version:** 1.0.0  
**Author:** [Dein Name / Steven Noack]  
**License:** MIT (Deployment-Setup) / AGPL-3.0 (Betula)  
**Updated:** 2025-11-15

---

**Viel Erfolg mit Betula! 🔖✨**

Questions? Open an issue on GitHub!
