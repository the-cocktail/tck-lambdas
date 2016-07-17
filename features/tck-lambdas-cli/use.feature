Feature: Developer uses a new AWS Lambda function in her/his project.

As a Ruby developer with a library of AWS Lambda's functions
I want to add a lambda to my current Ruby project using the tck-lambdas gem
So that i can manage it using the tck-lambdas Rake tasks

Background:
  Given i have the AWS CLI installed in my system
    And i have the right crendentials in .aws/credentials
    And i'm on an empty project directory
    And i add the tck-lambdas gem to its current gems

Scenario: Trying to add a non-existent lambda
   When i run "tck-lambdas use im_not_defined"
   Then the command fails
    And the output contains "not found"

Scenario: Adding an existent tck-lambda
   When i run "tck-lambdas use contact_form"
   Then the command succeeds
    And the lambda is listed between the project lambdas
