FROM node:11 as base

# Create app directory
RUN mkdir -p /opt/app
WORKDIR /opt/app

# Install app dependencies
COPY ./package.json package-lock.json ./
RUN npm ci

# Bundle frontend
COPY src ./src
COPY assets ./assets
COPY config ./config
RUN npm run build


#####################
# Final image
#####################

FROM node:11-alpine
ENV NODE_ENV=prod

MAINTAINER cracker0dks

# Create app directory
RUN mkdir -p /opt/app
WORKDIR /opt/app

COPY ./package.json ./package-lock.json ./
RUN npm ci --only=prod

COPY scripts ./scripts
COPY --from=base /opt/app/public ./public

EXPOSE 8080
ENTRYPOINT [ "npm", "run", "start:prod-no-build" ]
