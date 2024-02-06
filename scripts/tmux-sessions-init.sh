#!/bin/bash

#common
tmux new-session -t common_dotfiles -d -c "$COMMON/.dotfiles"
tmux new-session -t common_notes -d -c "$COMMON/notes"
tmux new-session -t common_ledger -d -c "$COMMON/ledger"

# work
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

# personal
tmux new-session -t personal_foo -d -c "$PERSONAL/foo"
tmux new-session -t personal_mini_shop -d -c "$PERSONAL/mini-shop"
tmux new-session -t personal_mini_shop_client -d -c "$PERSONAL/mini-shop-client"
tmux new-session -t personal_api_gateway -d -c "$PERSONAL/api-gateway"
tmux new-session -t personal_go_calc -d -c "$PERSONAL/go-calc"
tmux new-session -t personal_flink -d -c "$PERSONAL/flink"
