#!/bin/bash

tmux new-session -t work_bpa_master_data_api_feature_1 -d -c "$BPA/master-data-api"
tmux new-session -t work_bpa_master_data_api_dev -d -c "$BPA/master-data-api"
tmux new-session -t work_bpa_master_data_api_test -d -c "$BPA/master-data-api"
tmux new-session -t work_bpa_master_data_api_staging -d -c "$BPA/master-data-api"

tmux new-session -t work_bpa_master_data_fe_local -d -c "$BPA/master-data-fe"
tmux new-session -t work_bpa_master_data_fe_feature_1 -d -c "$BPA/master-data-fe"
tmux new-session -t work_bpa_master_data_fe_dev -d -c "$BPA/master-data-fe"
tmux new-session -t work_bpa_master_data_fe_test -d -c "$BPA/master-data-fe"
tmux new-session -t work_bpa_master_data_fe_staging -d -c "$BPA/master-data-fe"

tmux new-session -t work_bpa_btp_build_image -d -c "$BPA/btp_build_image"
tmux new-session -t work_bpa_bpa_dev_tools -d -c "$BPA/bpa-dev-tools"
tmux new-session -t work_bpa_bpa_testing -d -c "$BPA/bpa-testing"
