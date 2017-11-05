defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth when action in [
    :new, :create, :edit, :update, :delete
  ]

  plug :check_topic_owner when action in [
    :update, :edit, :delete
  ]

  def index conn, _params do
    topics = Repo.all(from t in Topic, order_by: t.id)
    render conn, :index, topics: topics
  end

  def show conn, %{"id" => topic_id} do
    topic = Repo.get(Topic, topic_id)
  end

  def new conn, _params do
    changeset = Topic.changeset %Topic{}
    render conn, :new, changeset: changeset
  end

  def create conn, %{"topic" => topic} do # topic == %{"title" => "abc"}
    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, :new, changeset: changeset
    end
  end

  def edit conn, %{"id" => topic_id} do
    changeset = Repo.get(Topic, topic_id)
      |> Topic.changeset
    render conn, :edit, changeset: changeset
  end

  def update conn, %{"topic" => topic, "id" => topic_id} do
    changeset = Repo.get(Topic, topic_id)
      |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, :edit, changeset: changeset
    end
  end

  def delete conn, %{"id" => topic_id} do
    Repo.get(Topic, topic_id) |> Repo.delete

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner conn, _params do
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "Not authorized")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end
