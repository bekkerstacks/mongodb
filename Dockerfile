FROM alpine

RUN apk --no-cache add mongodb
ADD bootstrap.sh /bekkerstacks/bootstrap.sh
RUN chmod +x /bekkerstacks/bootstrap.sh

CMD ["/bekkerstacks/bootstrap.sh"]
