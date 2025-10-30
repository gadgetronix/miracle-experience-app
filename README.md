# miracle_experience_mobile_app

A new Flutter project.

FLUTTER VERSION USED FOR THIS PROJECT IS 3.35.4

1. To generate splash for this project; make required changes in native_splash.yaml and run below command

2. --flavor=stable --release-version=0.1.0+1                              shorebird release android --flavor beta --flutter-version=3.35.4 --artifact=apk

3. shorebird patch android --flavor beta

dart run flutter_native_splash:create --path=native_splash.yaml