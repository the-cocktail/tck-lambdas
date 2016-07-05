# Copyright (c) The Cocktail Experience S.L. (2016)
require "yaml"
require "tmpdir"

module Tck
  module Lambdas
    class AwsFunction
      attr_reader :name
      attr_reader :conf

      def initialize(name)
        @name = name.to_s
        @conf = yaml[@name]
      end

      def test_function_name
        "#{@conf['function-name']}_test"
      end

      def method_missing(method, *args, &block)  
        m = method.to_s
        @conf[m] || @conf[m.gsub("_","-")] || super
      end

      def dir
        @dir ||= "lambdas/#{name}"
      end

      def tmpdir
        @tmpdir ||= Dir.tmpdir
      end

      def zip_file
        @zip_file ||= "#{tmpdir}/#{function_name}.zip"
      end

      private

      def yaml
        File.exist?('.lambdas.yml') ? YAML.load_file('.lambdas.yml') : {}
      end
    end
  end
end

