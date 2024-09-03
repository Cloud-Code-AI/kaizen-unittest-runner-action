FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl

# Create a directory for our files
WORKDIR /app

# Create empty files (they will be overwritten if they exist in the context)
RUN touch requirements.txt pyproject.toml package.json

# Copy entrypoint script
COPY entrypoint.sh .

# Install latest Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs

# Install Python dependencies
RUN pip3 install poetry && \
    poetry config virtualenvs.create false

# Install Node.js dependencies if package.json has content
RUN if [ -s package.json ]; then npm install; fi

# Install kaizen-cli
RUN pip3 install kaizen-cli

# Ensure entrypoint script is executable
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]