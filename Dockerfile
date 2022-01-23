FROM mcr.microsoft.com/dotnet/sdk:2.1.816-stretch AS build-env
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o output

# build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:2.1.28-stretch-slim
WORKDIR /app
COPY --from=build-env /app/output .
ENTRYPOINT ["dotnet", "LetsKube.dll"]
