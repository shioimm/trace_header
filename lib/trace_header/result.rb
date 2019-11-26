class TraceHeader
  class Result
    attr_reader :target_app

    def initialize(target_app, datas)
      @target_app  = target_app
      @target_hash = datas.find { |data| data[:middleware].eql?(target_app.class) }
      @inner_hash  = datas[datas.index(@target_hash) + 1]
    end

    def new_headers
      headers(new_fields)
    end

    def changed_headers
      headers(changed_fields)
    end

    private

      def common_fields
        target_header.keys & prev_header.keys
      end

      def new_fields
        target_header.keys - common_fields
      end

      def changed_fields
        common_fields.select { |field| target_header[field] != prev_header[field] }
      end

      def target_header
        @target_header ||= rack_app(@target_hash)[1]
      end

      def prev_header
        @prev_header ||= rack_app(@inner_hash)[1]
      end

      def rack_app(hash)
        hash[:app].call(hash[:env])
      end

      def headers(fields)
        fields.map { |field| { field => target_header[field].to_s } }
      end
  end
end
