class TraceHeader
  module Description
    MAXIMUM_LENGTH = 50

    def display(result)
      puts description(result)
    end

    private
      def description(result)
        <<~"TEXT"
        ----------------------------------------------------

        TraceHeader printing...

        [Target Middleware]
          #{result.target_app.class}\n
        [New Headers]
        #{detailed_description(result.new_headers)}
        [Changed Headers]
        #{detailed_description(result.changed_headers)}
        ----------------------------------------------------
        TEXT
      end

      def detailed_description(headers)
        if headers.empty?
          "  - Nothing changed. -\n"
        else
          <<~"TEXT"
            #{lined_description(headers).join("\n")}
          TEXT
        end
      end

      def lined_description(headers)
        headers.flat_map do |header|
          header.map { |field, value| "  - #{field}:  #{form(value)}" }
        end
      end

      def form(text)
        text.split(';').map do |str|
          str.size > MAXIMUM_LENGTH ? str[0..MAXIMUM_LENGTH] + '...' : str
        end.join(';')
      end
  end
end
