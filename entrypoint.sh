#!/bin/bash

set -e

# Run Python tests using kaizen-cli
echo "Running Python tests..."
kaizen-cli run tests .kaizen/unittests

# Run JavaScript/TypeScript tests
echo "Running JavaScript/TypeScript tests..."
if [ -f "package.json" ]; then
    npm test
else
    echo "No package.json found."
fi

# Run React tests
echo "Running React tests..."
if [ -f "package.json" ] && grep -q "react-scripts" "package.json"; then
    npm run test
else
    echo "No React project detected."
fi