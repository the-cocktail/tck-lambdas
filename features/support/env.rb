require "tmpdir"

Before do
  @tmpdir = Dir.tmpdir + "/tck-lambdas"
  FileUtils.mkdir_p(@tmpdir)
  FileUtils.rm_rf Dir.glob("#{@tmpdir}/*")
  FileUtils.chdir(@tmpdir) do
    FileUtils.mkdir "features_project"
    FileUtils.mkdir "gem"
  end
end
