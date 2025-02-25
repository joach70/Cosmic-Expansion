#!/usr/bin/bash
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir io.github.Chimi70.cosmic_expansion.yml
