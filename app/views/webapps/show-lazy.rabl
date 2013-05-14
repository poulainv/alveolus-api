## Show webapp without comments 

object @webapp
attributes :id, :rating, :title, :description, :caption, :image, :average_rate

node do |webapp|
	if webapp
		child :tags do
			attributes :id, :name
		end

		child webapp.category do |t|
			attributes :id, :name
		end
	end
end
