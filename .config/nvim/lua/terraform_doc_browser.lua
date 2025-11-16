local M = {}
--- Opens a URL using the appropriate system command.
-- @param url string The URL to open.
local function open_url(url)
    if not url or url == "" then
        return
    end

    local command
    local sanitized_url = vim.fn.shellescape(url)

    if vim.fn.has("macunix") == 1 then
        command = "open"
    elseif vim.fn.has("win32") == 1 then
        command = 'start ""'
    else -- Assume Linux/BSD
        command = "sudo -u ipetrov xdg-open"
    end

    local full_command = string.format("%s %s > /dev/null 2>&1 &", command, sanitized_url)
    vim.fn.jobstart(full_command, { detach = true })
end

--- Converts a short provider name to its full Terraform registry path.
-- @param provider_short string The short name (e.g., "aws").
-- @return string The full path or an empty string if not found.
local function convert_provider_to_full(provider_short)
    local providers = {
        hcp = "hashicorp/hcp/latest",
        aws = "hashicorp/aws/latest",
        awscc = "hashicorp/awscc/latest",
        vault = "hashicorp/vault/latest",
        cloudflare = "cloudflare/cloudflare/latest",
        github = "integrations/github/latest",
        gitlab = "gitlabhq/gitlab/latest",
        grafana = "grafana/grafana/latest",
        artifactory = "jfrog/artifactory/latest",
        platform = "jfrog/platform/latest",
        project = "jfrog/project/latest",
        kubernetes = "hashicorp/kubernetes/latest",
        helm = "hashicorp/helm/latest",
    }
    return providers[provider_short] or ""
end

--- Main function to find the Terraform context and browse to its documentation.
function M.browse_docs()
    local line = vim.api.nvim_get_current_line()

    local block_pattern = [=[^\s*\(resource\|data\)\s\+"\([^"]\+\)"\s\+"\([^"]\+\)"]=]
    local field_pattern = [=[^\s*\w\+\s*=]=]
    local field_block_pattern = [=[^\s*\(\w\+\)\s*{]=]

    -- Returns a table with match info or nil
    local function get_block_info(target_line)
        -- matchlist() returns: {full_match, capture1, capture2, ...}
        local matches = vim.fn.matchlist(target_line, block_pattern)

        -- Ensure we have the captures we need
        if not matches or #matches < 3 then
            return nil
        end

        local resource_name = matches[3] -- This is the key fix!
        local provider_short = vim.fn.matchstr(resource_name, [=[^[^_]\+]=])
        local target = vim.fn.matchstr(resource_name, [=[_\zs.*]=])

        if not provider_short or not target then
            return nil
        end

        return {
            block = matches[2], -- 'resource' or 'data'
            provider = convert_provider_to_full(provider_short),
            target = target,
        }
    end

    -- Check if the cursor is on a resource or data block definition
    local info = get_block_info(line)
    if info then
        local block_type = (info.block == "resource") and "resources" or "data-sources"
        if info.provider ~= "" then
            local url = string.format(
                "https://registry.terraform.io/providers/%s/docs/%s/%s",
                info.provider,
                block_type,
                info.target
            )
            open_url(url)
        end
        -- Check if the cursor is on a field or nested block
    elseif vim.fn.match(line, field_pattern) ~= -1 or vim.fn.match(line, field_block_pattern) ~= -1 then
        local field
        if vim.fn.match(line, field_pattern) ~= -1 then
            field = vim.fn.matchstr(line, [=[^\s*\zs\w\+\ze\s*=]=])
        else
            field = vim.fn.matchstr(line, [=[^\s*\zs\w\+\ze\s*{]=])
        end

        -- Search backwards for the containing resource/data block
        local block_line_num = vim.fn.search(block_pattern, "bnW")

        if block_line_num > 0 then
            local block_line = vim.fn.getline(block_line_num)
            local block_info = get_block_info(block_line)

            if block_info and block_info.provider ~= "" then
                local block_type = (block_info.block == "resource") and "resources" or "data-sources"
                local url = string.format(
                    "https://registry.terraform.io/providers/%s/docs/%s/%s#%s",
                    block_info.provider,
                    block_type,
                    block_info.target,
                    field
                )
                open_url(url)
            end
        end
    end
end

function M.setup()
    -- Create an augroup to hold our autocmd
    local terraform_augroup = vim.api.nvim_create_augroup("TerraformUtils", { clear = true })

    -- Create the autocmd that triggers when a terraform file is opened
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "terraform",
        group = terraform_augroup,
        callback = function()
            -- Map <leader>dc to call our Lua function for the current buffer
            vim.keymap.set("n", "<leader>dc", function()
                M.browse_docs()
            end, {
                noremap = true,
                silent = true,
                buffer = true, -- Map only for this buffer
                desc = "Browse Terraform Documentation"
            })
        end,
    })
end

return M
