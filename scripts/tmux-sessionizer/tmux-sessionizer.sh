#!/bin/bash

pre_attach_action() {
	local cmd=''

	if [[ "$1" == "common_dotfiles" ]]; then
		cmd="cd '$COMMON/.dotfiles/' \
        && clear"
	elif [[ "$1" == "common_notes" ]]; then
		cmd="cd '$COMMON/notes/' \
        && clear"
	elif [[ "$1" == "common_ledger" ]]; then
		cmd="cd '$COMMON/ledger/' \
        && clear"
	elif [[ "$1" == "work_bpa_master_data_api_feature_1" ]]; then
		cmd="cd '$BPA/master-data-api' \
        && git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 \
        && git checkout feature-1 -- src/main/resources/application-local.properties > /dev/null 2>&1 \
        && clear"
	elif [[ "$1" == "work_bpa_master_data_api_dev" ]]; then
		cmd="cd '$BPA/master-data-api' \
        && git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 \
        && git checkout develop -- src/main/resources/application-local.properties > /dev/null 2>&1 \
        && clear"
	elif [[ "$1" == "work_bpa_master_data_api_test" ]]; then
		cmd="cd '$BPA/master-data-api' \
        && git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 \
        && git checkout test -- src/main/resources/application-local.properties > /dev/null 2>&1 \
        && clear"
	elif [[ "$1" == "work_bpa_master_data_api_staging" ]]; then
		cmd="cd '$BPA/master-data-api' \
        && git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 \
        && git checkout staging -- src/main/resources/application-local.properties > /dev/null 2>&1 \
        && clear"
		# issue with fe
	elif [[ "$1" == "work_bpa_master_data_fe_local" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout local -- BTP_FE/src/emvironments/environment.ts > /dev/null 2>&1 \
        && clear"
	elif [[ "$1" == "work_bpa_master_data_fe_feature_1" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout feature-1 -- BTP_FE/src/emvironments/environment.ts > /dev/null 2>&1 \
        && clear"
	elif [[ "$1" == "work_bpa_master_data_fe_dev" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout develop -- BTP_FE/src/emvironments/environment.ts > /dev/null 2>&1 \
        && clear"
	elif [[ "$1" == "work_bpa_master_data_fe_test" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout test -- BTP_FE/src/emvironments/environment.ts > /dev/null 2>&1 \
        && clear"
	elif [[ "$1" == "work_bpa_master_data_fe_staging" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout staging -- BTP_FE/src/emvironments/environment.ts > /dev/null 2>&1 \
        && clear"
	elif [[ "$1" == "work_bpa_btp_build_image" ]]; then
		cmd="cd '$BPA/btp_build_image/' \
        && clear"
	elif [[ "$1" == "work_bpa_bpa_dev_tools" ]]; then
		cmd="cd '$BPA/bpa-dev-tools/' \
        && clear"
	elif [[ "$1" == "work_bpa_bpa_testing" ]]; then
		cmd="cd '$BPA/bpa-testing/' \
        && clear"
	elif [[ "$1" == "personal_foo" ]]; then
		cmd="cd '$PERSONAL/foo/' \
        && clear"
	elif [[ "$1" == "personal_mini_shop" ]]; then
		cmd="cd '$PERSONAL/mini-shop/' \
        && clear"
	elif [[ "$1" == "personal_mini_shop_client" ]]; then
		cmd="cd '$PERSONAL/mini-shop-client/' \
        && clear"
	elif [[ "$1" == "personal_api_gateway" ]]; then
		cmd="cd '$PERSONAL/api-gateway/' \
        && clear"
	elif [[ "$1" == "personal_go_calc" ]]; then
		cmd="cd '$PERSONAL/go-calc/' \
        && clear"
	elif [[ "$1" == "personal_flink" ]]; then
		cmd="cd '$PERSONAL/flink/' \
        && clear"
	fi

	tmux send-keys -t "$1:0" "$cmd" C-m
}

session="$(tmux ls | cut -f1 -d":" | fzf)"
target=$(echo "$session" | sed 's/-[0-9]*//')

pre_attach_action "$target"
if [ -z "$TMUX" ]; then
	tmux attach -t "$session"
else
	tmux switch -t "$session"
fi
