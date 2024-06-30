#!/bin/sh

nvidia-smi --query-gpu=utilization.gpu,utilization.memory --format=csv,noheader,nounits | awk '{ printf("GPU %02d%% %02d%%",""$1"",""$2"") }' | sed 's/,//g'
