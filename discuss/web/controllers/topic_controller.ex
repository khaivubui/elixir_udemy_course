defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  def index conn, _params do
    topics = Repo.all Topic
    render conn, :index, topics: topics
  end

  def new conn, _params do
    changeset = Topic.changeset %Topic{}
    render conn, :new, changeset: changeset
  end

  def create conn, %{"topic" => topic} do # topic == %{"title" => "abc"}
    changeset = Topic.changeset(%Topic{}, topic)

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
end
