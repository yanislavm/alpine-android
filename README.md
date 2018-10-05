# Docker Image for Android Builds on CI
This is a very small as a size image that has everything needed in order to build your android applications on CI like bitbucket.<br>

# Integration

## Bitbucket

```
image: yanislavm/alpine-android

pipelines:
  default:
    - step:
        script:
          - git submodule update --init --recursive
          - bash ./gradlew assembleDebug
        artifacts:
          - app/build/outputs/apk/**.apk
```
