class Gomuks < Formula
  desc "Matrix client written in Go"
  homepage "https://maunium.net/go/gomuks"
  url "https://github.com/tulir/gomuks.git"
  head "https://github.com/tulir/gomuks.git", branch: "main" 
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gomuks"
  end

  test do
    system "gomuks", "--help"
  end
end
