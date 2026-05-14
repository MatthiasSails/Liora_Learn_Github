# Portainer CE auf Liora_VM

## Ziel

Portainer CE direkt auf der Liora_VM betreiben, damit alle Docker-Stacks per GitOps aus diesem Repo verwaltet werden können — gleiche Architektur wie `hausstelle_portainer` auf dem Synology.

## Warum nicht der Portainer Agent?

Der normale Portainer Agent braucht eine eingehende Verbindung (Port 9001) vom Home-Portainer zur VM. Das ist nicht möglich weil:
- Die AWS Security Group der VM (Gruppe: `de_terminal`) wird durch den Schulungsanbieter (DataScientest) verwaltet — kein Zugriff
- Der Home-Portainer (`192.168.1.2:9443`) ist nur lokal erreichbar, kein Edge Agent möglich

## Plan

1. Portainer CE Stack in `portainer/docker-compose.yml` anlegen (Port 9443)
2. AWS Security Group Port 9443 freischalten — beim Schulungsanbieter anfragen oder nach Kursende selbst verwalten
3. Bootstrap: einmalig per SSH starten
4. Danach: Stacks per GitOps aus diesem Repo (`corolla-run/`, etc.)

## Referenz-Implementierung

`hausstelle_portainer` auf dem Synology — gleiche Architektur, dort bereits produktiv.

## Offene Punkte

- Port 9443 in AWS Security Group `de_terminal` freischalten
- Datenpersistenz: Portainer-Volume auf der VM (Daten gehen bei `docker compose down -v` verloren)
- Beim VM-Neustart läuft Portainer automatisch weiter (`restart: unless-stopped`)
