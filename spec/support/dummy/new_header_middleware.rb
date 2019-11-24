class NewHeaderMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, header, body = @app.call(env)

    header.merge!({ 'Foo' =>'Bar' })

    [status, header, body]
  end
end
