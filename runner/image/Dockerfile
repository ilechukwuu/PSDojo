ARG BASE_IMAGE=mcr.microsoft.com/powershell:7.4-ubuntu-22.04
FROM ${BASE_IMAGE}

ENV POWERSHELL_TELEMETRY_OPTOUT=1 \
    POWERSHELL_UPDATECHECK=Off \
    DOTNET_CLI_TELEMETRY_OPTOUT=1

COPY _modules/ /usr/local/share/powershell/Modules/
COPY check.ps1 /opt/psdojo/check.ps1

RUN groupadd --gid 10001 learner \
    && useradd --uid 10001 --gid 10001 --no-create-home --home-dir /work --shell /usr/sbin/nologin learner \
    && chmod -R a+rX /usr/local/share/powershell/Modules /opt/psdojo

USER 10001:10001
WORKDIR /work
