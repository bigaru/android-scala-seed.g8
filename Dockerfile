FROM	openjdk:8-jdk-alpine

ENV	GLIBC 2.25-r0

ENV	ANDROID_BUILD_TOOLS 28.0.0
ENV	ANDROID_PLATFORM 28
ENV	ANDROID_SDK 6200805

ENV	SBT_VERSION 0.13.17
ENV	SBT_HOME /usr/local/sbt


RUN	apk update && \
	apk add --no-cache ca-certificates wget bash git && \
	update-ca-certificates

# Install glibc for Android SDK
RUN	wget -q https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub && \
	wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk -O /tmp/glibc.apk && \
	wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-bin-$GLIBC.apk -O /tmp/glibc-bin.apk && \
	apk add --no-cache /tmp/glibc.apk /tmp/glibc-bin.apk && \
	rm /tmp/glibc.apk /tmp/glibc-bin.apk /etc/apk/keys/sgerrand.rsa.pub

# Install SBT
RUN	wget -q https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz -O /tmp/sbt.tgz && \
	mkdir -p $SBT_HOME && \
	tar xvfz /tmp/sbt.tgz -C $SBT_HOME --strip-components=1 && \
	ln -s $SBT_HOME/bin/sbt /bin/sbt
	
ENV 	PATH $PATH:$SBT_HOME/bin

RUN 	sbt sbtVersion

# Install Android SDK
RUN	mkdir /android-sdk && \
	wget -q -O /android-sdk/android-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK}_latest.zip && \
	cd /android-sdk && \
	unzip -q ./android-tools.zip && \
	rm /android-sdk/android-tools.zip

ENV	ANDROID_HOME /android-sdk/
ENV	PATH $PATH:$ANDROID_HOME/tools/:$ANDROID_HOME/platform-tools/


# Install major Android SDK components (tools/bin/sdkmanager --list)
RUN	yes | /android-sdk/tools/bin/sdkmanager --sdk_root=$ANDROID_HOME \
	       "platform-tools" \
	       "tools" \
	       "build-tools;$ANDROID_BUILD_TOOLS" \
	       "platforms;android-$ANDROID_PLATFORM" 
#	       "extras;android;m2repository" 
#	       "extras;google;m2repository"

	       
ENTRYPOINT ["/bin/bash", "-l", "-c"]
