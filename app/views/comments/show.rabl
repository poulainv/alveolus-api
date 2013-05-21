object @comment
attributes :id, :body, :rating, :created_at

node do |comment|
	if comment
		child (:user) do
			extends "users/show-lazy"
		end
	end
end


