#!/bin/bash

#common
tmux new-session -t common_dotfiles -d
tmux new-session -t common_notes -d

# work
tmux new-session -t work_bpa_master_data_api_feature_1 -d
tmux new-session -t work_bpa_master_data_api_dev -d
tmux new-session -t work_bpa_master_data_api_test -d
tmux new-session -t work_bpa_master_data_api_staging -d
tmux new-session -t work_bpa_master_data_fe_local -d
tmux new-session -t work_bpa_master_data_fe_feature_1 -d
tmux new-session -t work_bpa_master_data_fe_dev -d
tmux new-session -t work_bpa_master_data_fe_test -d
tmux new-session -t work_bpa_master_data_fe_staging -d
tmux new-session -t work_bpa_btp_build_image -d
tmux new-session -t work_bpa_bpa_dev_tools -d
tmux new-session -t work_bpa_bpa_testing -d

# personal
tmux new-session -t personal_foo -d
tmux new-session -t personal_mini_shop -d
tmux new-session -t personal_mini_shop_client -d
tmux new-session -t personal_api_gateway -d
tmux new-session -t personal_go_calc -d
tmux new-session -t personal_flink -d
