FROM registry.ci.openshift.org/openshift/release:golang-1.13
WORKDIR /go/src/github.com/weshayutin/ci-search
COPY . .
RUN make build

FROM centos:7
COPY --from=0 /go/src/github.com/weshayutin/ci-search/search /usr/bin/
RUN curl -L https://github.com/BurntSushi/ripgrep/releases/download/12.0.1/ripgrep-12.0.1-x86_64-unknown-linux-musl.tar.gz | \
    tar xvzf - --wildcards --no-same-owner --strip-components=1  -C /usr/bin '*/rg'
RUN mkdir /var/lib/ci-search && chown 1000:1000 /var/lib/ci-search && chmod 1777 /var/lib/ci-search
USER 1000:1000
ENTRYPOINT ["search"]

CMD ["--path=/var/lib/ci-search/", "--deck-uri=https://prow.ci.openshift.org", "--v=7"]
EXPOSE 8080
