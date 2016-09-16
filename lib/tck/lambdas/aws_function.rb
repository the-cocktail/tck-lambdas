# Copyright (c) The Cocktail Experience S.L. (2016)
require "yaml"
require "tmpdir"

module Tck
  module Lambdas
    class AwsFunction
      attr_reader :name
      attr_reader :conf

      def self.tmpdir
        @tmpdir ||= Dir.tmpdir + "/tck-lambdas"
      end

      def self.yaml
        if File.exist?('.lambdas.yml')
          current_timestamp = File.mtime('.lambdas.yml')
          if @timestamp == current_timestamp
            @yaml
          else
            @timestamp = current_timestamp
            @yaml = YAML.load_file('.lambdas.yml')
          end
        else
          {}
        end
      end

      def self.clean_tmps!
        FileUtils.mkdir_p tmpdir
        FileUtils.rm_rf Dir.glob("#{tmpdir}/*")
      end

      def initialize(name)
        @name = name.to_s
        @conf = yaml && yaml[@name] || {}
        @timestamp = nil
      end

      def function_name
        @conf['function-name'] || name
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
        @zip_file ||= "#{Dir.pwd}/#{dir}/#{function_name}.zip"
      end

      def invoke_events_in_directory(event_type)
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
        self.class.yaml
      end
    end
  end
end

