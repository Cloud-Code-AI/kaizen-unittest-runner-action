FROM ubuntu:latest

# Install necessary tools and Node.js
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv curl && \
    curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up a Python virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Create a directory for our files
WORKDIR /app
# Conditionally copy files if they exist
RUN if [ -f pyproject.toml ]; then cp pyproject.toml /app/; fi
RUN if [ -f requirements.txt ]; then cp requirements.txt /app/; fi
RUN if [ -f package.json ]; then cp package.json /app/; fi
RUN if [ -f package-lock.json ]; then cp package-lock.json /app/; fi

# Install dependencies
RUN pip install --upgrade pip && \
    pip install poetry kaizen-cli && \
    poetry config virtualenvs.create false && \
    if [ -s pyproject.toml ]; then \
        echo "Found pyproject.toml, installing dependencies with Poetry..." && \
        poetry install --no-root; \
    elif [ -s requirements.txt ]; then \
        echo "Found requirements.txt, installing dependencies with pip..." && \
        pip install -r requirements.txt; \
    elif [ -s package-lock.json ]; then \
        echo "Found package-lock.json, installing dependencies with npm ci..." && \
        npm ci; \
    elif [ -s package.json ]; then \
        echo "Found package.json, installing dependencies with npm install..." && \
        npm install; \
    else \
        echo "No recognized dependency files found."; \
    fi

# Copy the rest of the application
COPY . .

# Copy entrypoint script and set permissions
COPY entrypoint.sh .
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]