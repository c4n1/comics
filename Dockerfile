FROM alpine
MAINTAINER Tom Grace <tom@deathbycomputers.co.uk>

RUN apk update; apk add bash nginx curl imagemagick
RUN mkdir /run/nginx /root/saved_data /root/images
COPY entrypoint.sh /root
COPY page_make.sh /root
COPY nginx.conf /etc/nginx/
COPY saved_data/* /root/saved_data/

CMD ["/root/entrypoint.sh"]

