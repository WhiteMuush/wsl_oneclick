# WSL Auto-Setup Script

Un script PowerShell automatisé pour installer et configurer WSL (Windows Subsystem for Linux) avec Ubuntu et les outils de développement essentiels.

## 🎯 Fonctionnalités

- **Installation automatique de WSL** avec Ubuntu
- **Configuration interactive** des outils de développement
- **Installation optionnelle** de :
  - Git avec configuration personnalisée
  - Node.js via NVM (dernière version LTS)
  - Docker et Docker Compose
  - Python 3 avec pip et venv
  - Alias utiles pour le terminal

## 📋 Prérequis

- Windows 10 version 2004+ ou Windows 11
- PowerShell 5.1 ou plus récent
- Privilèges administrateur
- Connexion Internet

## 🚀 Installation

### 1. Télécharger le script

Téléchargez le fichier `wsl-autosetup.ps1` ou copiez le code dans un nouveau fichier PowerShell.

### 2. Exécuter le script

1. **Ouvrez PowerShell en tant qu'administrateur**
   - Clic droit sur le menu Démarrer → "Windows PowerShell (Admin)"
   - Ou recherchez "PowerShell" → Clic droit → "Exécuter en tant qu'administrateur"

2. **Naviguez vers le dossier contenant le script**
   ```powershell
   cd "C:\chemin\vers\votre\script"
   ```

3. **Autorisez l'exécution de scripts si nécessaire**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Lancez le script**
   ```powershell
   .\wsl-autosetup.ps1
   ```

## 🔧 Utilisation

### Première exécution

Si WSL n'est pas encore installé :
1. Le script activera automatiquement les fonctionnalités Windows nécessaires
2. Installera WSL avec Ubuntu
3. **Un redémarrage sera nécessaire**
4. Après redémarrage, relancez le script pour continuer la configuration

### Configuration interactive

Le script vous proposera d'installer chaque outil :

```
Souhaitez-vous mettre à jour le système ? [y/N]: y
Installer et configurer Git ? [y/N]: y
Nom Git : VotreNom
Email Git : votre.email@example.com
Installer Node.js via NVM ? [y/N]: y
Installer Docker ? [y/N]: y
Installer Python 3, pip et venv ? [y/N]: y
Ajouter des alias utiles ? [y/N]: y
```

### Outils installés

| Outil | Description | Commande de test |
|-------|-------------|------------------|
| **Git** | Contrôle de version | `git --version` |
| **Node.js** | Runtime JavaScript | `node --version` |
| **NVM** | Gestionnaire de versions Node | `nvm --version` |
| **Docker** | Conteneurisation | `docker --version` |
| **Python 3** | Langage de programmation | `python3 --version` |
| **pip** | Gestionnaire de paquets Python | `pip3 --version` |

### Alias ajoutés

```bash
gs      # git status
ll      # ls -la
..      # cd ..
```

## 🛠️ Personnalisation

### Modifier la distribution Linux

Par défaut, le script installe Ubuntu. Pour changer :

```powershell
# Remplacer dans le script
wsl --install -d Ubuntu
# Par exemple pour Debian :
wsl --install -d Debian
```

### Ajouter d'autres outils

Vous pouvez modifier la section bash du script pour ajouter d'autres outils :

```bash
if ask "Installer VS Code Server ?"; then
    curl -fsSL https://code-server.dev/install.sh | sh
fi
```

## 🔍 Dépannage

### Erreur de privilèges administrateur

**Problème :** `Ce script nécessite des privilèges administrateur`

**Solution :** Relancez PowerShell en tant qu'administrateur

### WSL non détecté après installation

**Problème :** Le script indique que WSL n'est pas installé

**Solutions :**
1. Vérifiez que Windows est à jour
2. Redémarrez votre ordinateur
3. Vérifiez que la virtualisation est activée dans le BIOS

### Erreur de politique d'exécution

**Problème :** `Impossible de charger le fichier car l'exécution de scripts est désactivée`

**Solution :**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Docker nécessite un redémarrage de session

**Problème :** Docker fonctionne uniquement avec `sudo`

**Solution :** Fermez et rouvrez votre terminal WSL pour appliquer les permissions de groupe

## 📚 Commandes utiles après installation

### Gestion WSL

```powershell
# Lister les distributions installées
wsl --list --verbose

# Arrêter WSL
wsl --shutdown

# Définir la distribution par défaut
wsl --set-default Ubuntu

# Accéder à WSL
wsl
```

### Gestion Node.js avec NVM

```bash
# Installer une version spécifique
nvm install 18.17.0

# Utiliser une version
nvm use 18.17.0

# Lister les versions installées
nvm list
```

### Gestion Docker

```bash
# Démarrer Docker (si pas automatique)
sudo service docker start

# Tester Docker
docker run hello-world

# Voir les conteneurs
docker ps
```

## 🔄 Mise à jour

Pour mettre à jour les outils installés :

```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade

# Mise à jour Node.js
nvm install --lts
nvm use --lts

# Mise à jour Python packages
pip3 install --upgrade pip
```

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour proposer des améliorations :

1. Forkez le projet
2. Créez une branche pour votre fonctionnalité
3. Committez vos modifications
4. Proposez une Pull Request

## 📄 Licence

Ce script est sous licence MIT. Vous êtes libre de l'utiliser, le modifier et le distribuer.

## ⚠️ Avertissements

- Testez le script dans un environnement de développement avant utilisation en production
- Assurez-vous d'avoir des sauvegardes de vos données importantes
- Le script modifie les configurations système et peut nécessiter un redémarrage

## 📞 Support

Pour toute question ou problème :

1. Consultez la section [Dépannage](#🔍-dépannage)
2. Vérifiez les [issues GitHub](https://github.com/votre-repo/issues) existantes
3. Créez une nouvelle issue si nécessaire

---

**Dernière mise à jour :** Juillet 2025  
**Version :** 1.1  
**Compatibilité :** Windows 10/11, PowerShell 5.1+

