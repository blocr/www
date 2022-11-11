FROM pandoc/core as build

RUN apk --no-cache add build-base rsync

WORKDIR /app
COPY . /app

RUN make

FROM nginx
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/public /usr/share/nginx/html

EXPOSE 80
