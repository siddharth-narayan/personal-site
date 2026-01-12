

# Usage
Edit any typst within ```static/source``` to your liking. This folder will have each typst file contained within it compiled and its result moved to the corresponding location in ```static/build``` but you may import typst files outside as well. 

### Manual
Make sure you have nodejs installed, then run the following commands:
```bash
git clone https://siddharth-narayan/personal-site
cd personal-site
npm run build
node build
```

### Docker

Clone the repo: ```git clone https://github.com/siddharth-narayan/personal-site```

Add a docker-compose.yml like this, and add any volumes you want

```yaml
version: '3.8'
name: personal-site
services:
  personal-site:
    image: ghcr.io/siddharth-narayan/personal-site:latest
    restart: unless-stopped
    ports:
      - "7000:3000"
    # volumes:
    #   - /storage/docker-state/jellyfin-stack/media/jellyfin-media/Photos/:/usr/src/app/static/assets/images
```

And then simply ```docker-compose up```