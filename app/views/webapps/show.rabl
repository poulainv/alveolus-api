object @webapp
attributes *Webapp.column_names

node do |webapp|
	child webapp.tags do
		attributes *Tag.column_names
	end

	child webapp.comments do |t|
		attributes *Comment.column_names
		node (:user) do |comment|
			comment.user.email
		end
	end
end
