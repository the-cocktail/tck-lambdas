Feature: Developer lists AWS Lambda functions available in tck-lambdas.

As a Ruby developer with a library of AWS Lambda's functions
I want to know which lambdas the tck-lambdas gem has
So that i can use or create the one that my project needs

Scenario: List available lambdas
  Given i have the AWS CLI installed in my system
    And i have the right crendentials in .aws/credentials
    And i'm on an empty project directory
    And i add the tck-lambdas gem to its current gems
   When i run "tck-lambdas list"
   Then the command succeeds
    And the output contains "contact_form"
