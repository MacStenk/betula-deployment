# 🚀 Betula auf Railway - Setup Guide

**Schritt-für-Schritt Anleitung** für ein komplettes Betula-Deployment.

Geschätzte Zeit: **15-20 Minuten**

---

## Voraussetzungen

Stelle sicher, dass du folgendes hast:

- ✅ GitHub Account
- ✅ Railway Account ([railway.app](https://railway.app) - kostenlos starten)
- ✅ Git installiert (lokal)
- ✅ Optional: Railway CLI ([Installationsanleitung](https://docs.railway.app/develop/cli))

---

## Phase 1: Repository Setup (5 Min)

### Schritt 1.1: Template Repository nutzen

**Option A: GitHub Template nutzen**

1. Gehe zu [github.com/DEIN-USERNAME/betula-railway](https://github.com/DEIN-USERNAME/betula-railway)
2. Klicke **"Use this template"** → **"Create a new repository"**
3. Name: `betula-railway` (oder eigener Name)
4. Visibility: Public (für einfacheres Railway-Deployment)
5. **"Create repository"**

**Option B: Fork erstellen**

1. Fork dieses Repo
2. Clone auf deinen lokalen Rechner

**Option C: Manuell klonen und pushen**

```bash
# Template klonen
git clone https://github.com/ORIGINAL/betula-railway.git mein-betula
cd mein-betula

# Eigenes Repo erstellen auf GitHub (via Web-UI)
# Dann:
git remote remove origin
git remote add origin https://github.com/DEIN-USERNAME/mein-betula.git
git push -u origin main
```

### Schritt 1.2: Repository-Struktur überprüfen

Dein Repo sollte enthalten:

```
betula-railway/
├── Dockerfile          # Docker Build-Konfiguration
├── .dockerignore       # Ignore-Regeln für Docker
├── nixpacks.toml       # Railway-Konfiguration (optional)
├── README.md           # Haupt-Dokumentation
└── SETUP.md            # Diese Datei
```

✅ **Checkpoint:** GitHub Repo ist online und enthält alle Dateien.

---

## Phase 2: Railway Projekt erstellen (3 Min)

### Schritt 2.1: Neues Railway-Projekt

1. Öffne [railway.app/new](https://railway.app/new)
2. Klicke **"Deploy from GitHub repo"**
3. Wenn nötig: Authorize Railway für GitHub-Zugriff
4. Wähle dein Repository: `betula-railway`
5. Railway startet automatisch den ersten Deploy

### Schritt 2.2: Deployment-Settings überprüfen

Während Railway deployt:

1. Service-Name: Automatisch generiert (z.B. `betula-production`)
2. Region: Wähle nächstgelegene (z.B. `eu-west` für Deutschland)
3. Branch: `main` (oder `master`)

### Schritt 2.3: Ersten Deploy abwarten

**Dieser Deploy wird FEHLSCHLAGEN - das ist normal!**

Warum? Volume ist noch nicht konfiguriert → SQLite kann nicht schreiben.

**Beobachte die Logs:**
- Railway Dashboard → **Deployments** Tab
- Klicke auf aktuellen Deploy
- Check Build-Logs (sollte erfolgreich sein)
- Runtime-Logs zeigen Error (kein Volume)

✅ **Checkpoint:** Build erfolgreich, Runtime-Error wegen fehlendem Volume.

---

## Phase 3: Volume konfigurieren (2 Min)

### Schritt 3.1: Volume erstellen

**KRITISCH: Ohne Volume gehen alle Daten bei jedem Deploy verloren!**

1. Railway Dashboard → dein Service
2. **Variables** Tab (oben)
3. Klicke **"New Variable"** (Dropdown rechts)
4. Wähle **"Add Volume"**

### Schritt 3.2: Volume-Settings

**Mount Path:**
```
/data
```

**Size:**
```
1 GB
```
(Für Start ausreichend, später skalierbar auf 5-10 GB)

**Name:** (automatisch generiert, z.B. `betula-data`)

Klicke **"Add"**

### Schritt 3.3: Redeploy triggern

Volume ist nun konfiguriert, aber Service muss neu starten:

1. **Deployments** Tab
2. Klicke **"Redeploy"** (oben rechts)
3. Warte 1-2 Minuten

**Check Logs:**
- Sollte nun erfolgreich starten
- Log-Zeile: `Betula is running on port 1738` (oder ähnlich)

✅ **Checkpoint:** Service läuft, Volume ist gemountet, keine Errors in Logs.

---

## Phase 4: Domain konfigurieren (2 Min)

### Schritt 4.1: Railway-Domain generieren

1. Railway Dashboard → Service → **Settings** Tab
2. Scrolle zu **Domains**
3. Klicke **"Generate Domain"**

Railway erstellt automatisch eine Domain:
```
betula-production-xyz123.up.railway.app
```

**Kopiere diese URL!**

### Schritt 4.2: Domain testen

Öffne die URL in deinem Browser:

**Erwartetes Ergebnis:**
- Betula Startseite lädt
- Du siehst: "Welcome to Betula" (oder Login-Screen)

**Falls 404 oder Error:**
- Check Railway Logs
- Stelle sicher Volume ist gemountet
- Redeploy nochmal

### Schritt 4.3: Custom Domain (optional)

**Falls du eine eigene Domain nutzen willst:**

1. Settings → Domains → **"Custom Domain"**
2. Gib deine Domain ein: `bookmarks.deinedomain.de`
3. Railway zeigt DNS-Einstellungen

**Bei deinem DNS-Provider (z.B. Cloudflare, Namecheap):**

```
Type: CNAME
Name: bookmarks
Value: betula-production-xyz123.up.railway.app
```

**Warte 5-60 Minuten** für DNS-Propagation.

✅ **Checkpoint:** Betula ist unter deiner Domain erreichbar.

---

## Phase 5: Admin-User erstellen (5 Min)

### Schritt 5.1: Railway CLI installieren (einmalig)

**macOS / Linux:**
```bash
curl -fsSL https://railway.app/install.sh | sh
```

**Windows (PowerShell):**
```bash
iwr https://railway.app/install.ps1 | iex
```

**Oder via npm:**
```bash
npm install -g @railway/cli
```

### Schritt 5.2: Railway CLI verbinden

```bash
# Login
railway login
# Öffnet Browser für Auth

# In dein Projekt-Verzeichnis
cd /pfad/zu/betula-railway

# Mit Railway-Projekt verbinden
railway link
# Wähle dein Projekt aus der Liste
```

### Schritt 5.3: Admin-User erstellen

**Option A: Via CLI (empfohlen)**

```bash
# Shell im Railway-Container öffnen
railway run sh

# Im Container: Admin-User erstellen
betula /data/bookmarks.betula -admin-username admin -admin-password ChangeMeNow123!

# Exit
exit
```

**Option B: Via Railway Dashboard (Quick & Dirty)**

1. Service → **Settings** → **Deploy** Section
2. **Start Command** (wird angezeigt, ggf. erweitern)
3. Ändere temporär zu:
   ```
   betula /data/bookmarks.betula -admin-username admin -admin-password ChangeMeNow123!
   ```
4. **Redeploy** (oben rechts)
5. Warte bis Deploy fertig
6. Ändere Start Command zurück zu:
   ```
   betula /data/bookmarks.betula
   ```
7. **Redeploy** nochmal

**WICHTIG:** Passwort danach sofort ändern!

### Schritt 5.4: Ersten Login

1. Öffne deine Betula-Domain
2. Klicke **"Login"** (oder `/login`)
3. Username: `admin`
4. Password: `ChangeMeNow123!` (oder was du gewählt hast)
5. **Login**

**Sofort nach Login:**

1. Settings → **Change Password**
2. Neues, sicheres Passwort setzen
3. **Save**

✅ **Checkpoint:** Du bist eingeloggt, Passwort ist geändert.

---

## Phase 6: Betula konfigurieren (3 Min)

### Schritt 6.1: Basis-Einstellungen

**Nach Login:**

1. **Settings** (Zahnrad-Icon oder `/settings`)

**Empfohlene Settings:**

**General:**
- Site Title: `Dein Name's Bookmarks` (oder was du willst)
- Description: Kurze Bio
- Language: `de` oder `en`

**Privacy:**
- Default visibility: `public` (für Fediverse-Sichtbarkeit)
- Oder `unlisted` (nicht in Timeline, aber via Link)
- Oder `private` (nur für dich)

**Federation:**
- Enable ActivityPub: ✅ **An**
- Your Handle: Wird automatisch generiert (`@admin@bookmarks.deinedomain.de`)

**RSS/Atom:**
- Enable Feeds: ✅ **An**

### Schritt 6.2: Ersten Bookmark erstellen

1. Klicke **"Add Bookmark"** (oder `/add`)
2. **URL:** `https://betula.mycorrhiza.wiki/`
3. **Title:** `Betula Documentation`
4. **Description:** `Official docs for Betula`
5. **Tags:** `documentation, betula, fediverse`
6. **Visibility:** `public`
7. **Save**

**Dein erster Bookmark ist live!** 🎉

### Schritt 6.3: Fediverse-Test (optional)

**Wenn du ActivityPub aktiviert hast:**

1. Öffne deine Mastodon-Instance (oder andere Fediverse-App)
2. Suche nach: `@admin@bookmarks.deinedomain.de`
3. Klicke **"Follow"**
4. Du siehst jetzt deine öffentlichen Bookmarks in deiner Fediverse-Timeline!

✅ **Checkpoint:** Betula ist voll funktionsfähig, erster Bookmark erstellt.

---

## Phase 7: Backup & Maintenance (einmalig Setup)

### Schritt 7.1: Backup-Strategie

**Railway Volume Backups:**

Railway bietet (je nach Plan) automatische Volume-Snapshots.

**Manuelle Backups (empfohlen):**

```bash
# Via Railway CLI
railway run sh

# Im Container: SQLite exportieren
sqlite3 /data/bookmarks.betula .dump > /tmp/backup-$(date +%Y%m%d).sql

# Oder: Komplette Datei
cat /data/bookmarks.betula > /tmp/backup-$(date +%Y%m%d).betula

# Exit
exit
```

**Download via SFTP (falls Railway das unterstützt):**

Prüfe Railway Docs für aktuellste Backup-Methoden.

### Schritt 7.2: Monitoring aufsetzen (optional)

**Railway bietet:**
- Automatisches Health-Checking (via Dockerfile HEALTHCHECK)
- Deployment-Notifications (Email/Slack)

**Setup:**
1. Service → **Settings** → **Notifications**
2. Email oder Slack Webhook hinzufügen
3. Notifications aktivieren für:
   - Deploy failures
   - Service crashes

### Schritt 7.3: Update-Strategie

**Betula Updates deployen:**

```bash
# Lokales Repo aktualisieren
cd betula-railway

# In Dockerfile: Git-Clone pulled immer latest Version
# Oder: Pinne auf spezifischen Tag:
# RUN git clone --branch v1.2.3 https://codeberg.org/bouncepaw/betula.git .

# Commit & Push
git add Dockerfile
git commit -m "Update Betula version"
git push origin main

# Railway deployt automatisch!
```

**Testen:**
- Check Logs für erfolgreichen Deploy
- Teste Login
- Teste Bookmark-Erstellung

✅ **Checkpoint:** Backup-Strategie steht, Updates sind geplant.

---

## ✅ Finale Checkliste

Gehe diese Liste durch, um sicherzustellen, alles läuft:

- [ ] GitHub Repo ist online mit allen Dateien
- [ ] Railway Service ist deployed und läuft
- [ ] Volume ist konfiguriert (`/data`, mindestens 1 GB)
- [ ] Domain ist eingerichtet und erreichbar
- [ ] Admin-User ist erstellt und Passwort geändert
- [ ] Betula ist konfiguriert (Site Title, Privacy, etc.)
- [ ] Erster Bookmark ist erstellt und sichtbar
- [ ] ActivityPub funktioniert (falls aktiviert)
- [ ] Backup-Strategie ist dokumentiert
- [ ] Notifications sind konfiguriert (optional)

**Wenn alles ✅ ist: Glückwunsch! 🎉**

---

## 🎯 Nächste Schritte

### Weitere Features aktivieren

**RSS Feeds:**
- Deine Bookmarks sind verfügbar via: `https://bookmarks.deinedomain.de/feed`
- In RSS-Reader importieren (z.B. Feedly, Inoreader)

**Bookmarklet:**
1. Settings → **Bookmarklet**
2. Ziehe "Add to Betula" in deine Browser-Bookmarks
3. Auf jeder Webseite: Klick Bookmarklet → Sofort als Bookmark speichern!

**Browser Extension (falls verfügbar):**
- Check Betula Docs für offizielle Extensions

### Community & Support

**Hilfe bekommen:**
- [Betula Codeberg Issues](https://codeberg.org/bouncepaw/betula/issues)
- [Railway Discord](https://discord.gg/railway) (Support-Channel)
- Dieses Repo: Open an Issue

**Teilen:**
- Zeige deine Betula-Instance auf Mastodon/Fediverse
- Erwähne `@bouncepaw` (Betula-Entwickler)

---

## 🐛 Falls etwas nicht klappt

### Troubleshooting-Schritte

**1. Check Railway Logs:**
```bash
railway logs
# Oder: Dashboard → Deployments → Logs
```

**2. Volume verifizieren:**
```bash
railway run sh
ls -la /data
# Sollte bookmarks.betula zeigen
exit
```

**3. Redeploy erzwingen:**
```bash
# Dashboard → Deployments → Redeploy
# Oder:
railway up --detach
```

**4. Railway Support:**
- [Discord](https://discord.gg/railway)
- [Docs](https://docs.railway.app)

---

## 📚 Weiterführende Links

- **Betula Docs:** https://betula.mycorrhiza.wiki/
- **Railway Guides:** https://docs.railway.app/guides
- **SQLite Best Practices:** https://www.sqlite.org/bestpractice.html
- **ActivityPub Primer:** https://www.w3.org/TR/activitypub/

---

**Viel Erfolg mit deinem Betula-Deployment! 🔖✨**

Bei Fragen: Open an Issue in diesem Repo oder ping mich auf Mastodon.
