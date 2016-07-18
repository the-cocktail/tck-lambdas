# Copyright 2016 The Cocktail Experience, S.L.
require "minitest/autorun"
require "json"
require_relative "../lib/tck/lambdas/aws_function"

Tck::Lambdas::AwsFunction.clean_tmps!

Dir["lambdas/#{ENV["test_only_one_lambda_directory"] || '*'}/"].each do |directory|
  lambda_name = directory[8..-2]

  describe "The Cocktail #{lambda_name} lambda" do
    it "returns 0 when the payload has the right params" do
      aws_lambda = Tck::Lambdas::AwsFunction.new(lambda_name)
      puts "\nTesting #{aws_lambda.function_name} lambda SUCCESS scenarios:"
      aws_lambda.invoke_events_in_directory("succeeded") do |filename, output|
        expect(output).must_equal "0"
        puts "OK!"
      end
    end
  
    it "returns the right error for each wrong payload" do
      aws_lambda = Tck::Lambdas::AwsFunction.new(lambda_name)
      puts "\nTesting #{aws_lambda.function_name} lambda FAILURE scenarios:"
      aws_lambda.invoke_events_in_directory("failed") do |filename, output|
        error_words = JSON.parse(output)["errorMessage"].scan(/(\w+)/)
        expect(error_words.join("_").+(".json")).must_equal filename
        puts "OK!"
      end
    end
  end
end
