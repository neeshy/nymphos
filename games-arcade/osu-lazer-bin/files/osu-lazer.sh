#!/bin/sh
DOTNET_CLI_TELEMETRY_OPTOUT="1" OSU_EXTERNAL_UPDATE_PROVIDER="1" exec /opt/osu-lazer/osu.AppImage "$@"
