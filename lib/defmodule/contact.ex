defmodule Defmodule.Contact do
  @moduledoc """
  Contact form submission: validation and delivery.

  This is an embedded (schemaless-style) Ecto schema — nothing is persisted to
  the database. It exists purely to validate the incoming form params and to
  build/send the notification email.
  """
  use Ecto.Schema

  import Ecto.Changeset
  import Swoosh.Email

  alias Defmodule.Mailer

  @primary_key false
  embedded_schema do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :message, :string
  end

  @doc """
  Builds a changeset from the given `attrs`.

  Required: `first_name`, `email`, `message`. Optional: `last_name`, `phone`.
  """
  def changeset(contact \\ %__MODULE__{}, attrs) do
    contact
    |> cast(attrs, [:first_name, :last_name, :email, :phone, :message])
    |> update_change(:first_name, &trim/1)
    |> update_change(:last_name, &trim/1)
    |> update_change(:email, &trim/1)
    |> update_change(:phone, &trim/1)
    |> validate_required([:first_name, :email, :message])
    |> validate_format(:email, ~r/^[^@\s]+@[^@\s]+\.[^@\s]+$/, message: "must be a valid email")
    |> validate_length(:first_name, max: 100)
    |> validate_length(:last_name, max: 100)
    |> validate_length(:phone, max: 40)
    |> validate_length(:message, max: 5000)
  end

  @doc """
  Validates `attrs` and, if valid, sends the notification email.

  Returns `{:ok, %Contact{}}` on success or `{:error, changeset}` when the
  submission is invalid.
  """
  def submit(attrs) do
    changeset = changeset(attrs)

    if changeset.valid? do
      contact = apply_changes(changeset)
      _ = deliver(contact)
      {:ok, contact}
    else
      {:error, %{changeset | action: :validate}}
    end
  end

  @doc "Delivers the notification email for a validated contact submission."
  def deliver(%__MODULE__{} = contact) do
    new()
    |> to(recipient())
    |> from({"defmodule contact form", "contact@defmodule.io"})
    |> reply_to({full_name(contact), contact.email})
    |> subject("New contact from #{full_name(contact)}")
    |> text_body(body(contact))
    |> Mailer.deliver()
  end

  defp body(contact) do
    """
    Name:  #{full_name(contact)}
    Email: #{contact.email}
    Phone: #{contact.phone || "—"}

    Message:
    #{contact.message}
    """
  end

  defp full_name(%__MODULE__{first_name: first, last_name: last}) do
    [first, last] |> Enum.reject(&(&1 in [nil, ""])) |> Enum.join(" ")
  end

  defp recipient do
    Application.get_env(:defmodule, :contact_recipient, {"defmodule", "isaacfinley@gmail.com"})
  end

  defp trim(nil), do: nil
  defp trim(value), do: String.trim(value)
end
