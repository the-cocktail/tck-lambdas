Then(/^the command succeeds$/) do
  unless @output_status.to_i == 0
    raise "Sorry, the command '#{@command}' should should succeed."
  end
end

Then(/^the command fails$/) do
  if @output_status.to_i == 0
    raise "Sorry, the command '#{@command}' should fail."
  end
end

Then(/^the output contains "([^"]*)"$/) do |text|
  unless @output =~ /#{text}/i
    raise "Test failed: the output doesn't contain '#{text}' (output: #{@output})."
  end
end

Then(/^the lambda is listed between the project lambdas$/) do
  FileUtils.chdir(@tmpdir) do
    cmd = "bundle exec tck-lambdas list"
    expected = "cloned from 'contact_form'"
    unless `#{cmd} 2>&1` =~ /#{Regexp.escape(expected)}/
      raise "Test failed: the lambda is not between the project lambdas."
    end
  end
end
