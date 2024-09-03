FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv curl

# Create a directory for our files
WORKDIR /app

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

# Install Python dependencies and tools
RUN pip install --upgrade pip && \
    pip install poetry && \
    poetry config virtualenvs.create false

# Install kaizen-cli
RUN pip install kaizen-cli

# Copy your application files
COPY . .

# Install dependencies based on available files
RUN if [ -f requirements.txt ]; then \
        pip install -r requirements.txt; \
    elif [ -f pyproject.toml ]; then \
        poetry install --no-dev; \
    elif [ -f package.json ]; then \
        npm ci; \
    else \
        echo "No recognized dependency file found. Skipping dependency installation."; \
    fi

ENTRYPOINT ["/app/entrypoint.sh"]