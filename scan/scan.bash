#!/bin/bash

# Update the git submodule(s) containing wpscan (and potentially other/future projects) so that we always run the latest version
cd "$(dirname $0)/.."
git submodule foreach git pull origin master

# wpscan requires it's dependencies to be in PATH, easiest to just cd to folder
cd "scan/wpscan"
# Set wpscan script and sites to scan
wpscan=./wpscan.rb
sites=$(ls /etc/nginx/sites-enabled)
# Update the database with vulnerabilities.
$wpscan --update

for site in $sites
do
	echo ""
	echo "------------"
	echo "Scanning site $site for vulnerabilities using wpscan..."
	$wpscan -u $site --follow-redirection -e u,vt,vp
	echo "------------"
done

