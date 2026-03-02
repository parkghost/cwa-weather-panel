# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CWA Weather Panel is an ESPHome-based firmware for ESP32-S3 that displays Taiwan CWA (Central Weather Administration) town-level weather forecasts on a 4.2" e-paper display (Waveshare DEPG0420).

## Build & Development

```bash
# Build and flash firmware via USB
esphome run cwa-weather-panel-esp32-s3.yaml

# Build factory firmware (includes improv serial, MAC suffix, project metadata)
esphome run cwa-weather-panel-esp32-s3.factory.yaml

# Compile only (no flash)
esphome compile cwa-weather-panel-esp32-s3.yaml

# Create a GitHub release
make release VERSION=x.y.z
```

Setup: copy `templates/secrets.yaml` to `secrets.yaml` and fill in credentials before building.

## Architecture

### Configuration Hierarchy

```
cwa-weather-panel-esp32-s3.factory.yaml
  └── cwa-weather-panel-esp32-s3.yaml        # Main config (all device logic)
        ├── boards/esp32s3/*.yaml             # Board pin definitions (SPI, display)
        ├── templates/device_standalone.yaml  # WiFi, web server, captive portal
        ├── common/epd/toolkit.yaml           # E-paper display utilities
        ├── common/epd/toolkit_ext.yaml       # Extended EPD helpers
        ├── common/debug_esp32.yaml           # Heap/loop monitoring
        └── common/debug_psram.yaml           # PSRAM diagnostics
```

- **Factory yaml** wraps the main yaml, adding MAC suffix, improv serial, and dashboard import URL. CI builds both variants.
- **Main yaml** contains all device logic: forecasts, display rendering, user config entities, OTA, scheduling.

### External Components

Two custom ESPHome components hosted on separate repos:
- `github://parkghost/esphome-epaper` — Waveshare e-paper display driver
- `github://parkghost/esphome-cwa-town-forecast` — CWA weather API integration

### Key Sections in Main Config

| Section | Description |
|---------|-------------|
| `cwa_town_forecast` | Two forecast instances: 3-day and 7-day, both using CWA API |
| `script` | `validate_and_update_forecast`, `update_forecast_all`, `fire_refresh_event` |
| `select` | Forecast mode (7-Day/18-Hour), city selector (22 Taiwan cities) |
| `display` lambda | ~300 line rendering function handling multiple display states |

### Display States

The display lambda handles: WiFi AP mode → connecting → firmware updating → missing config → normal forecast view. Normal view renders date, current weather icon, temperature, precipitation, and either 7-day or 18-hour forecast grid.

## CI/CD

- **CI** (`ci.yml`): Builds both yaml variants with `esphome/build-action` on PRs to `*.yaml` and daily schedule
- **Publish Firmware** (`publish-firmware.yml`): Triggered on GitHub release, uploads firmware artifacts
- **Publish Pages** (`publish-pages.yml`): Builds Jekyll site from `static/`, deploys to GitHub Pages with firmware binaries

## Upstream

This project was forked from `esphome/esphome-project-template`. The upstream remote is kept for reference:
```bash
git fetch upstream
git log upstream/main  # Check for CI/workflow updates to cherry-pick
```