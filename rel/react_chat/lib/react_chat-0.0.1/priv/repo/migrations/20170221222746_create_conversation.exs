defmodule ReactChat.Repo.Migrations.CreateConversation do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:conversations, [:name])

  end
end
