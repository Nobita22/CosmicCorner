#!/data/data/com.termux/files/usr/bin/bash

# Cosmic Corner Server Starter
echo "🚀 Starting Cosmic Corner Server..."

# Navigate to Downloads/CC folder
cd ~/storage/downloads/CC || {
    echo "❌ Error: CC folder not found in storage/downloads/"
    echo "Please check if folder exists: \$HOME/storage/downloads/CC"
    exit 1
}

# Check if server.py exists
if [ ! -f "server.py" ]; then
    echo "❌ Error: server.py not found in CC folder"
    exit 1
fi

# Check if python is installed
if ! command -v python &> /dev/null; then
    echo "❌ Python not found. Install with: pkg install python"
    exit 1
fi

echo "✅ Navigated to: $(pwd)"
echo "✅ Starting server.py..."
echo "🌐 Open browser to view dashboard"
echo "📱 Server running on http://localhost:8000 (or port shown below)"
echo "🛑 Press Ctrl+C to stop"

# Run the server
python server.py
