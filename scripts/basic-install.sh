#!/bin/bash

clear

read -p "Please enter an username: " username
echo "Making the user: $username"
adduser $username
