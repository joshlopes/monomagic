# Installing as a Home Assistant Add-on

This guide explains how to install the Google Keep to Home Assistant Shopping List Sync as a local add-on in Home Assistant.

## Prerequisites

- A running Home Assistant instance
- Access to the Home Assistant file system
- The Shopping List integration enabled in Home Assistant

## Installation Steps

### 1. Prepare the Add-on Directory

1. Locate your Home Assistant configuration directory. This is typically:
   - `/config` if you're using Home Assistant OS or the supervised installation
   - The directory where your `configuration.yaml` file is located for other installations

2. Inside this directory, create an `addons` directory if it doesn't already exist:
   ```bash
   mkdir -p /config/addons
   ```

3. Create a directory for this add-on:
   ```bash
   mkdir -p /config/addons/google-keep-ha-sync
   ```

### 2. Copy the Add-on Files

1. Copy all the files from this repository to the add-on directory:
   ```bash
   cp -r * /config/addons/google-keep-ha-sync/
   ```

   Alternatively, you can clone the repository directly:
   ```bash
   cd /config/addons
   git clone https://github.com/yourusername/home-assistant-google-sync.git google-keep-ha-sync
   ```

### 3. Install the Add-on in Home Assistant

1. In your Home Assistant UI, go to **Settings** → **Add-ons** → **Add-on Store**
2. Click the menu in the top-right corner and select **Reload**
3. Click on the menu again and select **Local Add-ons**
4. You should see "Google Keep to HA Shopping List Sync" in the list
5. Click on it and then click **Install**

### 4. Configure the Add-on

1. After installation, go to the **Configuration** tab
2. Enter your Google account information:
   - `GOOGLE_EMAIL`: Your Google account email
   - `GOOGLE_APP_PASSWORD`: Your master token or Google App Password (see main README for instructions)
   - `SYNC_INTERVAL`: How often to sync (in seconds, default: 300)
3. Click **Save**

### 5. Start the Add-on

1. Go to the **Info** tab
2. Click **Start**
3. Check the logs to make sure everything is working correctly

## Troubleshooting

If you encounter issues:

1. Check the add-on logs for error messages
2. Verify that your Google credentials are correct
3. Make sure the Shopping List integration is enabled in Home Assistant
4. Ensure your Home Assistant instance has internet access

For authentication issues, refer to the main README for detailed instructions on obtaining a master token.

## Updating the Add-on

To update the add-on:

1. Stop the add-on
2. Replace the files in the add-on directory with the new version
3. Start the add-on again

## Uninstalling

To uninstall the add-on:

1. Stop the add-on
2. Uninstall it from the Home Assistant UI
3. Optionally, remove the add-on directory from your file system
