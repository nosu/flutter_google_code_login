#!/bin/bash

cd /workspace/flutter_google_code_login
echo -e "CLIENT_ID=$_CLIENT_ID\\nCLIENT_SECRET=$_CLIENT_SECRET" > .env
flutter build apk
