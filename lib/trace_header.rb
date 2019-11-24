require 'active_support/core_ext'
require_relative 'trace_header/description'
require_relative 'trace_header/result'
require 'trace_header/version'

class TraceHeader
  include Description

  def initialize(app)
    @app       = app
    @outputs   = []
    @fixed_app = nil
  end

  def call(env)
    tracer.enable { @app.call(env) }
    display(result)
    @fixed_app
  end

  private
    using Module.new {
      refine TracePoint do
        def called_rack_middleware?
          method_id.eql?(:call) && binding.local_variable_defined?(:env)
        end
      end
    }

    def tracer
      TracePoint.new(:call, :return) do |tp|
        if tp.called_rack_middleware?
          if tp.event.eql?(:call) \
            && !@outputs.find { |input| input[:middleware].eql? tp.defined_class }
            @outputs << { middleware: tp.defined_class,
                          app: tp.self.deep_dup,
                          env: tp.binding.local_variable_get(:env).deep_dup }
          end

          if tp.event.eql?(:return)
            @fixed_app = tp.return_value
          end
        end
      end
    end

    def result
      TraceHeader::Result.new(@app, @outputs)
    end
end
