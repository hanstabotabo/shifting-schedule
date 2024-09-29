FROM centos:latest

WORKDIR /app

COPY shift_sched.sh /app/

RUN chmod +x /app/shift_sched.sh

ENTRYPOINT ["/bin/bash"]

CMD ["./shift_sched.sh"]
