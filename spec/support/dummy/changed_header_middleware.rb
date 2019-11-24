class ChangedHeaderMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, header, body = @app.call(env)

    if header.key?('Foo')
      header['Foo'] = 'Baz'
    end

    [status, header, body]
  end
end
