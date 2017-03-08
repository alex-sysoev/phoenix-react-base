alias ReactChat.Repo
alias ReactChat.User
alias ReactChat.Conversation
alias ReactChat.UserConversation
alias ReactChat.Role
alias ReactChat.UserRole

import Ecto.Query

user = Repo.get_by(User, email: "admin@phoenixchat.com") ||
	Repo.insert!(User.registration_changeset(%User{},
		%{ email: "admin@phoenixchat.com", first_name: "Admin", last_name: "McAdmins", password: "12341234" }
	))

Enum.each(
	["guest","client","admin"], 
	fn role ->
		Repo.get_by(Role, name: role) || Repo.insert!(%Role{ name: role })
	end
)

conversation = Repo.get_by(Conversation, name: "General") ||
	Repo.insert!(%Conversation{
		name: "General"
	})

user_con = Repo.all from c in Conversation,
	join: u in assoc(c, :users), where: u.email == "admin@phoenixchat.com"

user_roles = Repo.all from ur in UserRole, join: u in assoc(ur, :user), 
	where: u.email == ^user.email

case Enum.count(user_roles) do
	0 -> Repo.insert!(%UserRole{ user_id: user.id, role_id: Repo.get_by(Role, name: "admin").id })
	_ -> :error
end

case Enum.count(user_con) do
	0 -> Repo.insert!(%UserConversation{ user_id: user.id, conversation_id: conversation.id})
	_ -> :error
end
