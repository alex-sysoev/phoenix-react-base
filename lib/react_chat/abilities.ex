defimpl Canada.Can, for: ReactChat.User do

	alias ReactChat.User

  def can?(user, _, _) do
  	User.is_admin?(user)
  end

end