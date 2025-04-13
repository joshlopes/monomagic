# Google Keep to Home Assistant Shopping List Sync

This project synchronizes your Google Keep shopping list with your Home Assistant shopping list. It automatically transfers unchecked items from your Google Keep shopping list to Home Assistant and marks them as checked in Google Keep.

## How It Works

The application:
1. Authenticates with your Google Keep account using your email and app password or master token
2. Finds your shopping list in Google Keep:
   - Looks for notes with "shopping" in the title
   - Preferably uses a list that starts with "Shopping"
   - If multiple lists are found, it uses the first one that starts with "Shopping"
   - If no list starts with "Shopping" but other lists contain "shopping", it uses the first one found
   - If no shopping list is found, it creates a new one called "Shopping List"
3. For each unchecked item in your Google Keep shopping list:
   - Adds the item to your Home Assistant shopping list
   - Marks the item as checked in Google Keep
4. Repeats this process at regular intervals (default: every 5 minutes)

## Prerequisites

- Python 3.11 or higher
- A Google account with a shopping list in Google Keep
- A Home Assistant instance with the Shopping List integration enabled
- Google App Password (for accounts with 2FA enabled)
- Home Assistant Long-Lived Access Token

## Installation

### Creating the .env File

Before running the application, create a `.env` file in the project root with the following content:

```
GOOGLE_EMAIL=your@email.com
GOOGLE_APP_PASSWORD=your_app_password
HA_URL=http://homeassistant.local:8123
HA_TOKEN=your_long_lived_token
SYNC_INTERVAL=300
```

Replace the values with your actual credentials and configuration.

### Option 1: Run Directly with Python

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/home-assistant-google-sync.git
   cd home-assistant-google-sync
   ```

2. Set up a local Python environment (recommended):
   ```
   make setup-local
   ```
   This creates a virtual environment and installs all dependencies.

3. Create a `.env` file with your configuration:
   ```
   GOOGLE_EMAIL=your@email.com
   GOOGLE_APP_PASSWORD=your_app_password
   HA_URL=http://homeassistant.local:8123
   HA_TOKEN=your_long_lived_token
   SYNC_INTERVAL=300
   ```

4. Run the script:
   ```
   make run-local
   ```

   Alternatively, you can run it directly:
   ```
   source venv/bin/activate  # Activate the virtual environment
   python index.py
   ```

   For more detailed instructions on local development, see [LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md).

### Option 2: Run with Docker

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/home-assistant-google-sync.git
   cd home-assistant-google-sync
   ```

2. Create a `.env` file with your configuration (as shown above)

3. Build and run the Docker container:
   ```
   docker build -t google-keep-ha-sync .
   docker run -d --name google-keep-ha-sync --restart unless-stopped --env-file .env google-keep-ha-sync
   ```

   Or use the provided Makefile:
   ```
   # Build the Docker image
   make build

   # Run the container
   make run

   # View logs
   make logs

   # Stop the container
   make stop

   # Restart the container
   make restart
   ```

### Option 3: Run as a Home Assistant Add-on

1. Copy the `home-assistant-google-sync` directory to your Home Assistant's `addons` directory

2. In the Home Assistant UI, go to Settings → Add-ons → Add-on Store → Local Add-ons

3. Install and configure the "Google Keep to HA Shopping List Sync" add-on

4. Start the add-on

## Configuration

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| GOOGLE_EMAIL | Your Google account email | Yes | - |
| GOOGLE_APP_PASSWORD | Master token or Google App Password | Yes | - |
| HA_URL | URL to your Home Assistant instance | Yes | - |
| HA_TOKEN | Long-lived access token for Home Assistant | Yes | - |
| SYNC_INTERVAL | Sync interval in seconds | No | 300 |

**Note about GOOGLE_APP_PASSWORD**: Despite the name, this variable should contain either:
- A master token (recommended, obtained using the method described below)
- A Google App Password (less reliable for Google Keep access)

## Authentication with Google Keep

The Google Keep API requires a master token for authentication. There are two ways to obtain this token:

### Option 1: Using a Master Token (Recommended)

