defmodule ReactChat.Repo.Migrations.CreateUserRole do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
  		add :user_id, references(:users)
  		add :role_id, references(:roles)
    end

  	create index(:user_roles, [:user_id])
  	create index(:user_roles, [:role_id])
  	create unique_index(:user_roles, [:user_id, :role_id])
  end
end
