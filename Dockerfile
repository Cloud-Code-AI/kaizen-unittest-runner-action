FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3 python3-pip curl

# Copy files if they exist, create them if they don't
COPY requirements.txt /requirements.txt || touch /requirements.txt
COPY pyproject.toml /pyproject.toml || touch /pyproject.toml
COPY package.json /package.json || touch /package.json
COPY entrypoint.sh /entrypoint.sh

# Install latest Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
RUN apt-get install -y nodejs

RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install
RUN pip3 install -r requirements.txt

# Only run npm install if package.json exists and has content
RUN if [ -s /package.json ]; then npm install; fi

# Install kaizen-cli
RUN pip3 install kaizen-cli

ENTRYPOINT ["/entrypoint.sh"]