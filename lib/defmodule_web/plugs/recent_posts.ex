defmodule DefmoduleWeb.Plugs.RecentPosts do
  import Plug.Conn

  alias Defmodule.Writing

  def init(default), do: default

  def call(conn, _default) do
    recent_posts = Writing.recent_posts(3)
    [a, b | _tail] = recent_posts

    conn
    |> assign(:recent_posts, recent_posts)
    |> assign(:a_post, a)
    |> assign(:b_post, b)
  end
end
