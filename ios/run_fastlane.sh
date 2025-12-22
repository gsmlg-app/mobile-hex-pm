#!/bin/bash

CI_BUILD_NUMBER=${1:-10} bundle exec fastlane deploy_staging
