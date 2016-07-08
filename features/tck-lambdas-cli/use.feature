Feature: Developer uses a new AWS Lambda function in her/his app.

As a developer using AWS Lambda's functions
I want to add a lambda to my current project
So that i can manage it with tck-lambdas tasks

Scenario: Trying to add a non-existent lambda
  Given i have the AWS CLI installed in my system
    And i have the right crendentials in .aws/credentials
    And my project has the tck-lambdas gem installed
  When i run "tck-lambdas use iwannaexist"
  Then the command fails
   And the output contains "not found"
