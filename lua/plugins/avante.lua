local ok, local_conf = pcall(require, "local.local_avante_config")

local bedrock_opts = {
  model = "global.anthropic.claude-opus-4-5-20251101-v1:0",
  -- model = "us.anthropic.claude-sonnet-4-5-20250929-v1:0",
  aws_profile = "",
  aws_region = "",
  is_env_set = function()
    return true
  end
}

if ok and local_conf then
  bedrock_opts.aws_profile = local_conf.aws_profile
  bedrock_opts.aws_region = local_conf.aws_region
end

return {
  "yetone/avante.nvim",
  build = "make",
  event = "VeryLazy",
  version = false,
  commit = "cf352f6f4653dddbac0980c06ca3f97554f80d80",
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    ask_opts = {
      ask = true
    },
    provider = "bedrock",
    auto_suggestions_provider = "bedrock",
    behaviour = {
      auto_suggestions = false,
      auto_approve_tool_permissions = false,
      enable_fastapply = false,
    },
    mode = "agentic",
    providers = {
      bedrock = bedrock_opts
    },
    hints = {
      enabled = false
    },
    selector = {
      provider = "telescope"
    },
    suggestion = {
      debounce = 0,
      throttle = 10000,
    }
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim"
  },
}
