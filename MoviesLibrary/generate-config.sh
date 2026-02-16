#!/bin/bash

# Script to generate Config.swift from .env file
# This script should be run as a Build Phase in Xcode

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define paths - look for .env in parent directory if using Xcode structure
if [ -n "$SRCROOT" ]; then
    # Running from Xcode build phase
    PROJECT_DIR="$SRCROOT"
    ENV_FILE="$SRCROOT/../.env"
    OUTPUT_FILE="$SRCROOT/Config.swift"
else
    # Running manually - check parent directory for .env
    if [ -f "$SCRIPT_DIR/../.env" ]; then
        ENV_FILE="$SCRIPT_DIR/../.env"
    else
        ENV_FILE="$SCRIPT_DIR/.env"
    fi
    OUTPUT_FILE="$SCRIPT_DIR/Config.swift"
fi

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "error: .env file not found at ${ENV_FILE}"
    echo "error: Please create a .env file with your TMDB_API_KEY"
    echo "error: See .env.example for reference"
    exit 1
fi

# Read API key from .env file
API_KEY=$(grep "^TMDB_API_KEY=" "$ENV_FILE" | cut -d '=' -f2 | tr -d ' \n\r')

# Validate API key
if [ -z "$API_KEY" ] || [ "$API_KEY" = "YOUR_API_KEY_HERE" ] || [ "$API_KEY" = "your_api_key_here" ]; then
    echo "error: TMDB_API_KEY is not set in .env file"
    echo "error: Please add your actual API key from https://www.themoviedb.org/settings/api"
    exit 1
fi

# Generate Config.swift
cat > "$OUTPUT_FILE" << EOF
//
//  Config.swift
//  MoviesLibrary
//
//  Configuration file for API keys and endpoints
//  This file is auto-generated from .env - DO NOT EDIT MANUALLY
//

import Foundation

enum Config {
    // API Key loaded from .env file
    static let tmdbAPIKey = "${API_KEY}"
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p"
}
EOF

echo "Config.swift generated successfully with API key from .env"
