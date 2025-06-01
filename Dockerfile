# build ===================================== #
FROM node:20-alpine3.19 AS build
WORKDIR /app

COPY package*.json .
RUN npm ci

COPY . .
RUN npm run build

# prod ====================================== #
FROM nginx:1.25.4-alpine AS prod
RUN apk update && apk upgrade --no-cache

COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK CMD wget --no-verbose --spider http://localhost || exit 1

CMD ["nginx", "-g", "daemon off;"]
