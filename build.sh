#!/bin/bash

cd /workspace/flutter_google_code_login
echo -e "CLIENT_ID=$CLIENT_ID\\nCLIENT_SECRET=$CLIENT_SECRET" > .env
flutter build apk
