# Mein Tagebuch PWA v2

Private, installierbare Tagebuch-Web-App mit:
- lokaler Speicherung
- Supabase Auth (E-Mail + Passwort)
- Cloud-Synchronisierung zwischen Geräten
- Offline-Warteschlange
- Konfliktauflösung über Zeitstempel ("neuere Änderung gewinnt")
- Verlauf, Kalender, 7-/30-Tage-Auswertung
- JSON-Backup / Import
- CSV-Export
- GitHub-Pages-Workflow

## 1. Lokal testen

`index.html` kann direkt geöffnet werden. Lokale Einträge funktionieren sofort.

Für PWA/Service Worker sollte die App über HTTPS oder einen lokalen Webserver laufen.

## 2. Supabase erstellen

1. Neues Supabase-Projekt anlegen.
2. Im **SQL Editor** den kompletten Inhalt von `supabase.sql` ausführen.
3. Unter **Settings -> API Keys** den **Publishable Key** kopieren.
4. Project URL und Publishable Key entweder:
   - in `config.js` eintragen, oder
   - später in der App unter **Einstellungen -> Cloud-Synchronisierung** einfügen.
5. Niemals Secret-/Service-Role-Key in die App eintragen.

## 3. Login

Unter **Einstellungen**:
- E-Mail + Passwort
- `Konto erstellen`
- falls Supabase E-Mail-Bestätigung verlangt: E-Mail bestätigen
- anmelden
- `Jetzt synchronisieren`

Für die E-Mail-Bestätigung sollte in Supabase Auth die Site URL auf die spätere GitHub-Pages-Adresse gesetzt werden.

## 4. GitHub Pages

Repository erstellen, diese Dateien hochladen und auf `main` committen.

Danach in GitHub:
**Settings -> Pages -> Build and deployment -> Source: GitHub Actions**

Der enthaltene Workflow `.github/workflows/pages.yml` veröffentlicht die PWA.

Hinweis: Bei GitHub Free funktioniert Pages aus öffentlichen Repositories. Der Repository-Code enthält keine Tagebucheinträge. Ein Supabase Publishable Key ist für Browser-Apps gedacht; die eigentliche Zugriffskontrolle erfolgt über Auth + Row Level Security.

## 5. Synchronisierungsverhalten

- Speichern funktioniert immer lokal.
- Online + angemeldet: Synchronisierung startet automatisch.
- Offline: Änderungen werden lokal als "wartet" markiert.
- Sobald das Gerät wieder online ist, wird synchronisiert.
- Bei Änderungen desselben Datums auf zwei Geräten gewinnt die zeitlich neuere Änderung.
- Offline-Löschungen werden beim nächsten Sync an Supabase übertragen.

## Datenschutz-Hinweis

Diese Version nutzt Supabase Auth + Row Level Security, aber **keine Ende-zu-Ende-Verschlüsselung der Tagebuchtexte**. Die Daten werden nicht im GitHub-Repository gespeichert. Für eine zusätzliche E2E-Verschlüsselung kann eine spätere Version die Texte bereits im Browser verschlüsseln, bevor sie Supabase erreichen.
