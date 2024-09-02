FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3 python3-pip curl
COPY requirements.txt /requirements.txt
COPY pyproject.toml /pyproject.toml
COPY package.json /package.json
COPY entrypoint.sh /entrypoint.sh

# Install latest Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
RUN apt-get install -y nodejs

RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install
RUN pip3 install -r requirements.txt
RUN npm install

# Install kaizen-cli
RUN pip3 install kaizen-cli

ENTRYPOINT ["/entrypoint.sh"]