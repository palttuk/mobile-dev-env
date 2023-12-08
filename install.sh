#!/bin/sh

if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
	echo "Android SDK is not installed."
	# Add your Android SDK installation command here. For example:
	echo "Installing Java 8..."
	brew install --cask homebrew/cask-versions/temurin8
	echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >> ~/.zshrc

	echo 'export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"' >> ~/.zshrc

	brew install --cask android-sdk
	mv /usr/local/Caskroom/android-sdk ~/Library/Android/sdk
	echo 'export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"' >> ~/.zshrc
	echo 'export ANDROID_HOME="$HOME/Library/Android/sdk"' >> ~/.zshrc
else
	echo "Android SDK is installed."
fi

# Check if Android Studio is installed
if [ ! -d "/Applications/Android Studio.app" ]; then
	echo "Android Studio is not installed."
	# Add your Android Studio installation command here. For example:
	brew install --cask android-studio
	echo "Setting Android Studio path..."
	export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
else
	echo "Android Studio is installed."
fi

if ! command -v asdf &> /dev/null
then
    echo "asdf is not installed. Install it first."
    exit
else 
	# Add Flutter plugin to asdf
	echo "install asdf"
	asdf plugin-add flutter
	# Install a specific version of Flutter
	echo "install latest flutter version"
	asdf install flutter latest
	read flutter_version
	echo "run: asdf install flutter $flutter_version"
	asdf install flutter $flutter_version

	# Set a version as the global version
	echo "Global flutter version is latest!!!"
	asdf global flutter latest
fi

# Check if Xcode is installed
if [ ! -d "/Applications/Xcode.app" ]; then
    echo "Xcode is not installed."
    # Install Xcode
    echo "Installing Xcode..."
    brew install --cask xcode
else
    echo "Xcode is installed."
fi

# 환경 변수 설정을 쉘 설정 파일에 추가
echo 'export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools' >> ~/.zshrc

command asdf exec flutter doctor -v

echo 'export FLUTTER_ROOT="$(asdf where flutter)"' >> ~/.zshrc
echo "Environment setup complete!"
