# Local Development Guide

This guide explains how to set up and run the Google Keep to Home Assistant Shopping List Sync application in a local Python environment.

## Prerequisites

- Python 3.11 or higher
- pip (Python package installer)
- A `.env` file with your configuration (see main README.md)

## Setting Up the Local Environment

### Option 1: Using Make (Recommended)

If you have `make` installed, you can use the provided Makefile targets:

1. Set up the local environment:
   ```
   make setup-local
   ```

2. Run the application:
   ```
   make run-local
   ```

### Option 2: Manual Setup

If you don't have `make` or prefer to run commands manually:

1. Create a virtual environment:
   ```
   python3 -m venv venv
   ```

2. Activate the virtual environment:
   - On macOS/Linux:
     ```
     source venv/bin/activate
     ```
   - On Windows:
     ```
     venv\Scripts\activate
     ```

3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

4. Run the application:
   ```
   python index.py
   ```

5. When you're done, deactivate the virtual environment:
   ```
   deactivate
   ```

## Debugging

Running the application locally makes it easier to debug issues:

1. You can add print statements to the code for debugging
2. You can use a Python debugger like pdb or an IDE debugger
3. You can see all output directly in your terminal

## Common Issues

### Environment Variables

Make sure your `.env` file is in the project root directory and contains all required variables:

```
GOOGLE_EMAIL=your@email.com
GOOGLE_APP_PASSWORD=your_app_password
HA_URL=http://homeassistant.local:8123
HA_TOKEN=your_long_lived_token
SYNC_INTERVAL=300
```

### Authentication Issues

If you encounter authentication issues:

1. Verify your Google email and App Password are correct
2. Make sure you're using an App Password if your account has 2FA enabled
3. Check that your Home Assistant URL and token are valid

### Dependency Issues

If you encounter issues with dependencies:

1. Make sure your virtual environment is activated
2. Try updating pip: `pip install --upgrade pip`
3. Reinstall dependencies: `pip install -r requirements.txt`

## Development Workflow

1. Activate the virtual environment
2. Make changes to the code
3. Run the application to test your changes
4. Repeat as needed

When you're satisfied with your changes, you can build and run the Docker container to verify everything works in the containerized environment.
