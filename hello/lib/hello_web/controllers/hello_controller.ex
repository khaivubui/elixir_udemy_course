defmodule HelloWeb.HelloController do
  user HelloWeb, :controller

  def index conn, _params do
    render conn, "index.html"
  end
end
