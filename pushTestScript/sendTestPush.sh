echo "registering variables"

TEAM_ID=XG4TSA83W3
TOKEN_KEY_FILE_NAME=/Users/astrakh/Desktop/AuthKey_68787X38G7.p8
AUTH_KEY_ID=68787X38G7
TOPIC=com.test.PushNotificationsSample
DEVICE_TOKEN=6a8b19bc68e8819f43a025753025dc1b3b597755d471f11a9e7dc9f473161e4a
APNS_HOST_NAME=api.sandbox.push.apple.com
PUSH_PAYLOAD='{"aps":{"alert":"test5"}}'

echo "building JWT"

JWT_ISSUE_TIME=$(date +%s)
JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

echo "authorization: bearer $AUTHENTICATION_TOKEN"

#curl -v --header "apns-topic: com.test.PushNotificationsSample" --header "apns-push-type: alert" --header "authorization: bearer eyAiYWxnIjogIkVTMjU2IiwgImtpZCI6ICI2ODc4N1gzOEc3IiB9.eyAiaXNzIjogIlhHNFRTQTgzVzMiLCAiaWF0IjogMTY1NTQwMzE1OCB9.MEQCIByKpnKbe63tQmrrj0HpBYVC0hBeF_lYetTC5myEq4vTAiBEx7C-Nkt_DePYukrKoaTwNHSjo4yTZVGgA87R5feBaA" --data '{"aps":{"alert":"test3"}}' --http2 https://api.sandbox.push.apple.com/3/device/6a8b19bc68e8819f43a025753025dc1b3b597755d471f11a9e7dc9f473161e4a
curl -v --header "apns-topic: $TOPIC" --header "apns-push-type: alert" --header "authorization: bearer ${AUTHENTICATION_TOKEN}" --data ${PUSH_PAYLOAD} --http2 https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN}

echo "Sent script completed."