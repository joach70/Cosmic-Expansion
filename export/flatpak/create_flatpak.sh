#!/usr/bin/bash
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir org.flatpak.Cosmic_Expansion.yml
