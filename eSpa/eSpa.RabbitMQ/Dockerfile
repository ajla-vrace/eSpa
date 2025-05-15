#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["eSpa.RabbitMQ.csproj", "eSpa.RabbitMQ/"]
RUN dotnet restore "eSpa.RabbitMQ/eSpa.RabbitMQ.csproj"

WORKDIR "/src/eSpa.RabbitMQ"
COPY . .

RUN dotnet build "eSpa.RabbitMQ.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "eSpa.RabbitMQ.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "eSpa.RabbitMQ.dll"]