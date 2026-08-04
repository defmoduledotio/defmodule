defmodule DefmoduleWeb.Plugs.Posts do
  import Plug.Conn

  alias Defmodule.Writing

  def init(default), do: default

  def call(conn, _default) do
    conn
    |> assign(:posts, Writing.all_posts())
  end
end
