#!/data/data/com.termux/files/usr/bin/bash

# 🚀 Cosmic Corner Book - Termux Smart Setup (FIXED)
set -e

echo "🌟 Cosmic Corner Book Launcher"
echo "================================================"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

print_status() { echo -e "${BLUE}📋 $1${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_skip() { echo -e "${YELLOW}⏭️  $1${NC}"; }

if [[ ! -d "/data/data/com.termux" ]]; then
    print_error "Termux only!"
    exit 1
fi

print_status "🔍 Auto-locating CosmicCorner..."

# ✅ FIXED: Proper storage check (no tilde expansion issue)
STORAGE_DIR="$HOME/storage/downloads"
if [[ ! -d "$STORAGE_DIR" ]]; then
    print_status "💾 Setting up storage access..."
    termux-setup-storage
    sleep 1  # Wait for storage to mount
fi

# Find CosmicCorner
COSMIC_DIR=""
for dir in \
    "$HOME/storage/downloads/CosmicCorner" \
    "$HOME/storage/shared/Download/CosmicCorner" \
    "/sdcard/Download/CosmicCorner" \
    "/storage/emulated/0/Download/CosmicCorner"; 
do
    if [[ -f "$dir/server.py" ]]; then
        COSMIC_DIR="$dir"
        break
    fi
done

if [[ -z "$COSMIC_DIR" && -f "./server.py" ]]; then
    COSMIC_DIR="$(pwd)"
    print_warning "Using current directory"
fi

if [[ -z "$COSMIC_DIR" ]]; then
    print_error "CosmicCorner not found!"
    echo "Expected: ~/storage/downloads/CosmicCorner/server.py"
    echo "Fix: termux-setup-storage"
    exit 1
fi

print_success "✅ Found: $COSMIC_DIR"

cd "$COSMIC_DIR" || exit 1
print_success "✅ In project dir"

# Dependencies (silent checks)
print_status "🔍 Dependencies..."
command -v python3 >/dev/null 2>&1 || { print_status "🐍 Python..."; pkg install python -y; print_success "Python ✓"; } || print_skip "Python"
command -v pip3 >/dev/null 2>&1 || { print_status "🔧 pip..."; pkg install python-pip -y; print_success "pip ✓"; } || print_skip "pip"
python3 -c "import psutil" 2>/dev/null 1>&2 || { 
    print_status "🔧 Build tools..."; pkg install clang make cmake libffi openssl -y
    print_status "📚 psutil..."; pip3 install psutil --user
    print_success "psutil ✓"
} || print_skip "psutil"

print_success "✅ Ready!"

# Dirs
mkdir -p Media/{Products,Receipts,QR_Codes} Reports 2>/dev/null || true

# Kill server
print_status "🛑 Port 9000..."
lsof -ti:9000 >/dev/null 2>&1 && { kill -9 $(lsof -ti:9000) 2>/dev/null; sleep 1; print_success "Port cleared"; } || print_skip "Port free"

print_success "✅ Perfect!"

echo ""
echo "🚀 Starting http://localhost:9000"
echo "📱 Mobile: http://$(hostname -I | awk '{print $1}' | head -n1 2>/dev/null || echo "localhost"):9000"
echo "====================================="

exec python3 server.py
