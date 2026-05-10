%{
  deps: %{
    pristine: %{
      path: "../pristine/apps/pristine_runtime",
      github: %{repo: "nshkrdotcom/pristine", branch: "main", subdir: "apps/pristine_runtime"},
      hex: "~> 0.2.1",
      default_order: [:path, :github, :hex],
      publish_order: [:hex]
    },
    pristine_codegen: %{
      path: "../pristine/apps/pristine_codegen",
      github: %{repo: "nshkrdotcom/pristine", branch: "main", subdir: "apps/pristine_codegen"},
      hex: "~> 0.2.1",
      default_order: [:path, :github, :hex],
      publish_order: [:hex]
    },
    pristine_provider_testkit: %{
      path: "../pristine/apps/pristine_provider_testkit",
      github: %{
        repo: "nshkrdotcom/pristine",
        branch: "main",
        subdir: "apps/pristine_provider_testkit"
      },
      hex: "~> 0.2.1",
      default_order: [:path, :github, :hex],
      publish_order: [:hex]
    }
  }
}
