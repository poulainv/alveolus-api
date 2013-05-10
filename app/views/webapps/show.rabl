object @webapp
attributes *Webapp.column_names

node do |webapp|
	if webapp
		child webapp.tags do
			attributes *Tag.column_names
		end

		child webapp.comments do |t|
			attributes *Comment.column_names
			node (:user) do |comment|
				if comment.user.pseudo
					comment.user.pseudo
				else
					"user " + comment.user.id.to_s
				end
			end
		end
	end
end
