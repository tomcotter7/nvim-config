local ok, local_conf = pcall(require, "local.local_avante_config")

local bedrock_opts = {
  -- model = "us.anthropic.claude-3-5-sonnet-20241022-v2:0",
  model = "us.anthropic.claude-sonnet-4-20250514-v1:0",
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
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    ask_opts = {
      ask = true
    },
    provider = "bedrock",
    mode = "agentic",
    providers = {
      bedrock = bedrock_opts
    },
    hints = {
      enabled = false
    },
    selector = {
      provider = "telescope"
    }
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim"
  },
}
