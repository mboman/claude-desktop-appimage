# Changelog

All notable changes to the Claude Desktop AppImage Builder project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-04

### Added
- Initial release of Claude Desktop AppImage Builder
- Build script (`claude_appimage_builder.sh`) for creating AppImage packages
- Support for Claude Desktop version 0.14.10
- Bundled Electron v39.0.0 for application runtime
- Bundled Node.js v24.11.0 for MCP server support
- Automatic download and caching of dependencies (Electron, Node.js, appimagetool)
- AppImage directory structure creation with proper launcher scripts
- Desktop integration files (`.desktop` entry and icon)
- Colored console output for build progress
- Dependency checking (wget, unzip, tar)
- Source validation to ensure claude-desktop is built first

### Features
- Portable AppImage format for distribution-agnostic Linux support
- Full MCP (Model Context Protocol) server support through bundled Node.js
- Self-contained package with all runtime dependencies
- No installation required - just download and run
- Automatic environment setup for proper PATH and Electron configuration
- Sandbox disabled for compatibility across distributions

### Documentation
- Comprehensive README.md with usage instructions
- MCP configuration examples
- Troubleshooting guide
- Installation options (system-wide and user-level)
- Relationship to parent claude-desktop project explained

### Project Setup
- Git repository initialization
- Dual licensing (MIT and Apache 2.0) consistent with parent project
- `.gitignore` configured to exclude build artifacts and downloads
- Changelog following Keep a Changelog format

### Dependencies
- Requires [emsi/claude-desktop](https://github.com/emsi/claude-desktop) as source
- Uses Electron v39.0.0 from official releases
- Uses Node.js v24.11.0 from official distributions
- Uses appimagetool from AppImageKit project

## [Unreleased]

### Planned
- Automatic version detection from claude-desktop source
- CI/CD pipeline for automated builds
- Desktop integration improvements (file associations, protocol handlers)
- Update checker and notification system
- ARM64 architecture support
- Optional minimal builds without Node.js for users not using MCP

---

## Version History

### Version Numbering
This project uses semantic versioning:
- **Major version**: Breaking changes to build script or AppImage structure
- **Minor version**: New features, Claude Desktop version updates
- **Patch version**: Bug fixes, documentation updates

### Claude Desktop Version Tracking
The AppImage version tracks the Claude Desktop version it packages:
- AppImage 1.0.0 → Claude Desktop 0.14.10
- Future versions will update based on upstream releases

[1.0.0]: https://github.com/mboman/claude-desktop-appimage/releases/tag/v1.0.0
[Unreleased]: https://github.com/mboman/claude-desktop-appimage/compare/v1.0.0...HEAD