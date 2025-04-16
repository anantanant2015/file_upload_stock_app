defmodule FileUploadStockApp.Data do
  use Ecto.Schema
  import Ecto.Changeset

  schema "data" do
    field :symbol, :string
    field :timestamp, :integer
    field :price, :float

    timestamps()
  end

  def changeset(data, attrs) do
    data
    |> cast(attrs, [:symbol, :timestamp, :price])
    |> validate_required([:symbol, :timestamp, :price])
    |> validate_number(:price, greater_than_or_equal_to: 0)
  end
end
