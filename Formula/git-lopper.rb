class GitLopper < Formula
  desc "Find stale git worktrees in all your repositories and remove them safely"
  homepage "https://github.com/albertovincenzi/git-lopper"
  url "https://github.com/albertovincenzi/git-lopper/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4983050023dce676bce800587fa36041505e40d3a1d7056cfa3a54996c0e810c"
  license "MIT"
  head "https://github.com/albertovincenzi/git-lopper.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/git-lopper"
  end

  test do
    system "git", "init", "-q", "-b", "main", "repo"
    system "git", "-C", "repo", "-c", "user.name=test", "-c", "user.email=test@example.com",
           "commit", "-q", "--allow-empty", "-m", "init"
    system "git", "-C", "repo", "worktree", "add", "-q", "../wt", "-b", "feature"
    assert_match(/REVIEW\s+1/, shell_output("#{bin}/git-lopper -C #{testpath} scan --no-fetch"))
    assert_match version.to_s, shell_output("#{bin}/git-lopper --version")
  end
end
