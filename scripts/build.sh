#!/bin/bash

echo "[M] Memora Web"

domainName=${WEB_DOMAIN_NAME:-127.0.0.1}
echo "[M] Building Memora Web for Domain Name: [$domainName]"

echo "[M] Updating Flutter SDK ..."
flutter upgrade
flutter pub upgrade

echo "[M] Cleaning Flutter build ..."
flutter clean

echo "[M] Building Flutter web ..."
flutter build web --release

if [[ $? -ne 0 ]]; then
  echo "[M] Flutter build failed!"
  exit 1
fi
echo "[M] Flutter build completed successfully!"
echo "[M] Copying web build to memora/src/main/resources/web ..."

rm -rf ../memora/src/main/resources/web
cp -r build/web ../memora/src/main/resources/web

echo "[M] Web build completed and copied to memora/src/main/resources/web"
echo "[M] Building Memora Web completed successfully!"