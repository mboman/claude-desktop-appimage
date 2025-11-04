# Contributing to Claude Desktop AppImage Builder

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Project Relationship

This project is a companion to [emsi/claude-desktop](https://github.com/emsi/claude-desktop). While that project handles extraction from the Windows installer and creating Debian packages, this project focuses on creating portable AppImage packages.

**Important**: Changes to Claude Desktop itself should be contributed to the parent project. This project focuses on the AppImage packaging workflow.

## How to Contribute

### Reporting Issues

When reporting issues, please include:

1. Your Linux distribution and version
2. The command you ran
3. Full error output
4. Whether you've successfully built claude-desktop first
5. Contents of relevant logs

### Suggesting Enhancements

Enhancement suggestions are welcome! Consider:

- Will it improve portability across distributions?
- Does it maintain the single-script simplicity?
- Is it compatible with the parent claude-desktop project?

### Pull Requests

When submitting a pull request:

1. **Fork and branch**: Create a feature branch from `main`
2. **Test thoroughly**: Verify on at least one major distribution
3. **Update docs**: Update README.md and CHANGELOG.md as needed
4. **Commit messages**: Use clear, descriptive commit messages
5. **Keep it focused**: One feature/fix per pull request

#### Commit Message Format

```
<type>: <short summary>

<detailed description>

Fixes #<issue-number>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Example:
```
feat: Add support for ARM64 architecture

- Detect system architecture
- Download appropriate Electron and Node.js binaries
- Update AppImage naming to include architecture

Fixes #42
```

## Development Setup

### Prerequisites

```bash
# Install development dependencies
sudo dnf install git wget unzip tar  # Fedora/Bazzite
# or
sudo apt install git wget unzip tar  # Debian/Ubuntu
```

### Local Testing


```bash
# Clone both projects
git clone https://github.com/emsi/claude-desktop.git ~/src/claude-desktop
git clone https://github.com/YOUR_USERNAME/claude-desktop-appimage.git ~/src/claude-desktop-appimage

# Build claude-desktop first
cd ~/src/claude-desktop
./install-claude-desktop.sh

# Test AppImage builder
cd ~/src/claude-desktop-appimage
./claude_appimage_builder.sh

# Run the AppImage
./Claude-*.AppImage
```

## Code Style

### Bash Script Guidelines

- Use `set -e` for error handling
- Add descriptive comments for complex sections
- Use meaningful variable names
- Follow existing indentation (2 spaces)
- Add color-coded log output for user feedback
- Validate inputs and check dependencies

### Example:

```bash
# Check if source directory exists
if [ ! -d "$CLAUDE_SOURCE_DIR" ]; then
    log_error "Claude source not found at $CLAUDE_SOURCE_DIR"
    exit 1
fi
```

## Areas for Contribution

### High Priority

- **ARM64 support**: Detect architecture and use appropriate binaries
- **Automated testing**: CI/CD pipeline for build verification
- **Version detection**: Auto-detect Claude version from source
- **Update mechanism**: Check and notify about new versions

### Medium Priority

- **Build optimizations**: Parallel downloads, better caching
- **Desktop integration**: File associations, protocol handlers
- **Configuration tool**: GUI for MCP server setup
- **Documentation**: Video tutorials, more troubleshooting tips


### Lower Priority

- **Alternative package formats**: Snap, Flatpak support
- **Minimal builds**: Optional Node.js-free version for non-MCP users
- **Custom themes**: Allow icon and theme customization
- **Build profiles**: Development vs. production builds

## Testing

### Manual Testing Checklist

Before submitting a PR, verify:

- [ ] Script runs without errors
- [ ] AppImage builds successfully
- [ ] AppImage runs and Claude Desktop launches
- [ ] MCP servers work (test with a simple server)
- [ ] Desktop file appears in application menu
- [ ] Icon displays correctly
- [ ] Clean build (remove AppDir and rebuild)
- [ ] Cached build (rerun without removing downloads)

### Test on Multiple Distributions

Ideally test on:

- **Arch-based**: Bazzite, Arch, Manjaro
- **Debian-based**: Ubuntu, Debian, Linux Mint
- **RPM-based**: Fedora, RHEL, openSUSE

Use containers or VMs for testing:

```bash
# Example: Test in Ubuntu container
docker run -it --rm -v $(pwd):/work ubuntu:latest
cd /work
apt update && apt install -y wget unzip tar
./claude_appimage_builder.sh
```

## Documentation

### README Updates

When adding features, update:

- Feature list
- Usage examples
- Configuration section
- Troubleshooting (if relevant)

### CHANGELOG Format

Follow [Keep a Changelog](https://keepachangelog.com/):

```markdown
## [Unreleased]

### Added
- New feature description

### Changed  
- Modified behavior description

### Fixed
- Bug fix description
```


## Release Process

Maintainers follow this process for releases:

1. **Update version numbers** in script and docs
2. **Update CHANGELOG.md** with release notes
3. **Test build** on multiple distributions
4. **Create git tag**: `git tag -a v1.x.x -m "Release v1.x.x"`
5. **Push tag**: `git push origin v1.x.x`
6. **Create GitHub release** with built AppImage attached
7. **Update parent project** if integration changed

## License

By contributing, you agree that your contributions will be licensed under the same dual MIT/Apache 2.0 license as the project.

## Questions?

- Open an issue for questions
- Check existing issues and PRs first
- Be respectful and constructive

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment. We pledge to make participation in our project a harassment-free experience for everyone.

### Expected Behavior

- Be respectful and considerate
- Welcome newcomers and help them get started
- Accept constructive criticism gracefully
- Focus on what's best for the community

### Unacceptable Behavior

- Harassment, discrimination, or derogatory language
- Trolling, insulting comments, or personal attacks
- Publishing others' private information
- Other conduct inappropriate in a professional setting

### Enforcement

Project maintainers have the right and responsibility to remove, edit, or reject contributions that violate this code of conduct.

## Attribution

This CONTRIBUTING.md is adapted from open source contribution guidelines and best practices from various successful projects.

---

Thank you for contributing to make Claude Desktop more accessible on Linux! 🎉