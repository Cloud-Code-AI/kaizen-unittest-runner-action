FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv curl

# Create a directory for our files
WORKDIR /app

# Create empty files (they will be overwritten if they exist in the context)
RUN touch requirements.txt pyproject.toml package.json

# Copy entrypoint script and set permissions
COPY entrypoint.sh .
RUN chmod +x /app/entrypoint.sh

# Install latest Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs

# Set up a Python virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install poetry && \
    poetry config virtualenvs.create false

# Generate package-lock.json if package.json exists and has content, then use npm ci
RUN if [ -s package.json ]; then \
        npm install --package-lock-only && \
        npm ci; \
    fi

# Install kaizen-cli
RUN pip install kaizen-cli

ENTRYPOINT ["/app/entrypoint.sh"]