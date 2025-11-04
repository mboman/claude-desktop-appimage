# Claude Desktop AppImage Builder

**UNOFFICIAL BUILD TOOL**

This project provides a build script to create an AppImage package of Claude Desktop for Linux, with full MCP (Model Context Protocol) server support through bundled Node.js.

## What is this?

This is a companion project to [emsi/claude-desktop](https://github.com/emsi/claude-desktop) that creates portable AppImage packages. While the parent project builds Debian packages from the Windows installer, this project takes a different approach:

- Uses the unpacked Electron app from `claude-desktop` as the source
- Bundles a complete Electron runtime
- Includes Node.js for MCP server support
- Creates a self-contained, portable AppImage that runs on any Linux distribution

## Why AppImage?

AppImages offer several advantages:

- **Portable**: Single executable file that runs anywhere
- **No installation required**: Just download and run
- **Self-contained**: Includes all dependencies (Electron + Node.js)
- **Distribution-agnostic**: Works on any Linux distribution
- **MCP Support**: Bundled Node.js enables running MCP servers

## Prerequisites

Before building, you need:

1. The [emsi/claude-desktop](https://github.com/emsi/claude-desktop) project built at `$HOME/src/claude-desktop`
2. Basic build tools: `wget`, `unzip`, `tar`

## Quick Start

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/claude-desktop-appimage.git
cd claude-desktop-appimage

# Ensure claude-desktop is built first
cd $HOME/src/claude-desktop
./install-claude-desktop.sh
cd -

# Build the AppImage
./claude_appimage_builder.sh

# Run Claude
./Claude-0.14.10-x86_64.AppImage
```

## How It Works

The build script:

1. **Validates source**: Checks that Claude Desktop has been built in the sibling directory
2. **Downloads dependencies**: Fetches Electron and Node.js binaries (cached for subsequent builds)
3. **Creates AppDir structure**: Builds the standard AppImage directory layout
4. **Bundles components**:
   - Copies `app.asar` and `app.asar.unpacked` from claude-desktop
   - Extracts Electron runtime
   - Extracts Node.js runtime (for MCP servers)
5. **Creates launchers**: Sets up AppRun and wrapper scripts with proper environment
6. **Builds AppImage**: Uses appimagetool to create the final portable executable

## Configuration

Edit these variables at the top of `claude_appimage_builder.sh` if needed:

```bash
CLAUDE_VERSION="0.14.10"
ELECTRON_VERSION="39.0.0"
NODE_VERSION="24.11.0"
CLAUDE_SOURCE_DIR="$HOME/src/claude-desktop/build/electron-app"
```

## MCP Server Support

The bundled Node.js enables running MCP servers. Configure them in:

```
~/.config/Claude/claude_desktop_config.json
```

Example configuration:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "node",
      "args": ["/path/to/mcp-server-filesystem/dist/index.js"]
    }
  }
}
```

Since Node.js is bundled in the AppImage, the `node` command will be available when Claude Desktop runs.

## Relationship to claude-desktop

This project depends on [emsi/claude-desktop](https://github.com/emsi/claude-desktop) for:

- The unpacked Electron application (`app.asar` and `app.asar.unpacked`)
- Application icons
- The Linux-compatible native bindings

The parent project handles the complex work of:
- Extracting from the Windows installer
- Creating Linux-compatible native bindings
- Providing the base application structure

This project focuses on:
- Packaging into a portable AppImage format
- Bundling runtime dependencies (Electron + Node.js)
- Creating a distribution-agnostic package

## Installation Options

### System-wide installation

```bash
sudo mv Claude-0.14.10-x86_64.AppImage /usr/local/bin/claude
sudo chmod +x /usr/local/bin/claude
```

### User installation

```bash
mkdir -p ~/.local/bin
mv Claude-0.14.10-x86_64.AppImage ~/.local/bin/claude
chmod +x ~/.local/bin/claude
# Ensure ~/.local/bin is in your PATH
```

### Desktop integration

Most desktop environments will automatically integrate AppImages when run. You can also use [AppImageLauncher](https://github.com/TheAssassin/AppImageLauncher) for better desktop integration.

## Updating

When a new version of Claude Desktop is released:

1. Update the parent project:
   ```bash
   cd $HOME/src/claude-desktop
   git pull
   ./install-claude-desktop.sh
   ```

2. Update version in this project:
   ```bash
   # Edit claude_appimage_builder.sh
   # Update CLAUDE_VERSION="x.x.x"
   ```

3. Rebuild:
   ```bash
   ./claude_appimage_builder.sh
   ```

## Troubleshooting

### "Claude source not found" error

Ensure you've built the parent project first:

```bash
cd $HOME/src/claude-desktop
./install-claude-desktop.sh
```

### AppImage won't run

Try:

```bash
chmod +x Claude-0.14.10-x86_64.AppImage
./Claude-0.14.10-x86_64.AppImage --no-sandbox
```

### MCP servers not working

Verify Node.js is accessible:

```bash
# Extract AppImage to inspect
./Claude-0.14.10-x86_64.AppImage --appimage-extract
./squashfs-root/usr/bin/node --version
```

## Contributing

Contributions are welcome! Please ensure:

1. The script remains portable and works on major Linux distributions
2. Build artifacts are not committed (they're in `.gitignore`)
3. Changes are backward compatible with existing configurations

## License

The build scripts in this repository are dual-licensed under the terms of the MIT license and the Apache License (Version 2.0).

See [LICENSE-MIT](LICENSE-MIT) and [LICENSE-APACHE](LICENSE-APACHE) for details.

The Claude Desktop application is covered by [Anthropic's Consumer Terms](https://www.anthropic.com/legal/consumer-terms).

## Acknowledgments

- [emsi/claude-desktop](https://github.com/emsi/claude-desktop) - Parent project providing the Linux-compatible Claude Desktop base
- [aaddrick/claude-desktop-debian](https://github.com/aaddrick/claude-desktop-debian) - Original inspiration
- [k3d3/claude-desktop-linux-flake](https://github.com/k3d3/claude-desktop-linux-flake) - Early Linux compatibility work
- [AppImage](https://appimage.org/) - Universal Linux package format
- [Anthropic](https://www.anthropic.com/) - Claude Desktop application

## Disclaimer

This is an unofficial build tool. For issues with this script, please file them here. For Claude Desktop application issues, contact Anthropic support.