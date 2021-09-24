FROM node:14 AS builder

WORKDIR /app

COPY package*.json /app/

RUN npm install

COPY . ./

RUN npm run build


FROM nginx:alpine

COPY --from=builder app/build/ /usr/share/nginx/html/

COPY ./nginx.conf /etc/nginx/nginx.template

RUN curl -L https://github.com/a8m/envsubst/releases/download/v1.1.0/envsubst-`uname -s`-`uname -m` -o envsubst && \
    chmod +x envsubst && \
    mv envsubst /usr/local/bin
    
CMD ["/bin/sh", "-c", "envsubst < /etc/nginx/nginx.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]

