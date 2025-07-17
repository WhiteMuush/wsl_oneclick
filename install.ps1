# wsl-autosetup.ps1 - Version améliorée

# Vérification des privilèges administrateur
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Ce script nécessite des privilèges administrateur." -ForegroundColor Red
    Write-Host "Relancez PowerShell en tant qu'administrateur." -ForegroundColor Yellow
    Pause
    exit
}

$ErrorActionPreference = "Stop"

Write-Host "Vérification et installation de WSL & Ubuntu..." -ForegroundColor Green

try {
    # Active WSL & VirtualMachinePlatform si ce n'est pas déjà activé
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart | Out-Null
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart | Out-Null
} catch {
    Write-Host "Erreur lors de l'activation des fonctionnalités Windows : $_" -ForegroundColor Red
    exit 1
}

# Vérifie si WSL est déjà installé
try {
    $wslStatus = wsl --status 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "WSL non installé"
    }
} catch {
    Write-Host "WSL non détecté, installation en cours..." -ForegroundColor Yellow
    wsl --install -d Ubuntu
    Write-Host "Redémarrage nécessaire. Relancez ce script après redémarrage." -ForegroundColor Cyan
    Pause
    exit
}

Write-Host "WSL est installé." -ForegroundColor Green

# Vérifier qu'Ubuntu est disponible
$wslDistros = wsl --list --quiet
if (-not ($wslDistros -contains "Ubuntu")) {
    Write-Host "Ubuntu n'est pas installé dans WSL." -ForegroundColor Red
    Write-Host "Installez Ubuntu depuis le Microsoft Store ou avec : wsl --install -d Ubuntu" -ForegroundColor Yellow
    exit 1
}

# Créer le script Bash dans une variable
$bashScript = @"
#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

function ask() {
    read -p "\$1 [y/N]: " answer
    case "\$answer" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

echo -e "\${GREEN}Script de configuration WSL - mode interactif\${NC}"
echo "----------------------------------------"

if ask "Souhaitez-vous mettre à jour le système ?"; then
    echo -e "\${YELLOW}Mise à jour du système...\${NC}"
    sudo apt update && sudo apt upgrade -y
fi

if ask "Installer et configurer Git ?"; then
    if ! command -v git &> /dev/null; then
        sudo apt install -y git
    fi
    read -p "Nom Git : " git_name
    read -p "Email Git : " git_email
    git config --global user.name "\$git_name"
    git config --global user.email "\$git_email"
    git config --global init.defaultBranch main
    echo -e "\${GREEN}Git configuré avec succès.\${NC}"
fi

if ask "Installer Node.js via NVM ?"; then
    if [ ! -d "\$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
        export NVM_DIR="\$HOME/.nvm"
        [ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
        echo -e "\${GREEN}Node.js installé via NVM.\${NC}"
    else
        echo -e "\${YELLOW}NVM déjà installé.\${NC}"
    fi
fi

if ask "Installer Docker ?"; then
    if ! command -v docker &> /dev/null; then
        sudo apt install -y docker.io docker-compose
        sudo groupadd docker 2>/dev/null || true
        sudo usermod -aG docker \$USER
        echo -e "\${GREEN}Docker installé. Relancez votre session pour activer les droits Docker.\${NC}"
    else
        echo -e "\${YELLOW}Docker déjà installé.\${NC}"
    fi
fi

if ask "Installer Python 3, pip et venv ?"; then
    sudo apt install -y python3 python3-pip python3-venv
    echo -e "\${GREEN}Python 3 installé avec pip et venv.\${NC}"
fi

if ask "Ajouter des alias utiles ?"; then
    if ! grep -q "alias gs=" ~/.bashrc; then
        echo "alias gs='git status'" >> ~/.bashrc
        echo "alias ll='ls -la'" >> ~/.bashrc
        echo "alias ..='cd ..'" >> ~/.bashrc
        echo -e "\${GREEN}Alias ajoutés au .bashrc\${NC}"
    else
        echo -e "\${YELLOW}Alias déjà présents.\${NC}"
    fi
fi

echo -e "\${GREEN}Setup terminé. Relancez le terminal pour finaliser.\${NC}"
"@

# Chemin temporaire Windows pour stocker le script
$tempScriptPath = "$env:USERPROFILE\setup-wsl.sh"

try {
    Set-Content -Path $tempScriptPath -Value $bashScript -Encoding UTF8
    
    # Créer dossier dans WSL et copier le script
    Write-Host "Transfert du script vers WSL..." -ForegroundColor Green
    wsl mkdir -p /tmp/setup
    wsl cp "/mnt/c/Users/$env:USERNAME/setup-wsl.sh" /tmp/setup/setup-wsl.sh
    wsl chmod +x /tmp/setup/setup-wsl.sh
    
    # Lancer le script dans WSL
    Write-Host "Lancement du script dans WSL..." -ForegroundColor Green
    wsl bash /tmp/setup/setup-wsl.sh
    
} catch {
    Write-Host "Erreur lors de l'exécution : $_" -ForegroundColor Red
    exit 1
} finally {
    # Nettoyage des fichiers temporaires
    try {
        Remove-Item -Path $tempScriptPath -Force -ErrorAction SilentlyContinue
        wsl rm -f /tmp/setup/setup-wsl.sh 2>/dev/null
    } catch {
        # Ignorer les erreurs de nettoyage
    }
}

Write-Host "Installation terminée !" -ForegroundColor Green

#pizzalover