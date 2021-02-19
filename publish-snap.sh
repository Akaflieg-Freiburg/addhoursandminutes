#!/bin/bash

snapcraft clean
snapcraft
snapcraft login --with ~/.ubuntuLogin
snapcraft upload add-hours-and-minutes_?.?.?_amd64.snap --release stable
