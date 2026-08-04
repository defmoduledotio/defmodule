defmodule DefmoduleWeb.ContactControllerTest do
  use DefmoduleWeb.ConnCase

  import Swoosh.TestAssertions

  @valid_attrs %{
    "first_name" => "Ada",
    "last_name" => "Lovelace",
    "email" => "ada@example.com",
    "phone" => "555-0100",
    "message" => "Let's build something."
  }

  describe "GET /contact" do
    test "renders the contact form", %{conn: conn} do
      conn = get(conn, ~p"/contact")
      body = html_response(conn, 200)
      assert body =~ "Get in touch"
      assert body =~ ~s(name="contact[first_name]")
      assert body =~ ~s(name="contact[message]")
    end
  end

  describe "POST /contact" do
    test "with valid params sends an email and redirects", %{conn: conn} do
      conn = post(conn, ~p"/contact", contact: @valid_attrs)
      assert redirected_to(conn) == ~p"/contact"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "your message has been sent"
      assert_email_sent(fn email ->
        assert email.subject =~ "Ada Lovelace"
        assert email.text_body =~ "Let's build something."
        assert email.reply_to == {"Ada Lovelace", "ada@example.com"}
      end)
    end

    test "missing required fields re-renders with errors and sends nothing", %{conn: conn} do
      attrs = Map.merge(@valid_attrs, %{"first_name" => "", "email" => "", "message" => ""})
      conn = post(conn, ~p"/contact", contact: attrs)
      body = html_response(conn, 200)
      assert body =~ "can&#39;t be blank"
      assert_no_email_sent()
    end

    test "invalid email is rejected", %{conn: conn} do
      attrs = Map.put(@valid_attrs, "email", "not-an-email")
      conn = post(conn, ~p"/contact", contact: attrs)
      assert html_response(conn, 200) =~ "must be a valid email"
      assert_no_email_sent()
    end
  end
end
