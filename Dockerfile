FROM frolvlad/alpine-glibc

# Install other packages
RUN apk add --no-cache \
  openjdk8 \
  openssh-client \
  unzip \
  wget \
  zip \
  git \
  bash \
  bash-doc \
  bash-completion \
  && apk add -it busybox /bin/sh

RUN mkdir -p /usr/local/android-sdk \
 && cd /usr/local/android-sdk \
 && wget -q $(wget -q -O- 'https://developer.android.com/sdk' | \
    grep -o "\"https://.*android.*tools.*linux.*\"" | sed "s/\"//g") \
 && unzip *tools*linux*.zip > /dev/null \
 && rm *tools*linux*.zip

RUN curl -fL https://getcli.jfrog.io | sh

ENV ANDROID_HOME /usr/local/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH ${INFER_HOME}/bin:${PATH}
ENV PATH $PATH:$ANDROID_SDK_HOME/tools/bin
ENV PATH $PATH:$ANDROID_NDK_HOME
ENV PATH $PATH:~/opt/bin

# Install bash and add to path
# RUN apk add --no-cache bash

# accept the license agreements of the SDK components
RUN export ANDROID_LICENSES="$ANDROID_HOME/licenses" && \
    [ -d $ANDROID_LICENSES ] || mkdir $ANDROID_LICENSES && \
    [ -f $ANDROID_LICENSES/android-sdk-license ] || echo 8933bad161af4178b1185d1a37fbf41ea5269c55\\nd56f5187479451eabf01fb78af6dfcb131a6481e > $ANDROID_LICENSES/android-sdk-license && \
    [ -f $ANDROID_LICENSES/android-sdk-preview-license ] || echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_LICENSES/android-sdk-preview-license && \
    [ -f $ANDROID_LICENSES/intel-android-extra-license ] || echo d975f751698a77b662f1254ddbeed3901e976f5a > $ANDROID_LICENSES/intel-android-extra-license && \
    unset ANDROID_LICENSES

RUN sdkmanager --update && touch /usr/local/android-sdk/.android/repositories.cfg && \
sdkmanager \
  "build-tools;27.0.3" \
  "ndk-bundle" \
  "platform-tools" \
  "platforms;android-27" > /dev/null

#accepting licenses
RUN yes | sdkmanager --licenses

WORKDIR /

RUN echo "sdk.dir=$ANDROID_HOME" > local.properties
