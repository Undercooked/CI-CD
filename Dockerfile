FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . /src
RUN dotnet build -c Release

FROM build AS test
RUN dotnet test -c Release --no-build --logger trx

FROM scratch as test-results
COPY --from=test /app/TestResults/*.trx .

FROM build AS publish
RUN dotnet publish Cicd.App/Cicd.App.csproj -c Release --no-build -o publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=publish /src/publish .
ENTRYPOINT ["dotnet", "Cicd.App.dll"]

EXPOSE 8080