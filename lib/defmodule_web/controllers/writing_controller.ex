defmodule DefmoduleWeb.WritingController do
  use DefmoduleWeb, :controller

  alias Defmodule.Writing

  def index(conn, _params) do
    tags = Writing.all_tags()

    render(
      conn
      |> assign(:tags, tags),
      :index
    )
  end

  def show(conn, params) do
    post = Writing.get_post_by_id!(params["id"])
    current_url = current_url(conn)
    tags = Writing.all_tags()

    render(
      conn
      |> assign(:post, post)
      |> assign(:tags, tags)
      |> assign(:current_url, current_url),
      :show
    )
  end

  def tags(conn, %{"id" => tag} = _params) do
    posts = Writing.get_posts_by_tag!(tag)
    tags = Writing.all_tags()

    render(
      conn
      |> assign(:posts, posts)
      |> assign(:tags, tags)
      |> assign(:tag, tag),
      :tags
    )
  end
end
