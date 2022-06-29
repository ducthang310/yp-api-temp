FROM node:16.14.2-alpine as builder
RUN apk update && apk add python3 make g++ && rm -rf /var/cache/apk/*
RUN mkdir /app/
WORKDIR /app/
RUN chown -R 1000:1000 /app/
USER 1000
COPY package*.json /app/
RUN yarn install
COPY --chown=1000:1000 . /app/
ENV NODE_ENV=production
RUN yarn build

FROM node:16.14.2-alpine
RUN mkdir /app/
WORKDIR /app/
RUN chown -R 1000:1000 /app/
USER 1000
COPY --from=builder /app/ ./
ENV NODE_ENV=production
ENV PORT 3000
EXPOSE $PORT
CMD ["yarn", "start"]
