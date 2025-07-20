# MaxMind GeoLite2 Database

This directory contains the MaxMind GeoLite2 City database for IP geolocation.

## Setup Instructions

1. Register for a free MaxMind account at: https://www.maxmind.com/en/geolite2/signup

2. Get your license key from your account page

3. Download the database:
   ```bash
   MAXMIND_LICENSE_KEY=your_license_key bin/download_maxmind
   ```

4. The database file (`GeoLite2-City.mmdb`) will be downloaded to this directory

## Important Notes

- The `.mmdb` files are excluded from git via `.gitignore`
- You need to download the database on each development machine
- For production, either:
  - Build the database into your Docker image (see Dockerfile)
  - Mount it as a volume
  - Download it during container startup

## Database Updates

MaxMind updates the GeoLite2 database twice weekly. Consider setting up a cron job to keep it updated:

```bash
# Example cron entry (runs every Tuesday and Friday at 2 AM)
0 2 * * 2,5 cd /path/to/app && MAXMIND_LICENSE_KEY=your_key bin/download_maxmind
```