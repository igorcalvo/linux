#!/bin/sh
# nvv=$(nvidia-smi --query-gpu=utilization.gpu,utilization.memory --format=csv,noheader,nounits | awk '{ printf("GPU Z %02d%% %02d%% Y",""$1"",""$2"") }' | sed 's/,//g')
# nvv2=$(echo $nvv | sed 's/Z/%{F$fg_color}/' | sed 's/Y/ %{F-} /')
# echo $nvv2
nvidia-smi --query-gpu=utilization.gpu,utilization.memory --format=csv,noheader,nounits | awk '{ printf("GPU %02d%% %02d%%",""$1"",""$2"") }' | sed 's/,//g'
