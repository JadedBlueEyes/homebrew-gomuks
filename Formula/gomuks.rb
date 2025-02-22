class Gomuks < Formula
  desc "Matrix client written in Go"
  homepage "https://maunium.net/go/gomuks"
  url "https://github.com/tulir/gomuks.git",
      revision: "5c27592b8cacb1bb5208af357b1bc88eeb6b8a88"
  version "0.0.0"
  license "AGPL-3.0-or-later"

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "libolm"

  def install
    mautrix_version = `grep 'maunium.net/go/mautrix ' go.mod | head -n1 | awk '{ print $2 }'`
    ldflags = "-X go.mau.fi/gomuks/version.Tag=#{`git describe --exact-match --tags 2>/dev/null`} " \
              "-X go.mau.fi/gomuks/version.Commit=#{`git rev-parse HEAD`.strip} " \
              "-X 'go.mau.fi/gomuks/version.BuildTime=#{Time.now.utc.iso8601}' " \
              "-X 'maunium.net/go/mautrix.GoModVersion=#{mautrix_version}' " \
              "-s -w"
    system "go", "generate", "./web"
    system "go", "build", *std_go_args(ldflags), "./cmd/gomuks"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test gomuks`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "go", "test", "-v", "./..."
  end
end
