## Show webapp without comments 

object @webapp
attributes *Webapp.column_names

node do |webapp|
	if webapp
		child :tags do
			attributes *Tag.column_names
		end
	end
end
