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

      desc "version", "Show tck-lambdas version."
      def version
        puts "tck-lambdas v" + Tck::Lambdas::VERSION
      end

      desc "all", "List all AWS Lambdas currently available in tck-lambdas."
      def all
        puts "Available functions in tck-lambdas:"
        Dir["#{CLI.source_root}/*/source"].map do |dir|
          puts " - #{dir.match(/lambdas\/(.*)\/source/)[1]}"
        end
      end

      desc "used", "List functions currently used by this project."
      def used
        yaml = Tck::Lambdas::AwsFunction.yaml
        if yaml.any?
          puts "Functions currently used by this project:"
          yaml.each do |lambda_name, properties|
            puts " - #{properties["function-name"]} (cloned from '#{lambda_name}')"
          end
        else
          puts "No lambdas found in this directory... :("
        end
      end
      map list: :used

      desc "use NAME", "Use the AWS Lambda function known as NAME at The Cocktail."
      def use(name)
        puts "#{CLI.source_root}/#{name}"
        if File.directory?("#{CLI.source_root}/#{name}")
          @lambda = Tck::Lambdas::AwsFunction.new(name)

          copy_file "Rakefile"
          copy_file "Gemfile.example"
          template "templates/lambdas.yml.erb", ".lambdas.yml"
          template "templates/lambdas.rake.erb", "lib/tasks/lambdas.rake"
          template "templates/serverless.yml.erb", "serverless.yml"
          template "templates/handler.js.erb", "handler.js"
          copy_file "aws_function.rb", "lib/tck/lambdas/aws_function.rb"
          copy_file "test.rb", "lambdas/test.rb"
          directory name, "lambdas/#{name}"
        else
          raise "Sorry, '#{name}' is not a valid lambda name."
        end
      end

      desc "roles", "List current AWS IAM roles (running 'aws iam list-roles [...]')."
      def roles
        cmd = 'aws iam list-roles --query "Roles[].[RoleName,Arn]"'
        puts cmd
        puts `#{cmd}`
      end
    end
  end
end
