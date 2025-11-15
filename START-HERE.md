# 👋 START HERE - Betula Railway Deployment

Willkommen zum **production-ready Betula Deployment für Railway**!

## 🎯 Was ist das hier?

Ein **komplettes, sofort nutzbares Setup** um Betula (federated bookmark manager) 
auf Railway zu deployen. Mit:

- ✅ Production-ready Dockerfile
- ✅ Railway-Konfiguration
- ✅ Umfassende Dokumentation
- ✅ Schritt-für-Schritt Anleitung
- ✅ Backup-Strategien
- ✅ Troubleshooting-Guides

## 🚀 Schnellstart (3 Schritte)

### 1. Repository hochladen
```bash
# Entpacke dieses ZIP
unzip betula-railway.zip

# Erstelle neues GitHub Repo "betula-railway"
# Upload alle Dateien via GitHub Web-UI oder:

cd betula-railway
git init
git add .
git commit -m "Initial: Betula Railway setup"
git remote add origin https://github.com/DEIN-USERNAME/betula-railway.git
git push -u origin main
```

### 2. Railway deployen
1. Gehe zu [railway.app](https://railway.app)
2. "New Project" → "Deploy from GitHub repo"
3. Wähle dein `betula-railway` Repo
4. **WICHTIG:** Volume hinzufügen → `/data` (1 GB)
5. Warte 2-3 Minuten

### 3. Admin-User erstellen
```bash
# Railway CLI installieren
npm i -g @railway/cli

# Login & verbinden
railway login
railway link

# Admin erstellen
railway run sh
betula /data/bookmarks.betula -admin-username admin -admin-password ChangeMeNow
exit
```

**Fertig!** Öffne deine Railway-URL und logge dich ein.

---

## 📚 Welche Datei soll ich lesen?

### Für Erstsetup
👉 **Lies `SETUP.md`** - Komplette Schritt-für-Schritt Anleitung (15-20 Min)

### Für Übersicht & Features
👉 **Lies `README.md`** - Comprehensive Guide mit allen Details

### Für Daily Operations
👉 **Lies `CHEATSHEET.md`** - Quick-Referenz für häufige Befehle

### Für Projekt-Details
👉 **Lies `PROJECT-OVERVIEW.md`** - Technische Details & Best Practices

---

## 📁 Datei-Übersicht

```
betula-railway/
│
├── START-HERE.md              ← DU BIST HIER
├── SETUP.md                   ← Schritt-für-Schritt Anleitung
├── README.md                  ← Haupt-Dokumentation
├── CHEATSHEET.md              ← Quick-Referenz
├── PROJECT-OVERVIEW.md        ← Technische Details
│
├── Dockerfile                 ← Production Docker Build
├── .dockerignore              ← Docker Build Optimierung
├── .gitignore                 ← Git Ignore Rules
├── nixpacks.toml              ← Railway Config (optional)
├── LICENSE                    ← MIT License
│
└── .github/
    └── workflows/
        └── docker-test.yml    ← GitHub Actions Tests
```

---

## ⚡ Quick Reference

### Wichtigste Befehle
```bash
# Logs ansehen
railway logs

# Shell im Container
railway run sh

# Redeploy
railway restart

# Backup erstellen
railway run sh -c "sqlite3 /data/bookmarks.betula .dump" > backup.sql
```

### Wichtigste URLs
```
/                  - Homepage
/login             - Login
/settings          - Einstellungen
/add               - Bookmark hinzufügen
/feed              - RSS Feed
```

---

## 🎯 Deployment-Reihenfolge

1. ✅ GitHub Repo erstellen
2. ✅ Railway Projekt erstellen
3. ✅ Volume konfigurieren (`/data`, 1 GB)
4. ✅ Deploy abwarten (2-3 Min)
5. ✅ Admin-User erstellen
6. ✅ Login & Passwort ändern
7. ✅ Ersten Bookmark erstellen
8. ✅ Fertig! 🎉

Detaillierte Anleitung: Siehe `SETUP.md`

---

## 🔧 Wichtige Hinweise

### KRITISCH: Volume
**Ohne Volume gehen alle Daten verloren bei jedem Deploy!**

Railway Dashboard → Service → Variables → "Add Volume"
- Mount Path: `/data`
- Size: `1 GB` (oder mehr)

### KRITISCH: Passwort
Nach erstem Login **sofort Passwort ändern**!

Settings → Change Password

### ActivityPub
Für Fediverse-Integration brauchst du eine **Custom Domain**.

Railway → Settings → Domains → Custom Domain hinzufügen

---

## 🐛 Troubleshooting

### Build fehlschlägt?
→ Check Railway Logs → Build Tab

### Service startet nicht?
→ Volume konfiguriert? (`/data`)

### Daten gehen verloren?
→ Volume ist nicht persistent → Neu konfigurieren

### Port-Error?
→ Railway mappt Port 1738 automatisch, kein Action nötig

**Mehr Troubleshooting:** Siehe `README.md` → Troubleshooting Section

---

## 📞 Support

### Railway
- Discord: https://discord.gg/railway
- Docs: https://docs.railway.app

### Betula
- Docs: https://betula.mycorrhiza.wiki/
- Issues: https://codeberg.org/bouncepaw/betula/issues

### Dieses Template
- GitHub Issues: [dein-repo-url]/issues

---

## ✨ Was ist Betula?

**Betula** ist ein **federated bookmark manager** mit:

- 🌐 ActivityPub-Integration (Fediverse!)
- 🗃️ SQLite-basiert (einfach & schnell)
- 🏷️ Tag-System
- 📡 RSS/Atom Feeds
- 🔗 Webmention-Support
- 🎨 Single-user (fokussiert & simpel)

**Perfect für:**
- Personal Knowledge Management
- Link-Sammlung mit Fediverse-Sharing
- Alternative zu Pinboard, Pocket, etc.
- Decentralized Bookmarking

---

## 🎓 Nächste Schritte nach Deployment

1. **Ersten Bookmark erstellen** → Test alles funktioniert
2. **Custom Domain konfigurieren** → Für ActivityPub
3. **Backup-Strategie implementieren** → Siehe `CHEATSHEET.md`
4. **Bookmarklet installieren** → Settings → Bookmarklet
5. **Fediverse-Profil teilen** → `@username@deine-domain.de`

---

## 🌟 Als Template nutzen

Dieses Setup ist als **wiederverwendbares Template** konzipiert!

**Für eigene Instance:**
1. Fork dieses Repo
2. Deploy auf Railway
3. Teile mit Community!

**Für andere:**
1. Railway Template erstellen
2. Share-Link generieren
3. 1-Click Deployment für alle!

---

## 💡 Pro-Tipps

- **Backup regelmäßig** → Script in `CHEATSHEET.md`
- **Monitoring aktivieren** → Railway Notifications
- **Custom Domain früh setup** → Wichtig für ActivityPub
- **Passwort Manager nutzen** → Für sicheres Admin-Passwort
- **RSS Feed teilen** → `/feed` URL

---

## 🎉 Du bist bereit!

1. **Start:** Lies `SETUP.md` für detaillierte Anleitung
2. **Deploy:** Folge den Schritten (15-20 Min)
3. **Enjoy:** Deine eigene Betula-Instance! 🔖

**Questions? Issues? Feedback?**
→ Open an issue on GitHub!

---

**Happy Bookmarking! ✨**

---

_Version: 1.0.0 | Updated: 2025-11-15 | License: MIT_
