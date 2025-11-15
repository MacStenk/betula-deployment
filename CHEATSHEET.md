# Betula Railway - Cheatsheet

Quick-Referenz für die häufigsten Befehle und Aufgaben.

---

## 🚀 Railway CLI

### Setup
```bash
# CLI installieren
npm install -g @railway/cli

# Login
railway login

# Projekt verbinden
railway link
```

### Deployment
```bash
# Logs ansehen
railway logs

# Live-Logs folgen
railway logs --follow

# Shell im Container
railway run sh

# Status checken
railway status

# Service neu starten
railway restart

# Redeploy erzwingen
railway up --detach
```

---

## 🔖 Betula Admin

### User Management
```bash
# Im Container (railway run sh):

# Admin erstellen
betula /data/bookmarks.betula -admin-username admin -admin-password secret

# Passwort zurücksetzen
betula /data/bookmarks.betula -reset-password username

# User löschen
betula /data/bookmarks.betula -delete-user username
```

### Datenbank
```bash
# Im Container:

# DB-Integrity prüfen
sqlite3 /data/bookmarks.betula "PRAGMA integrity_check;"

# Datenbank optimieren
sqlite3 /data/bookmarks.betula "VACUUM;"

# Backup erstellen
sqlite3 /data/bookmarks.betula .dump > /tmp/backup.sql

# Stats anzeigen
sqlite3 /data/bookmarks.betula "SELECT COUNT(*) FROM bookmarks;"
```

---

## 🐳 Docker Lokal

### Build & Run
```bash
# Image bauen
docker build -t betula:local .

# Lokal testen (Port 1738)
docker run -p 1738:1738 -v $(pwd)/data:/data betula:local

# Mit Shell
docker run -it -p 1738:1738 -v $(pwd)/data:/data betula:local sh
```

### Debug
```bash
# Build-Logs
docker build -t betula:debug --progress=plain .

# Container inspizieren
docker run -it betula:debug sh

# Image-Größe
docker images betula:local
```

---

## 📦 Git Workflow

### Updates deployen
```bash
# Änderungen committen
git add .
git commit -m "Update configuration"

# Pushen (Railway deployt automatisch)
git push origin main
```

### Versionen taggen
```bash
# Version taggen
git tag -a v1.0.0 -m "Initial production release"
git push origin v1.0.0
```

---

## 🔍 Troubleshooting

### Volume-Probleme
```bash
# Im Container: Volume checken
railway run sh
ls -la /data
df -h /data

# Railway Dashboard: Volume neu erstellen
# Settings → Volumes → Remove & Add new
```

### Port-Probleme
```bash
# Railway mappt automatisch, aber zum Testen:
railway run sh
netstat -tlnp | grep 1738
```

### Logs durchsuchen
```bash
# Nur Errors
railway logs | grep -i error

# Letzten 100 Zeilen
railway logs --tail 100

# Ab bestimmter Zeit
railway logs --since 1h
```

---

## 🌐 URLs & Endpoints

### Wichtige Pfade
```
/                    - Homepage
/login               - Login
/settings            - Einstellungen
/add                 - Bookmark hinzufügen
/feed                - RSS/Atom Feed
/api/v1/bookmarks    - API (falls aktiviert)
/.well-known/webfinger - WebFinger (ActivityPub)
```

### Testing
```bash
# Health Check
curl https://deine-domain.railway.app/

# WebFinger
curl https://deine-domain.railway.app/.well-known/webfinger?resource=acct:admin@deine-domain.railway.app

# RSS Feed
curl https://deine-domain.railway.app/feed
```

---

## 💾 Backups

### Automatisches Backup-Script
```bash
#!/bin/bash
# backup.sh - Lokales Backup-Script

DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="./backups"

mkdir -p $BACKUP_DIR

# Backup via Railway CLI
railway run sh -c "sqlite3 /data/bookmarks.betula .dump" > $BACKUP_DIR/betula-$DATE.sql

echo "Backup erstellt: $BACKUP_DIR/betula-$DATE.sql"

# Alte Backups löschen (älter als 30 Tage)
find $BACKUP_DIR -name "betula-*.sql" -mtime +30 -delete
```

### Restore
```bash
# Backup in Container kopieren
railway run sh
cat > /tmp/restore.sql
# Paste SQL content, Ctrl+D

# Restore
sqlite3 /data/bookmarks.betula < /tmp/restore.sql
```

---

## 🔒 Security

### HTTPS-Redirect (Railway macht automatisch)
```bash
# Testen
curl -I http://deine-domain.railway.app/
# Sollte 301 → HTTPS sein
```

### Headers checken
```bash
# Security Headers
curl -I https://deine-domain.railway.app/

# SSL-Zertifikat
openssl s_client -connect deine-domain.railway.app:443 -servername deine-domain.railway.app
```

---

## 📊 Monitoring

### Resource Usage
```bash
# Railway Dashboard:
# Service → Metrics

# Oder via CLI (falls verfügbar):
railway metrics
```

### Performance
```bash
# SQLite Query Performance
railway run sh
sqlite3 /data/bookmarks.betula
.timer on
SELECT * FROM bookmarks LIMIT 100;
```

---

## 🔄 Updates

### Betula Version updaten
```bash
# In Dockerfile: Tag ändern
# Von:
RUN git clone https://codeberg.org/bouncepaw/betula.git .

# Zu (für spezifische Version):
RUN git clone --branch v1.2.3 https://codeberg.org/bouncepaw/betula.git .

# Commit & Push
git add Dockerfile
git commit -m "Update Betula to v1.2.3"
git push
```

### Railway Platform Updates
```bash
# Railway updated automatisch
# Check: Dashboard → Service → Settings → Runtime
```

---

## 📞 Support & Links

**Railway:**
- Dashboard: https://railway.app/dashboard
- Docs: https://docs.railway.app
- Discord: https://discord.gg/railway

**Betula:**
- Docs: https://betula.mycorrhiza.wiki/
- Source: https://codeberg.org/bouncepaw/betula
- Issues: https://codeberg.org/bouncepaw/betula/issues

**Dieses Template:**
- GitHub: [dein-repo-url]
- Issues: [dein-repo-url]/issues

---

**Pro-Tipp:** Bookmark diese Datei in Betula selbst! 😄
