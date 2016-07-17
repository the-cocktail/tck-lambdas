Given(/^i'm on an empty project directory$/) do
  FileUtils.rm_rf Dir.glob("#{@tmpdir}/features_project/*")
  FileUtils.chdir("#{@tmpdir}/features_project") do
    File.write "Gemfile", "source 'https://rubygems.org'\n"
  end
end

Given(/^i add the ([^ ]+) gem to its current gems$/) do |gem|
  pending
  FileUtils.chdir("#{@tmpdir}/features_project") do
    `echo "gem '#{gem}', path: '#{@tmpdir}/gem'" >> Gemfile`
    `bundle install --path=#{@tmpdir}/vendor`
  end
end

When(/^i run "([^"]*)"$/) do |command|
  FileUtils.chdir(@tmpdir) do
    @command = command
    @output = `bundle exec #{command} 2>&1`
    @output_status = $?
  end
end
