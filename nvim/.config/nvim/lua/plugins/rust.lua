return {
  -- Main Rust LSP and Tools (replacing standalone rust-analyzer)
  {
    "mrcjkb/rustaceanvim",
    ft = "rust",
    version = "^6",
    config = function()
      require "configs.rust"
    end,
  },

  -- Cargo.toml dependency management
  {
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    opts = {}, -- Add options if needed
  },

  -- Visualizing Rust Ownership/Borrow checker
  {
    "cordx56/rustowl",
    ft = "rust",
    version = "*",
    build = "cargo binstall rustowl",
    -- lazy = false, -- This plugin is already lazy
    opts = {},
  },
}
