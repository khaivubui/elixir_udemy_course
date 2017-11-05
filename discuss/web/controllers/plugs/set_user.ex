defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init _ do
  end

  def call conn, _params do
    user_id = get_session(conn, :user_id)

    if user_id do
      user = Repo.get(User, user_id)
      assign conn, :user, user
    else
      assign conn, :user, nil
    end
  end
end
