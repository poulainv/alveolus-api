object @webapp
attributes *Webapp.column_names

node do |webapp|
	if webapp
		child :tags do
			attributes :id, :name
		end

		child webapp.comments do |t|
			extends "comments/index"
		end


		child webapp.category do |t|
			attributes :id, :name
		end

		child webapp.user do |t|
			attributes :id, :pseudo
		end

		node(:image_url) { |webapp| webapp.image_url(:medium) }

	end
end
