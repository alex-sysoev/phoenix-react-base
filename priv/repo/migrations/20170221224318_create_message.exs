defmodule ReactChat.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text
      add :conversation_id, references(:conversations)
      add :user_id, 				references(:users)

      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:conversation_id])

  end
end
