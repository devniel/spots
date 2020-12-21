FROM node:12 AS spots-base
WORKDIR /app
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn build

FROM nginx:alpine AS spots-ui
COPY nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/nginx/html
COPY --from=spots-base /app/dist/apps/spots .

FROM node:12 AS spots-api
EXPOSE 3333
WORKDIR /app
COPY --from=spots-base /app/node_modules /app/node_modules
COPY --from=spots-base /app/dist/apps/api .
CMD ["node", "main.js"]