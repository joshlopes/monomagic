#!/bin/bash
# Script to set up a local Python environment for the Google Keep to HA sync project

# Create a virtual environment
echo "Creating Python virtual environment..."
python3 -m venv venv

# Activate the virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Verify installation
echo "Verifying installation..."
pip list

echo ""
echo "Setup complete! To activate the environment in the future, run:"
echo "source venv/bin/activate"
echo ""
echo "To run the application:"
echo "python index.py"
echo ""
echo "To deactivate the virtual environment when done:"
echo "deactivate"
