# APP DOCKERFILE

FROM mcansky/ruby_193_base

# copy deploy.sh in the container
# in bin
ADD deploy.sh /bin/deploy.sh
RUN chmod +x /bin/deploy.sh

RUN deploy.sh app_setup

EXPOSE 8080

CMD    ["/bin/deploy.sh", "app_run"]