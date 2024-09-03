#!/bin/bash

set -e

# Activate virtual environment
source /opt/venv/bin/activate

# Run Python tests using kaizen-cli
echo "Running Python tests..."
kaizen-cli unit-test run-tests

# Add a step to log the error of log run to our server


# Run JavaScript/TypeScript tests only if package.json has content
# if [ -s package.json ]; then
#     echo "Running JavaScript/TypeScript tests..."
#     if [ ! -f package-lock.json ]; then
#         npm install --package-lock-only
#     fi
#     npm ci
#     npm test
# else
#     echo "No package.json found or it's empty. Skipping JavaScript/TypeScript tests."
# fi

# # Run React tests only if package.json has content and includes react-scripts
# if [ -s package.json ] && grep -q "react-scripts" "package.json"; then
#     echo "Running React tests..."
#     if [ ! -f package-lock.json ]; then
#         npm install --package-lock-only
#     fi
#     npm ci
#     npm run test
# else
#     echo "No React project detected or package.json is missing/empty. Skipping React tests."
# fi