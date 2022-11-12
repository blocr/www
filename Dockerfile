FROM pandoc/core as build

RUN apk --no-cache add build-base coreutils

WORKDIR /app
COPY . /app

RUN make

FROM busybox

COPY ./httpd.conf /etc
COPY --from=build /app/public /srv/www

# Run BusyBox httpd
CMD ["busybox", "httpd", "-f", "-v", "-p", "8080"]
