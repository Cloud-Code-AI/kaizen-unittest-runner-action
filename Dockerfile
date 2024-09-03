FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl

# Create a directory for our files
RUN mkdir /app
WORKDIR /app

# Copy files if they exist, otherwise create empty ones
COPY requirements.txt pyproject.toml package.json ./
RUN for file in requirements.txt pyproject.toml package.json; do \
    if [ ! -f "$file" ]; then \
        echo "Creating empty $file"; \
        touch "$file"; \
    fi \
done

# Copy entrypoint script
COPY entrypoint.sh .

# Install latest Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs

# Install Python dependencies
RUN pip3 install poetry && \
    poetry config virtualenvs.create false && \
    poetry install && \
    pip3 install -r requirements.txt

# Install Node.js dependencies if package.json exists and has content
RUN if [ -s package.json ]; then npm install; fi

# Install kaizen-cli
RUN pip3 install kaizen-cli

ENTRYPOINT ["./entrypoint.sh"]