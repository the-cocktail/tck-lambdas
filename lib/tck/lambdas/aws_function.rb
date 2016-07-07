# Copyright (c) The Cocktail Experience S.L. (2016)
require "yaml"
require "tmpdir"

module Tck
  module Lambdas
    class AwsFunction
      attr_reader :name
      attr_reader :conf

      def self.tmpdir
        @tmpdir ||= Dir.tmpdir + "/tck_lambdas"
      end

      def self.yaml
        @yaml ||= File.exist?('.lambdas.yml') ? YAML.load_file('.lambdas.yml') : nil
      end

      def self.clean_tmps!
        FileUtils.mkdir_p tmpdir
        FileUtils.rm_rf Dir.glob("#{tmpdir}/*")
      end

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
        self.class.tmpdir
      end

      def zip_file
        @zip_file ||= "#{tmpdir}/#{function_name}.zip"
      end

      def invoke_events_in_directory(event_type)
puts "lambdas/#{name}/#{event_type}/*.json"
        Dir["lambdas/#{name}/test/#{event_type}/*.json"].each do |json_file|
          filename = File.basename(json_file)
          output = "#{tmpdir}/#{filename}.output"
          invoke_lambda json_file, output
          yield filename, File.read(output)
        end
      end

      def invoke_lambda(payload_file, output_file)
        cmd = "aws lambda invoke " <<
                "--function-name #{@conf['function-name']}_test " <<
                "--payload file://#{payload_file} #{output_file}"
        puts "$ #{cmd}"
        `#{cmd}`
      end

      def yaml
        self.yaml
      end
    end
  end
end

