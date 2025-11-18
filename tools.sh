#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root or with sudo"
    exit 1
fi

print_status "Starting installation of all reconnaissance tools..."

# Update system
print_status "Updating system packages..."
apt update && apt upgrade -y

# Install basic dependencies
print_status "Installing basic dependencies..."
apt install -y git curl wget python3 python3-pip python3-venv golang nano

# Install WhatWeb
print_status "Installing WhatWeb..."
apt install -y whatweb

# Install webtech
print_status "Installing webtech..."
pip3 install webtech

# Configure Go environment
print_status "Configuring Go environment..."
if ! grep -q "GOROOT" /root/.bashrc; then
    cat >> /root/.bashrc << 'EOF'

# Go Path
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
EOF
    source /root/.bashrc
    print_success "Go environment configured"
fi

# Install SubFinder
print_status "Installing SubFinder..."
apt install -y subfinder

# Install Sublist3r
print_status "Installing Sublist3r..."
apt install -y sublist3r

# Install Amass
print_status "Installing Amass..."
apt install -y amass

# Install AssetFinder
print_status "Installing AssetFinder..."
apt install -y assetfinder

# Install Knockpy
print_status "Installing Knockpy..."
apt install -y knockpy

# Install Anew
print_status "Installing Anew..."
go install github.com/tomnomnom/anew@latest
cp /root/go/bin/anew /usr/bin/

# Install HTTPX
print_status "Installing HTTPX..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
cp /root/go/bin/httpx /usr/bin/

# Install GAU
print_status "Installing GAU..."
git clone https://github.com/lc/gau.git /tmp/gau
cd /tmp/gau/cmd/gau
go build
mv gau /usr/local/bin/
cd /
rm -rf /tmp/gau

# Install GoSpider
print_status "Installing GoSpider..."
go install github.com/jaeles-project/gospider@latest
cp /root/go/bin/gospider /usr/bin/

# Install ParamSpider
print_status "Installing ParamSpider..."
git clone https://github.com/devanshbatham/paramspider /opt/paramspider
cd /opt/paramspider
pip3 install .
cd /

# Install Arjun
print_status "Installing Arjun..."
apt install -y arjun

# Install GF
print_status "Installing GF and patterns..."
go install github.com/tomnomnom/gf@latest
cp /root/go/bin/gf /usr/bin/
git clone https://github.com/1ndianl33t/Gf-Patterns /opt/Gf-Patterns
mkdir -p /root/.gf
cp /opt/Gf-Patterns/*.json /root/.gf/

# Install Shodan
print_status "Installing Shodan..."
pip3 install shodan

# Install Sub404
print_status "Installing Sub404..."
git clone https://github.com/r3curs1v3-pr0xy/sub404.git /opt/sub404

# Install DNS Reaper
print_status "Installing DNS Reaper..."
git clone https://github.com/punk-security/dnsReaper.git /opt/dnsReaper

# Install Hakrawler
print_status "Installing Hakrawler..."
go install github.com/hakluke/hakrawler@latest
cp /root/go/bin/hakrawler /usr/bin/

# Install Waybackurls
print_status "Installing Waybackurls..."
go install github.com/tomnomnom/waybackurls@latest
cp /root/go/bin/waybackurls /usr/bin/

# Install Dirhunt
print_status "Installing Dirhunt..."
pip3 install dirhunt

# Install Evine
print_status "Installing Evine..."
go install github.com/saeeddhqan/evine@latest
cp /root/go/bin/evine /usr/bin/

# Install GoLinkFinder
print_status "Installing GoLinkFinder..."
go install github.com/0xsha/GoLinkFinder@latest
cp /root/go/bin/GoLinkFinder /usr/bin/

# Install GitPaths
print_status "Installing GitPaths..."
go install -v github.com/mllamazares/gitpaths@latest
cp /root/go/bin/gitpaths /usr/bin/

# Install JSFScan
print_status "Installing JSFScan..."
git clone https://github.com/KathanP19/JSFScan.sh /opt/JSFScan
chmod +x /opt/JSFScan/install.sh
cd /opt/JSFScan && bash install.sh && cd /

# Install Censys Subdomain Finder
print_status "Installing Censys Subdomain Finder..."
git clone https://github.com/christophetd/censys-subdomain-finder.git /opt/censys-subdomain-finder
pip3 install -r /opt/censys-subdomain-finder/requirements.txt

# Install crt.sh tool
print_status "Installing crt.sh tool..."
git clone https://github.com/az7rb/crt.sh.git /opt/crt.sh
chmod +x /opt/crt.sh/crt.sh

# Create symbolic links for easy access
print_status "Creating symbolic links..."
ln -sf /opt/crt.sh/crt.sh /usr/local/bin/crt.sh 2>/dev/null || true

# Clean up
print_status "Cleaning up..."
apt autoremove -y

print_success "All tools have been installed successfully!"
print_warning "Please note:"
echo "1. For Censys, you need to set your API credentials:"
echo "   export CENSYS_API_ID=your_api_id"
echo "   export CENSYS_API_SECRET=your_api_secret"
echo ""
echo "2. For Shodan, initialize with: shodan init YOUR_API_KEY"
echo ""
echo "3. Some tools are installed in /opt/ directory"
echo "4. Reload your shell or run: source ~/.bashrc"
echo ""
print_success "Installation completed! Happy hacking!"