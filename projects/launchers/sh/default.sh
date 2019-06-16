#!/bin/bash -eu

export MACHINE_CONFIG_PATH='./projects/machines/default/MachineConfig.yml'
export PLATFORM_CONFIG_PATH='./projects/platforms/default/PlatformConfig.yml'

vagrant $*
