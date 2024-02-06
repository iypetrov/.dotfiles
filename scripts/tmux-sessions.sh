#!/bin/bash

session="$(tmux ls | cut -f1 -d":" | fzf)"
if [ -n "$TMUX" ]; then
	tmux switch-client -n -t "$session"
else
	tmux attach -t "$session"
fi

if [[ "$session"=="common_dotfiles" ]]; then
	cd "$COMMON/.dotfiles"
elif [[ "$session"=="common_notes" ]]; then
	cd "$COMMON/notes"
elif [[ "$session"=="common_ledger" ]]; then
	cd "$COMMON/ledger"
elif [[ "$session"=="work_bpa_master_data_api_feature_1" ]]; then
	cd "$BPA/master-data-api"
	git checkout feature-1 -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java
	git checkout feature-1 -- src/main/resources/application-local.properties
elif [[ "$session"=="work_bpa_master_data_api_dev" ]]; then
	cd "$BPA/master-data-api"
	git checkout develop -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java
	git checkout develop -- src/main/resources/application-local.properties
elif [[ "$session"=="work_bpa_master_data_api_test" ]]; then
	cd "$BPA/master-data-api"
	git checkout test -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java
	git checkout test -- src/main/resources/application-local.properties
elif [[ "$session"=="work_bpa_master_data_api_staging" ]]; then
	cd "$BPA/master-data-api"
	git checkout staging -- src/main/java/com/iteconomics/bpa/masterdata/config/SecurityConfig.java
	git checkout staging -- src/main/resources/application-local.properties
elif [[ "$session"=="work_bpa_master_data_fe_local" ]]; then
	cd "$BPA/master-data-fe"
	git checkout local -- BTP_FE/src/emvironments/environment.ts
elif [[ "$session"=="work_bpa_master_data_fe_feature_1" ]]; then
	cd "$BPA/master-data-fe"
	git checkout feature-1 -- BTP_FE/src/emvironments/environment.ts
elif [[ "$session"=="work_bpa_master_data_fe_dev" ]]; then
	cd "$BPA/master-data-fe"
	git checkout develop -- BTP_FE/src/emvironments/environment.ts
elif [[ "$session"=="work_bpa_master_data_fe_test" ]]; then
	cd "$BPA/master-data-fe"
	git checkout test -- BTP_FE/src/emvironments/environment.ts
elif [[ "$session"=="work_bpa_master_data_fe_staging" ]]; then
	cd "$BPA/master-data-fe"
	git checkout staging -- BTP_FE/src/emvironments/environment.ts
elif [[ "$session"=="work_bpa_btp_build_image" ]]; then
	cd "$BPA/btp_build_image"
elif [[ "$session"=="work_bpa_bpa_dev_tools" ]]; then
	cd "$BPA/bpa-dev-tools"
elif [[ "$session"=="work_bpa_bpa_testing" ]]; then
	cd "$BPA/bpa-testing"
elif [[ "$session"=="personal_foo" ]]; then
	cd "$PERSONAL/foo"
elif [[ "$session"=="personal_mini_shop" ]]; then
	cd "$PERSONAL/mini-shop"
elif [[ "$session"=="personal_mini_shop_client" ]]; then
	cd "$PERSONAL/mini-shop-client"
elif [[ "$session"=="personal_api_gateway" ]]; then
	cd "$PERSONAL/api-gateway"
elif [[ "$session"=="personal_go_calc" ]]; then
	cd "$PERSONAL/go-calc"
elif [[ "$session"=="personal_flink" ]]; then
	cd "$PERSONAL/flink"
fi
