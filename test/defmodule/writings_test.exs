defmodule Defmodule.WritingsTest do
  use Defmodule.DataCase

  alias Defmodule.Writings

  describe "posts" do
    alias Defmodule.Writings.Post

    import Defmodule.WritingsFixtures

    @invalid_attrs %{author: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Writings.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Writings.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{author: "some author"}

      assert {:ok, %Post{} = post} = Writings.create_post(valid_attrs)
      assert post.author == "some author"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Writings.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{author: "some updated author"}

      assert {:ok, %Post{} = post} = Writings.update_post(post, update_attrs)
      assert post.author == "some updated author"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Writings.update_post(post, @invalid_attrs)
      assert post == Writings.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Writings.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Writings.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Writings.change_post(post)
    end
  end
end
