## Show webapp without comments 

object @webapp
attributes *Webapp.column_names

node do |webapp|
	if webapp
		child :tags do
			attributes *Tag.column_names
		end

		child webapp.category do |t|
			attributes :id, :name
		end
	end
end
