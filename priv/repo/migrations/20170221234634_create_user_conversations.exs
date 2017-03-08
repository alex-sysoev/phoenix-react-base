defmodule ReactChat.Repo.Migrations.CreateUserConversations do
  use Ecto.Migration

  def change do
  	create table(:user_conversations) do
  		add :user_id, references(:users)
  		add :conversation_id, references(:conversations)
  	end

  	create index(:user_conversations, [:user_id])
  	create index(:user_conversations, [:conversation_id])
  	create unique_index(:user_conversations, [:user_id, :conversation_id])
  end
end
