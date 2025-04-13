# index.py - Google Keep to Home Assistant Shopping List Sync
import os
import time
import requests
import gkeepapi
from gkeepapi.exception import LoginException
from dotenv import load_dotenv

load_dotenv()

GOOGLE_EMAIL = os.getenv("GOOGLE_EMAIL")
GOOGLE_APP_PASSWORD = os.getenv("GOOGLE_APP_PASSWORD")
HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")
SYNC_INTERVAL = int(os.getenv("SYNC_INTERVAL", 300))  # in seconds

# Check if required environment variables are set
def check_env_vars():
    missing_vars = []
    if not GOOGLE_EMAIL:
        missing_vars.append("GOOGLE_EMAIL")
    if not GOOGLE_APP_PASSWORD:
        missing_vars.append("GOOGLE_APP_PASSWORD")
    if not HA_URL:
        missing_vars.append("HA_URL")
    if not HA_TOKEN:
        missing_vars.append("HA_TOKEN")

    if missing_vars:
        print("Error: The following required environment variables are missing:")
        for var in missing_vars:
            print(f"  - {var}")
        print("\nPlease make sure these are set in your .env file or environment.")
        print("See README.md for configuration instructions.")
        return False
    return True

def sync():
    keep = gkeepapi.Keep()
    try:
        keep.authenticate(GOOGLE_EMAIL, GOOGLE_APP_PASSWORD)
        success = True
    except LoginException as e:
        print(f"Failed to authenticate to Google Keep: {e}")
        print("Please check your Google email and app password.")
        print("For Google accounts with 2FA, make sure you're using an App Password.")
        print("See README.md for instructions on creating an App Password.")
        success = False
    except Exception as e:
        print(f"Unexpected error during Google Keep authentication: {e}")
        success = False

    if not success:
        return

    # Find the shopping list
    shopping = None
    shopping_lists = []

    print("Searching for shopping lists...")

    # First, try to find notes with 'shopping' in the title
    for note in keep.all():
        if 'shopping' in note.title.lower():
            shopping_lists.append(note)
            print(f"Found potential shopping list: '{note.title}'")
            if note.title.lower().startswith('shopping'):
                shopping = note
                print(f"Selected shopping list: '{note.title}'")
                break

    # If we found multiple shopping lists but none that starts with 'shopping',
    # just use the first one
    if not shopping and shopping_lists:
        shopping = shopping_lists[0]
        print(f"Using shopping list: '{shopping.title}'")

    # If no shopping list was found, create one
    if not shopping:
        print("No shopping list found. Creating a new one...")
        try:
            shopping = keep.createList('Shopping List', [])  # Create an empty list
            print("Created new 'Shopping List'")
            keep.sync()  # Sync to save the new list
        except Exception as e:
            print(f"Failed to create shopping list: {e}")
            return

    for item in shopping.items:
        if not item.checked:
            print(f"Migrating: {item.text}")

            # Send to Home Assistant
            try:
                requests.post(
                    f"{HA_URL}/api/services/shopping_list/add_item",
                    json={"name": item.text},
                    headers={"Authorization": f"Bearer {HA_TOKEN}"}
                )

                item.checked = True
            except Exception as e:
                print(f"Failed to add item to HA: {e}")

    keep.sync()

if __name__ == "__main__":
    print("Starting Google Keep -> HA Shopping List sync...")

    # Check environment variables before starting
    if not check_env_vars():
        import sys
        sys.exit(1)

    while True:
        try:
            sync()
            time.sleep(SYNC_INTERVAL)
        except KeyboardInterrupt:
            print("\nSync process terminated by user.")
            break
        except Exception as e:
            print(f"Unexpected error: {e}")
            time.sleep(SYNC_INTERVAL)
