#!/bin/bash

# Open source JUCE project does not incldue prebuilt Projucer tool that is
# essential to create JUCE projects. We can build it from source. This
# will Build, Copy and Clean Projucer.app to third_party/juce/ directory

set -evx

XCODEBUILD="/usr/bin/xcodebuild"
PROJUCER_PROJECT_PATH=third_party/juce/extras/Projucer/Builds/MacOSX
PROJUCER_OUTPUT_PATH=third_party/juce/Projucer.app/

# Build Projucer
pushd $PROJUCER_PROJECT_PATH
xcodebuild
popd

# Copy Projucer.app to third_party/juce/
cp -R $PROJUCER_PROJECT_PATH/build/Debug/Projucer.app/ "$PROJUCER_OUTPUT_PATH"

# Clean Projucer project
pushd $PROJUCER_PROJECT_PATH
xcodebuild clean
popd
