#!/bin/bash
set -e

# ============================================================================
# Claude AppImage Builder
# ============================================================================
# This script builds an AppImage for Claude Desktop with bundled Electron
# and Node.js for MCP server support.
# ============================================================================

# Configuration Variables
CLAUDE_VERSION="0.14.10"
ELECTRON_VERSION="39.0.0"
NODE_VERSION="24.11.0"
CLAUDE_SOURCE_DIR="$HOME/src/claude-desktop/build/electron-app"
BUILD_DIR="$HOME/src/claude-desktop-appimage"

# Derived variables
ELECTRON_ARCHIVE="electron-v${ELECTRON_VERSION}-linux-x64.zip"
ELECTRON_URL="https://github.com/electron/electron/releases/download/v${ELECTRON_VERSION}/${ELECTRON_ARCHIVE}"
NODE_ARCHIVE="node-v${NODE_VERSION}-linux-x64.tar.xz"
NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/${NODE_ARCHIVE}"
APPIMAGE_NAME="Claude-${CLAUDE_VERSION}-x86_64.AppImage"
APPIMAGETOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        log_error "Required tool '$1' not found. Please install it first."
        exit 1
    fi
}

# Check dependencies
log_info "Checking dependencies..."
check_dependency wget
check_dependency unzip
check_dependency tar

# Check if Claude source exists
if [ ! -f "$CLAUDE_SOURCE_DIR/app.asar" ]; then
    log_error "Claude source not found at $CLAUDE_SOURCE_DIR/app.asar"
    log_error "Please ensure Claude Desktop has been built first."
    exit 1
fi

# Create build directory
log_info "Creating build directory at $BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Clean previous build
if [ -d "AppDir" ]; then
    log_warn "Removing previous AppDir..."
    rm -rf AppDir
fi

# Create AppDir structure
log_info "Creating AppDir structure..."
mkdir -p AppDir/usr/{bin,lib,share/applications,share/icons/hicolor/256x256/apps}

# Copy Claude files
log_info "Copying Claude application files..."
cp -r "$CLAUDE_SOURCE_DIR/app.asar" AppDir/usr/lib/
if [ -d "$CLAUDE_SOURCE_DIR/app.asar.unpacked" ]; then
    cp -r "$CLAUDE_SOURCE_DIR/app.asar.unpacked" AppDir/usr/lib/
fi

# Download Electron if not cached
if [ ! -f "$ELECTRON_ARCHIVE" ]; then
    log_info "Downloading Electron ${ELECTRON_VERSION}..."
    wget -q --show-progress "$ELECTRON_URL"
else
    log_info "Using cached Electron archive"
fi

# Extract Electron
log_info "Extracting Electron..."
mkdir -p AppDir/usr/lib/electron
unzip -q "$ELECTRON_ARCHIVE" -d AppDir/usr/lib/electron/

# Download Node.js if not cached
if [ ! -f "$NODE_ARCHIVE" ]; then
    log_info "Downloading Node.js ${NODE_VERSION}..."
    wget -q --show-progress "$NODE_URL"
else
    log_info "Using cached Node.js archive"
fi

# Extract Node.js
log_info "Extracting Node.js..."
tar -xf "$NODE_ARCHIVE"
# Copy Node.js files, avoiding nested usr directory
cp -r "node-v${NODE_VERSION}-linux-x64"/bin/* AppDir/usr/bin/
cp -r "node-v${NODE_VERSION}-linux-x64"/lib/* AppDir/usr/lib/
cp -r "node-v${NODE_VERSION}-linux-x64"/share/* AppDir/usr/share/
cp -r "node-v${NODE_VERSION}-linux-x64"/include AppDir/usr/ 2>/dev/null || true

# Create launcher script
log_info "Creating launcher script..."
cat > AppDir/usr/bin/claude-desktop << 'EOF'
#!/bin/bash
# Get the real AppDir by going up from usr/bin
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
APPDIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
export PATH="$APPDIR/usr/bin:$PATH"
export ELECTRON_DISABLE_SANDBOX=1
exec "$APPDIR/usr/lib/electron/electron" "$APPDIR/usr/lib/app.asar" --no-sandbox "$@"
EOF
chmod +x AppDir/usr/bin/claude-desktop

# Create AppRun
log_info "Creating AppRun..."
cat > AppDir/AppRun << 'EOF'
#!/bin/bash
APPDIR="$(dirname "$(readlink -f "$0")")"
export PATH="$APPDIR/usr/bin:$PATH"
exec "$APPDIR/usr/bin/claude-desktop" "$@"
EOF
chmod +x AppDir/AppRun

# Copy icon
log_info "Copying icon..."
ICON_SOURCE="$CLAUDE_SOURCE_DIR/../claude_6_256x256x32.png"
if [ -f "$ICON_SOURCE" ]; then
    cp "$ICON_SOURCE" AppDir/usr/share/icons/hicolor/256x256/apps/claude.png
    cp AppDir/usr/share/icons/hicolor/256x256/apps/claude.png AppDir/claude.png
else
    log_warn "Icon not found at $ICON_SOURCE, skipping..."
fi

# Create desktop file
log_info "Creating desktop file..."
cat > AppDir/claude.desktop << 'EOF'
[Desktop Entry]
Name=Claude
Comment=AI assistant from Anthropic
Exec=claude-desktop
Icon=claude
Type=Application
Categories=Utility;Development;
Terminal=false
EOF

# Download appimagetool if not cached
if [ ! -f "appimagetool-x86_64.AppImage" ]; then
    log_info "Downloading appimagetool..."
    wget -q --show-progress "$APPIMAGETOOL_URL"
    chmod +x appimagetool-x86_64.AppImage
else
    log_info "Using cached appimagetool"
fi

# Build the AppImage
log_info "Building AppImage..."
ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir "$APPIMAGE_NAME"

# Success
if [ -f "$APPIMAGE_NAME" ]; then
    log_info "AppImage built successfully!"
    log_info "Location: $BUILD_DIR/$APPIMAGE_NAME"
    log_info ""
    log_info "To run Claude: ./$APPIMAGE_NAME"
    log_info "To install system-wide: sudo mv $APPIMAGE_NAME /usr/local/bin/claude"
    log_info ""
    log_info "To configure MCP servers, create/edit:"
    log_info "  ~/.config/Claude/claude_desktop_config.json"
else
    log_error "AppImage build failed!"
    exit 1
fi
