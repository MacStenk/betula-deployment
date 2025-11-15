# 🔖 Betula auf Railway

**Production-ready Deployment für Betula** - den federated bookmark manager.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/betula)

## 📋 Was ist Betula?

Betula ist ein **single-user federated bookmark manager** mit:

- ✅ ActivityPub-Unterstützung (Fediverse-kompatibel)
- ✅ SQLite-basiert (keine PostgreSQL-Komplexität)
- ✅ Go-basiert (ein Binary, simple Deployment)
- ✅ RSS/Atom Feeds
- ✅ Tag-System
- ✅ Webmention-Support

**Links:**
- [Offizielle Docs](https://betula.mycorrhiza.wiki/)
- [Source Code](https://codeberg.org/bouncepaw/betula)

---

## 🚀 Quick Start (5 Minuten)

### 1️⃣ GitHub Repository erstellen

```bash
# Klone dieses Template
git clone https://github.com/DEIN-USERNAME/betula-railway.git
cd betula-railway

# Oder: Fork dieses Repo auf GitHub
```

### 2️⃣ Railway Projekt erstellen

1. Gehe zu [railway.app](https://railway.app)
2. Klicke "New Project"
3. Wähle "Deploy from GitHub repo"
4. Wähle dein `betula-railway` Repository

### 3️⃣ Volume konfigurieren

**KRITISCH: Ohne Volume = Datenverlost bei jedem Deploy!**

1. Im Railway Dashboard → dein Service → **Variables** Tab
2. Klicke **"New Variable"** → **"Add Volume"**
3. Mount Path: `/data`
4. Size: `1GB` (oder mehr, je nach Bedarf)

### 4️⃣ Domain konfigurieren (optional)

1. Railway Dashboard → **Settings** Tab
2. **Domains** → **Generate Domain** (oder Custom Domain)
3. Notiere dir die URL (z.B. `betula-production.up.railway.app`)

### 5️⃣ Deploy starten

Railway deployt automatisch! Warte ca. 2-3 Minuten.

**Deployment beobachten:**
- Dashboard → **Deployments** Tab
- Logs ansehen für Errors

### 6️⃣ Ersten Admin-User erstellen

**Nach erfolgreichem Deploy:**

```bash
# Railway CLI installieren (falls noch nicht)
npm i -g @railway/cli

# In Railway einloggen
railway login

# In dein Projekt-Verzeichnis
cd betula-railway
railway link

# Shell im Container öffnen
railway run

# Im Container: Admin-User erstellen
betula /data/bookmarks.betula -admin-username deinname -admin-password deinpasswort
```

**Oder via Railway Dashboard:**
1. Service → **Settings** → **Raw Editor**
2. Einmalig Start Command ändern zu:
   ```
   betula /data/bookmarks.betula -admin-username admin -admin-password changeme
   ```
3. Nach erstem Start wieder zurück zu: `betula /data/bookmarks.betula`

**Dann:** Öffne deine Betula-URL und logge dich ein!

---

## 🔧 Technische Details

### Dockerfile

- **Multi-stage build:** Go builder + Alpine runtime
- **CGO_ENABLED=1:** Essentiell für SQLite-Support
- **Non-root User:** Security Best Practice
- **Healthcheck:** Automatic health monitoring
- **Optimiert:** Kleine Image-Größe (~20-30 MB)

### Port

- **Container Port:** `1738`
- **Railway:** Mapped automatisch zu öffentlicher URL

### Volume

- **Mount Path:** `/data`
- **SQLite File:** `/data/bookmarks.betula`
- **Empfohlene Größe:** 1-5 GB (je nach Bookmark-Anzahl)

### Environment Variables

Betula nutzt **keine** Environment Variables für Core-Funktionalität.
Alle Konfiguration erfolgt via Command-Line-Flags beim Start.

**Optional (für erweiterte Setups):**

```bash
# Timezone (optional)
TZ=Europe/Berlin

# Custom Port (falls nötig, Standard: 1738)
# Betula hat kein PORT env var, Port wird via Railway gemappt
```

---

## 📝 Häufige Aufgaben

### Updates deployen

```bash
# Railway deployt automatisch bei Git Push
git add .
git commit -m "Update configuration"
git push origin main
```

### Backups erstellen

**Option 1: Railway Volume Backup (empfohlen)**

Railway bietet automatische Volume-Backups (je nach Plan).

**Option 2: Manuelle SQLite-Datei kopieren**

```bash
# Via Railway CLI
railway run

# Im Container
cat /data/bookmarks.betula > /tmp/backup.betula
# Dann von /tmp runterladen via Railway Dashboard
```

**Option 3: SQLite Dump**

```bash
railway run

# Im Container
sqlite3 /data/bookmarks.betula .dump > /tmp/backup.sql
```

### Logs ansehen

```bash
# Via Railway CLI
railway logs

# Oder im Dashboard: Deployments → Logs
```

### Datenbank reparieren (falls korrupt)

```bash
railway run

# Im Container
sqlite3 /data/bookmarks.betula "PRAGMA integrity_check;"
sqlite3 /data/bookmarks.betula "VACUUM;"
```

---

## 🌐 ActivityPub & Fediverse

### Domain konfigurieren

Für ActivityPub brauchst du eine **feste Domain**:

1. Railway → **Settings** → **Domains**
2. **Custom Domain** hinzufügen (z.B. `bookmarks.deinedomain.de`)
3. DNS bei deinem Provider: CNAME → Railway-Domain

### Fediverse-Profil

Dein Betula-Instance ist erreichbar als:

```
@deinusername@bookmarks.deinedomain.de
```

Andere können dir folgen und sehen deine öffentlichen Bookmarks!

### WebFinger

Betula bietet automatisch WebFinger-Support:

```
https://bookmarks.deinedomain.de/.well-known/webfinger?resource=acct:deinusername@bookmarks.deinedomain.de
```

---

## 🔒 Sicherheit

### HTTPS

Railway bietet **automatisches HTTPS** via Let's Encrypt. Keine Konfiguration nötig!

### Passwort ändern

**Nach dem ersten Setup unbedingt Passwort ändern!**

```bash
railway run

# Im Container
betula /data/bookmarks.betula -reset-password deinusername
# Folge den Prompts
```

### Privatsphäre-Einstellungen

In Betula (nach Login):

1. **Settings** → **Privacy**
2. Wähle: Public / Unlisted / Private

---

## 🐛 Troubleshooting

### "Database locked" Error

**Ursache:** Zwei Betula-Instanzen greifen gleichzeitig auf SQLite zu.

**Lösung:**
```bash
# Stelle sicher, dass nur eine Instance läuft
railway ps
railway scale 1
```

### Volume nicht gemountet

**Symptom:** Daten gehen bei Redeploy verloren.

**Lösung:**
1. Railway Dashboard → Service → **Variables**
2. Überprüfe Volume Mount: `/data`
3. Redeploy

### Build fehlschlägt

**Ursache:** Meist CGO-related.

**Lösung:**
1. Überprüfe Dockerfile: `ENV CGO_ENABLED=1` vorhanden?
2. Check Build-Logs für Details
3. Issue auf GitHub öffnen mit Logs

### Port-Konflikte

**Symptom:** Service startet nicht, Port-Error.

**Lösung:**
Railway mappt Port `1738` automatisch. Keine Änderung nötig!

---

## 📊 Performance & Skalierung

### Ressourcen-Empfehlungen

**Small Instance (bis 10.000 Bookmarks):**
- RAM: 256 MB
- Volume: 1 GB

**Medium Instance (bis 50.000 Bookmarks):**
- RAM: 512 MB
- Volume: 5 GB

**Large Instance (bis 100.000+ Bookmarks):**
- RAM: 1 GB
- Volume: 10 GB

### SQLite Performance

Betula nutzt SQLite mit:
- WAL-Mode (Write-Ahead Logging)
- Optimierte Indices
- Effiziente Queries

**Bei Performance-Problemen:**

```bash
railway run

# Im Container
sqlite3 /data/bookmarks.betula "PRAGMA optimize;"
sqlite3 /data/bookmarks.betula "VACUUM;"
```

---

## 🎯 Template-Nutzung

Dieses Repo ist als **Template** konzipiert!

### Für deine eigene Instance

1. Fork dieses Repo
2. Passe `README.md` an (deine Domain, etc.)
3. Optional: Passe Dockerfile an (z.B. andere Betula-Version)
4. Deploy auf Railway

### Für andere teilen

1. Erstelle Railway Template (deploy + "Share Template")
2. Andere können mit einem Klick deployen!

**Railway Template Button:**

```markdown
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/DEIN-TEMPLATE-SLUG)
```

---

## 📚 Weiterführende Ressourcen

### Betula Dokumentation

- [Offizielles Wiki](https://betula.mycorrhiza.wiki/)
- [Betula-Codeberg](https://codeberg.org/bouncepaw/betula)
- [ActivityPub Guide](https://betula.mycorrhiza.wiki/activitypub)

### Railway Docs

- [Volumes Guide](https://docs.railway.app/reference/volumes)
- [Dockerfiles](https://docs.railway.app/deploy/dockerfiles)
- [Custom Domains](https://docs.railway.app/deploy/exposing-your-app)

### Fediverse

- [ActivityPub Spec](https://www.w3.org/TR/activitypub/)
- [WebFinger Spec](https://webfinger.net/)

---

## 🤝 Contributing

Verbesserungen? Bugs gefunden?

1. Fork this Repo
2. Create Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit Changes (`git commit -m 'Add AmazingFeature'`)
4. Push to Branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📄 Lizenz

Dieses Deployment-Setup: **MIT License**

Betula selbst: **AGPL-3.0** (siehe [Betula Lizenz](https://codeberg.org/bouncepaw/betula/src/branch/master/LICENSE))

---

## 💝 Credits

- **Betula:** [@bouncepaw](https://codeberg.org/bouncepaw)
- **Railway:** [railway.app](https://railway.app)
- **Dieses Template:** [Dein Name / GitHub Handle]

---

## 🔗 Links

- **Live Demo:** [deine-betula-instance.railway.app]
- **GitHub Repo:** [github.com/DEIN-USERNAME/betula-railway]
- **Railway Template:** [railway.app/template/betula]

---

**Happy Bookmarking! 🔖✨**
