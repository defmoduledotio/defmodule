defmodule DefmoduleWeb.PageController do
  use DefmoduleWeb, :controller

  alias Defmodule.Contact

  import Phoenix.Component, only: [to_form: 2]

  def home(conn, _params) do
    conn
    |> assign(:transparent_nav, true)
    |> render(:home)
  end

  def contact(conn, _params) do
    render(conn, :contact, form: to_form(Contact.changeset(%{}), as: :contact))
  end

  def submit_contact(conn, %{"contact" => contact_params}) do
    case Contact.submit(contact_params) do
      {:ok, _contact} ->
        conn
        |> put_flash(:info, "Thanks — your message has been sent. I'll be in touch.")
        |> redirect(to: ~p"/contact")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please fix the errors below and try again.")
        |> render(:contact, form: to_form(changeset, as: :contact))
    end
  end
end
