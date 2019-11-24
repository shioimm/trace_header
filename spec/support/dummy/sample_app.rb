class SampleApp
  def call(env)
    [200, { 'Content-Type' => 'text/plain' }, ["Hello World\n"]]
  end
end
