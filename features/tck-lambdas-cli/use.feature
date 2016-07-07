Feature: Developer uses a new AWS Lambda function in her/his app.

As a developer using AWS Lambda's functions
I want to add a lambda to my current project
So that i can manage it with tck-lambdas tasks

Scenario: Trying to add an non-existent lambda
  Given my project has the tck-lambdas gem installed
  When i run "tck-lambdas use iwannaexist"
  Then the command fails
   And the output contains "not found"
