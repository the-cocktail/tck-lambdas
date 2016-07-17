Given(/^i have the AWS CLI installed in my system$/) do
  cmd = "aws --version"
  expected = 'aws-cli'

  unless `#{cmd} 2>&1` =~ /#{Regexp.escape(expected)}/ 
    raise "Sorry, AWS CLI should be working in your system."
  end
end

Given(/^i have the right crendentials in \.aws\/credentials$/) do
  cmd = "aws lambda list-functions --max-items 0"
  expected = '"Functions": []'

  unless `#{cmd} 2>&1` =~ /#{Regexp.escape(expected)}/ 
    raise "Sorry, AWS CLI should have credentials to access AWS Lambda."
  end
end
