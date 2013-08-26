# RUBY 193 dockerfile

FROM ubuntu

# copy deploy.sh in the container
# in bin
ADD deploy.sh /bin/deploy.sh
RUN chmod +x /bin/deploy.sh

RUN deploy.sh system_setup
RUN deploy.sh rbenv_setup
RUN deploy.sh profile_setup
RUN deploy.sh ruby_build

EXPOSE 8080
