FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet build --configuration Release

FROM build AS test-runner
ENV DOCKER_URL=https://download.docker.com/linux/static/stable/x86_64
ENV DOCKER_VERSION=25.0.3
RUN curl -fsSL $DOCKER_URL/docker-$DOCKER_VERSION.tgz | \
	tar zxvf - --strip 1 -C /usr/bin docker/docker

FROM build AS publish
RUN dotnet publish Cicd.App/Cicd.App.csproj --configuration Release --no-build --output publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 as runtime
WORKDIR /app
COPY --from=publish /src/publish .
ENTRYPOINT ["dotnet", "Cicd.App.dll"]
EXPOSE 8080
