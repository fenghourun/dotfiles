#!/bin/bash

apps=()
while IFS="|" read -r app_workspace_id app_name app_details; do
    apps+=("$app_name")

    echo "bonk $app_name bonk"

done < <(aerospace list-windows --workspace "t")



