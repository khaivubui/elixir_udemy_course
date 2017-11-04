defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User

  def callback %{assigns: %{ueberauth_auth: auth}} = conn, params do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: params["provider"]
    }

    changeset = %User{} |> User.changeset(user_params)

    signin conn, changeset
  end

  def signout conn, _params do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp signin conn, changeset do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user -> {:ok, user}
    end

    |> case do
      {:ok, user} ->
        conn
          |> put_flash(:info, "Welcome back, #{user.email}")
          |> put_session(:user_id, user.id)
      {:error, _reason} ->
        conn
          |> put_flash(:error, "Error signing in")
    end

    |> redirect(to: topic_path(conn, :index))
  end
end
