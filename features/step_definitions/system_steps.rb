Given(/^i have the AWS CLI installed in my system$/) do
  unless system("aws --version")
    raise "Sorry, AWS CLI should be working in your system!! :("
  end
end

Given(/^i have the right crendentials in \.aws\/credentials$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^my project has the tck\-lambdas gem installed$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
