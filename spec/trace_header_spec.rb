# frozen_string_literal: true

require_relative './spec_helper'
require_relative './support/dummy/sample_app'
require_relative './support/dummy/new_header_middleware'
require_relative './support/dummy/changed_header_middleware'

RSpec.describe TraceHeader do
  it 'has a version number' do
    expect(TraceHeader::VERSION).not_to be nil
  end

  describe '#call' do
    let(:app) { SampleApp.new }
    let(:env) { nil }

    context 'when new header added' do
      let(:app_with_middleware) { NewHeaderMiddleware.new(app) }
      let(:app_with_trace_header) { TraceHeader.new(app_with_middleware) }
      let(:fixed_app) { [200, { 'Content-Type' => 'text/plain', 'Foo' => 'Bar' }, ["Hello World\n"]] }

      subject(:call_app) { app_with_trace_header.call(env) }

      it 'returns correct app' do
        expect(call_app).to eq fixed_app
      end

      it 'outputs correct name of middleware' do
        expect { call_app }.to output(/\[Target Middleware\]\n  NewHeaderMiddleware/).to_stdout
      end

      it 'outputs correct new header' do
        expect { call_app }.to output(/\[New Headers\]\n  - Foo:  Bar/).to_stdout
      end

      it 'outputs correct changed header' do
        expect { call_app }.to output(/\[Changed Headers\]\n  - Nothing changed\. -/).to_stdout
      end
    end

    context 'when header changed' do
      let(:app_with_middleware) { ChangedHeaderMiddleware.new(NewHeaderMiddleware.new(app)) }
      let(:app_with_trace_header) { TraceHeader.new(app_with_middleware) }
      let(:fixed_app) { [200, { 'Content-Type' => 'text/plain', 'Foo' => 'Baz' }, ["Hello World\n"]] }

      subject(:call_app) { app_with_trace_header.call(env) }

      it 'returns correct app' do
        expect(call_app).to eq fixed_app
      end

      it 'outputs correct name of middleware' do
        expect { call_app }.to output(/\[Target Middleware\]\n  ChangedHeaderMiddleware/).to_stdout
      end

      it 'outputs correct new header' do
        expect { call_app }.to output(/\[New Headers\]\n  - Nothing changed\. -/).to_stdout
      end

      it 'outputs correct changed header' do
        expect { call_app }.to output(/\[Changed Headers\]\n  - Foo:  Baz/).to_stdout
      end
    end
  end
end