A master token provides more reliable access to Google Keep. To obtain a master token:

1. Run the following Docker command:
   ```bash
   docker run --rm -it --entrypoint /bin/sh python:3 -c 'pip install gpsoauth; python3 -c '\'print(__import__("gpsoauth").exchange_token(input("Email: "), input("OAuth Token: "), input("Android ID: ")))'\'
   ```

2. When prompted:
   - Enter your Google email address
   - Enter your OAuth Token (this is your Google account password or App Password if 2FA is enabled)
   - Enter an Android ID (you can use any random string like `9774d56d682e549c`)

3. The command will output a master token that you should use in your `.env` file as the `GOOGLE_APP_PASSWORD`

#### Alternative OAuth Token Method

If you're experiencing `BadAuthentication` errors when using your password or App Password as the OAuth Token, try this alternative method to obtain an OAuth token:

1. Go to https://accounts.google.com/EmbeddedSetup
2. Log into your Google Account
3. Click on "I agree" when prompted. The page may show a loading screen forever; ignore it and move on to the next step.
4. Obtain the value of the `oauth_token` cookie:
   - In Chrome: Open Developer Tools (F12) → Application tab → Cookies → accounts.google.com → Find the `oauth_token` cookie and copy its value
   - In Firefox: Open Developer Tools (F12) → Storage tab → Cookies → accounts.google.com → Find the `oauth_token` cookie and copy its value
   - In Safari: Preferences → Advanced → Show Develop menu → Develop → Show Web Inspector → Storage → Cookies → Find the `oauth_token` cookie
5. Use this OAuth token value in step 2 above instead of your password or App Password

### Option 2: Using an App Password

If you have 2-factor authentication enabled on your Google account, you can try using an App Password:

1. Go to your [Google Account](https://myaccount.google.com/)
2. Select Security
3. Under "Signing in to Google," select App Passwords (you may need to sign in again)
4. At the bottom, select "Select app" and choose "Other (Custom name)"
5. Enter "Home Assistant Shopping List Sync" and click "Generate"
6. Use the 16-character password that appears (without spaces)

**Important Notes:**
- The master token method (Option 1) is more reliable for Google Keep access
- If you get a "BadAuthentication" error, try obtaining a master token instead of using an App Password
- Make sure 2-Step Verification is enabled on your Google Account to use App Passwords
- App Passwords can only be used with accounts that have 2-Step Verification enabled

## Getting a Home Assistant Long-Lived Access Token

1. In Home Assistant, click on your profile (bottom left)
2. Scroll down to "Long-Lived Access Tokens"
3. Create a new token with a name like "Shopping List Sync"
4. Copy the token immediately (it won't be shown again)

## Troubleshooting

### Authentication Issues
- If you see "BadAuthentication" errors, try using a master token instead of an App Password
- To obtain a master token, follow the instructions in the "Using a Master Token" section above
- If you still get "BadAuthentication" errors, try the "Alternative OAuth Token Method" described above
- The master token is more reliable for Google Keep authentication than an App Password
- If using an App Password, make sure it's entered correctly (16 characters without spaces)
- Verify that 2-Step Verification is enabled on your Google account (required for App Passwords)

### Connection Issues
- Make sure your Home Assistant instance is reachable at the URL you provided
- Verify that your Home Assistant Long-Lived Access Token is valid and not expired
- If using Docker, make sure your `.env` file is properly mounted

### Sync Issues
- The application will look for lists with "shopping" in the title (case insensitive)
- If no shopping list is found, it will create a new one called "Shopping List"
- Verify your Home Assistant instance has the Shopping List integration enabled
- Check the logs for any specific error messages
- If you want to use a specific list, make sure its title starts with "Shopping"

### Environment Variables
- All required environment variables must be set in your `.env` file
- Required variables: `GOOGLE_EMAIL`, `GOOGLE_APP_PASSWORD`, `HA_URL`, `HA_TOKEN`
- Optional variables: `SYNC_INTERVAL` (defaults to 300 seconds)

## License

[MIT License](LICENSE)
