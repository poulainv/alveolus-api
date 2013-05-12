object @webapp
attributes *Webapp.column_names

node do |webapp|
	if webapp
		child :tags do
			attributes *Tag.column_names
		end

		child webapp.comments do |t|
			attributes *Comment.column_names
			child (:user) do
				attributes :id, :pseudo
			end
		end

		child webapp.category do |t|
			attributes :id, :name
		end
	end
end
