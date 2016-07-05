# Copyright (c) The Cocktail Experience S.L. (2016)
require "thor"
require_relative "aws_function"

module Tck
  module Lambdas
    class CLI < Thor
      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__)
      end

      desc "use NAME", "Use the AWS Lambda function known as NAME at The Cocktail."
      def use(name)
        puts "#{CLI.source_root}/#{name}"
        if File.directory?("#{CLI.source_root}/#{name}")
          @lambda = Tck::Lambdas::AwsFunction.new(name)

          copy_file "Rakefile"
          copy_file "aws_function.rb", "lib/tck/lambdas/aws_function.rb"
          template "templates/lambdas.yml.erb", ".lambdas.yml"
          template "templates/lambdas.rake.erb", "lib/tasks/lambdas.rake"
          directory name, "lambdas/#{name}"
        else
          raise "Sorry, '#{name}' is not a valid lambda name."
        end
      end
    end
  end
end
