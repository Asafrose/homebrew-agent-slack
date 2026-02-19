class AgentSlack < Formula
  desc "Slack CLI tool for AI agents - replaces MCP Slack tools with a token-efficient CLI"
  homepage "https://github.com/Asafrose/agent-slack"
  url "https://github.com/Asafrose/agent-slack.git",
      tag: "v0.1.0"
  license "MIT"

  depends_on "oven-sh/bun/bun"

  def install
    # Install all source files
    libexec.install Dir["*"]
    libexec.install ".claude-plugin"

    # Install dependencies
    system "bun", "install", "--production", "--frozen-lockfile"
    libexec.install "node_modules"

    # Create wrapper script that uses bun to run the CLI
    (bin/"agent-slack").write <<~EOS
      #!/bin/bash
      exec "#{Formula["oven-sh/bun/bun"].opt_bin}/bun" "#{libexec}/bin/agent-slack.ts" "$@"
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/agent-slack --help")
  end
end
