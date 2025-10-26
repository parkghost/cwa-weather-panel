# CWA Weather Panel

A weather display panel powered by ESPHome that shows Taiwan Central Weather Administration (CWA) town-level weather forecasts on an E-Paper display.

## Quick Installation

Visit the [project website](https://parkghost.github.io/cwa-weather-panel/) to install the firmware directly to your device via USB using ESP Web Tools.

## Configuration

After installation, configure your device with:
- WiFi credentials
- CWA API key (obtain from [CWA](https://opendata.cwa.gov.tw/))
- Your city and town name for weather forecasts

## Manual Build

1. Clone this repository
2. Copy `templates/secrets.yaml` to `secrets.yaml` and fill in your credentials
3. Build and upload using ESPHome:
   ```bash
   esphome run cwa-weather-panel-esp32-s3.factory.yaml
   ```
