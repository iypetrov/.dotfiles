#!/bin/bash

pre_attach_action() {
	local cmd=''

	if [[ "$1" == "common_dotfiles" ]]; then
		cmd="cd '$COMMON/.dotfiles/' \
        && nvim ."
	elif [[ "$1" == "common_notes" ]]; then
		cmd="cd '$COMMON/notes/' \
        && nvim ."
	elif [[ "$1" == "common_ledger" ]]; then
		cmd="cd '$COMMON/ledger/' \
        && nvim ."
	elif [[ "$1" == "work_bpa_master_data_api_feature_1" ]]; then
		cmd="cd '$BPA/master-data-api' \
        && git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 \
        && git checkout feature-1 -- src/main/resources/application-local.properties > /dev/null 2>&1 \
        && nvim ."
	elif [[ "$1" == "work_bpa_master_data_api_dev" ]]; then
		cmd="cd '$BPA/master-data-api' \
        && git checkout develop -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 \
        && git checkout develop -- src/main/resources/application-local.properties > /dev/null 2>&1 \
        && nvim ."
	elif [[ "$1" == "work_bpa_master_data_api_test" ]]; then
		cmd="cd '$BPA/master-data-api' \
        && git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 \
        && git checkout test -- src/main/resources/application-local.properties > /dev/null 2>&1 \
        && nvim ."
	elif [[ "$1" == "work_bpa_master_data_api_staging" ]]; then
		cmd="cd '$BPA/master-data-api' \
        && git checkout local -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java > /dev/null 2>&1 \
        && git checkout staging -- src/main/resources/application-local.properties > /dev/null 2>&1 \
        && nvim ."
		# issue with fe
	elif [[ "$1" == "work_bpa_master_data_fe_local" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout local -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1 \
        && nvim ."
	elif [[ "$1" == "work_bpa_master_data_fe_feature_1" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout feature-1 -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1 \
        && nvim ."
	elif [[ "$1" == "work_bpa_master_data_fe_dev" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout develop -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1 \
        && nvim ."
	elif [[ "$1" == "work_bpa_master_data_fe_test" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout test -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1 \
        && nvim ."
	elif [[ "$1" == "work_bpa_master_data_fe_staging" ]]; then
		cmd="cd '$BPA/master-data-fe/' \
        && git checkout staging -- BTP_FE/src/environments/environment.ts > /dev/null 2>&1 \
        && nvim ."
	elif [[ "$1" == "work_bpa_btp_build_image" ]]; then
		cmd="cd '$BPA/btp_build_image/' \
        && nvim ."
	elif [[ "$1" == "work_bpa_bpa_dev_tools" ]]; then
		cmd="cd '$BPA/bpa-dev-tools/' \
        && nvim ."
	elif [[ "$1" == "work_bpa_bpa_testing" ]]; then
		cmd="cd '$BPA/bpa-testing/' \
        && nvim ."
	elif [[ "$1" == "personal_foo" ]]; then
		cmd="cd '$PERSONAL/foo/' \
        && nvim ."
	elif [[ "$1" == "personal_mini_shop" ]]; then
		cmd="cd '$PERSONAL/mini-shop/' \
        && nvim ."
	elif [[ "$1" == "personal_mini_shop_client" ]]; then
		cmd="cd '$PERSONAL/mini-shop-client/' \
        && nvim ."
	elif [[ "$1" == "personal_api_gateway" ]]; then
		cmd="cd '$PERSONAL/api-gateway/' \
        && nvim ."
	elif [[ "$1" == "personal_go_calc" ]]; then
		cmd="cd '$PERSONAL/go-calc/' \
        && nvim ."
	elif [[ "$1" == "personal_flink" ]]; then
		cmd="cd '$PERSONAL/flink/' \
        && nvim ."
	fi

	tmux send-keys -t "$2:0" "$cmd" C-m
}

session="$(tmux ls | cut -f1 -d":" | fzf)"
target=$(echo "$session" | sed 's/-[0-9]*//')

pre_attach_action "$target" "$session"
if [ -z "$TMUX" ]; then
	tmux attach -t "$session"
else
	tmux switch -t "$session"
fi
