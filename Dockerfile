FROM ghcr.io/nixos/nix:latest

WORKDIR /app

COPY . .

RUN nix develop --extra-experimental-features 'nix-command flakes' --command sh -c "cd static && make && cd .. && npm install"
