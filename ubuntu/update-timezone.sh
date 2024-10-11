#!/bin/bash

timedatectl set-timezone $(curl https://ipinfo.io | jq -r '.timezone')
