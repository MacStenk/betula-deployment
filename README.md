# 🔖 Betula auf Railway - Production Deployment

**Federated Bookmark Manager auf Railway deployen - einfach, schnell, production-ready.**

[![Live Demo](https://img.shields.io/badge/Live-bookmarks.stevennoack.de-blue)](https://bookmarks.stevennoack.de)
[![Fediverse](https://img.shields.io/badge/Fediverse-@steven-purple)](https://bookmarks.stevennoack.de)
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/betula)

---

## 🎯 Was ist das hier?

Ein **production-ready Deployment-Setup** für [Betula](https://betula.mycorrhiza.wiki/) - den federated bookmark manager - optimiert für Railway.

**Live Demo:** [bookmarks.stevennoack.de](https://bookmarks.stevennoack.de)  
**Fediverse:** `@steven@bookmarks.stevennoack.de`

---

## ✨ Features

- ✅ **Production-ready Dockerfile** - Multi-stage Build mit CGO-Support
- ✅ **Railway-optimiert** - Volume-Support für SQLite-Persistenz
- ✅ **Custom Domain** - HTTPS automatisch via Let's Encrypt
- ✅ **ActivityPub/Fediverse** - Federation out-of-the-box
- ✅ **Zero-Config** - Git push = Deploy
- ✅ **Sicher** - Non-root User, optimierte Permissions
- ✅ **Klein** - Docker Image ~20-30 MB

---

## 🚀 Quick Start (15 Minuten)

### 1. Repository klonen

```bash
git clone https://github.com/MacStenk/betula-deployment.git
cd betula-deployment
```

### 2. Auf GitHub pushen

```bash
# Erstelle neues GitHub Repo "betula-deployment"
# Dann:
git remote set-url origin https://github.com/DEIN-USERNAME/betula-deployment.git
git push -u origin main
```

### 3. Railway deployen

1. Gehe zu [railway.app](https://railway.app)
2. "New Project" → "Deploy from GitHub repo"
3. Wähle dein Repository
4. **Wichtig:** Volume hinzufügen:
   - Variables Tab → "Add Volume"
   - Mount Path: `/data`
   - Size: `1 GB`

### 4. Domain konfigurieren

**Railway:**
- Settings → Domains → "Custom Domain"
- Gib deine Domain ein (z.B. `bookmarks.deinedomain.de`)

**DNS (bei deinem Provider):**
```
Type:  CNAME
Name:  bookmarks
Value: [deine-railway-domain].up.railway.app
```

### 5. Admin-Account erstellen

Nach dem Deploy:
1. Öffne deine Betula-URL
2. Registriere deinen Admin-Account
3. Fertig! 🎉

---

## 📋 Technische Details

### Dockerfile

**Multi-stage Build:**
- **Stage 1:** Go 1.23 Builder mit CGO-Support für SQLite
- **Stage 2:** Alpine 3.19 Runtime (minimal)

**Key Features:**
- CGO_ENABLED=1 (kritisch für SQLite!)
- Optimiertes Binary (~20 MB)
- Healthcheck integriert
- Volle Permissions für `/data` Volume

### Railway-Konfiguration

**Port:** 1738 (automatisch gemappt)  
**Volume:** `/data` (persistent SQLite)  
**Restart Policy:** Always  
**Region:** Wählbar (empfohlen: EU-West für Deutschland)

### Technologie-Stack

- **Language:** Go 1.23
- **Database:** SQLite (single file)
- **Platform:** Railway
- **Web Server:** Betula (built-in)
- **SSL:** Let's Encrypt (automatisch)
- **Federation:** ActivityPub

---

## 🔧 Anpassungen

### Custom Domain ändern

**In Betula Settings:**
```
Site address: https://deine-custom-domain.de
```

**In Railway:**
- Settings → Domains → Custom Domain hinzufügen

### Volume-Größe erhöhen

Railway Dashboard → Variables → Volume → Edit Size

**Empfohlene Größen:**
- Small (bis 10k Bookmarks): 1 GB
- Medium (bis 50k): 5 GB
- Large (100k+): 10 GB

### Backup erstellen

```bash
# Via Railway CLI
railway run sh

# Im Container:
sqlite3 /data/bookmarks.betula .dump > /tmp/backup.sql
```

---

## 🌐 ActivityPub / Fediverse

### Setup

1. **Custom Domain** ist Pflicht für Federation
2. **In Betula Settings:**
   - Enable federation (Fediverse) ✅
   - Site address: `https://deine-domain.de`

### Dein Fediverse-Handle

```
@username@deine-domain.de
```

**Von Mastodon/Fediverse folgen:**
- Suche nach deinem Handle
- Follow → Öffentliche Bookmarks erscheinen in Timeline!

---

## 📊 Success Story

**Von Zero zu Production in 90 Minuten:**

- ✅ Docker Build erfolgreich
- ✅ Railway Deployment live
- ✅ Custom Domain mit HTTPS
- ✅ Persistent SQLite Volume
- ✅ ActivityPub Federation aktiv
- ✅ Erster Bookmark gespeichert

**VIBE Coding in Action:** Orchestriert mit Claude statt selbst gecoded.

---

## 🐛 Troubleshooting

### Build schlägt fehl

**Problem:** `no Go files in /build`

**Lösung:** Stelle sicher dass im Dockerfile steht:
```dockerfile
RUN go build -o betula ./cmd/betula
```

### Service crasht

**Problem:** `unable to open database file`

**Lösung:** Volume-Mount prüfen:
- Railway → Variables → Volume muss auf `/data` gemountet sein

### Domain funktioniert nicht

**Problem:** DNS nicht konfiguriert

**Lösung:** 
1. DNS CNAME prüfen (dig bookmarks.deinedomain.de)
2. Warte 5-60 Min für Propagation
3. Railway Domain verifiziert? (Settings → Domains)

---

## 📚 Dokumentation

### Betula

- **Offizielle Docs:** https://betula.mycorrhiza.wiki/
- **Source Code:** https://codeberg.org/bouncepaw/betula
- **ActivityPub Guide:** https://betula.mycorrhiza.wiki/activitypub

### Railway

- **Volumes Guide:** https://docs.railway.app/reference/volumes
- **Custom Domains:** https://docs.railway.app/deploy/exposing-your-app
- **Dockerfiles:** https://docs.railway.app/deploy/dockerfiles

---

## 🤝 Contributing

Verbesserungen? Bugs gefunden?

1. Fork this Repo
2. Create Feature Branch
3. Commit Changes
4. Push to Branch
5. Open Pull Request

---

## 📄 Lizenz

**Dieses Deployment-Setup:** MIT License

**Betula selbst:** AGPL-3.0 (siehe [Betula License](https://codeberg.org/bouncepaw/betula/src/branch/master/LICENSE))

---

## 💝 Credits

- **Betula:** [@bouncepaw](https://codeberg.org/bouncepaw) - Awesome bookmark manager!
- **Railway:** [railway.app](https://railway.app) - Perfect deployment platform
- **Deployment Setup:** [Steven Noack](https://stevennoack.de) - VIBE Coding with Claude

---

## 🔗 Links

- **Live Demo:** [bookmarks.stevennoack.de](https://bookmarks.stevennoack.de)
- **Fediverse:** [@steven@bookmarks.stevennoack.de](https://bookmarks.stevennoack.de)
- **GitHub Repo:** [MacStenk/betula-deployment](https://github.com/MacStenk/betula-deployment)
- **Railway Template:** Coming soon!

---

## 🎉 Deployment erfolgreich!

**Deployed on:** 2025-11-15  
**Platform:** Railway  
**Status:** ✅ Production  
**Domain:** bookmarks.stevennoack.de

**Happy Bookmarking! 🔖✨**
