object @webapp

attributes *Webapp.column_names

child @webapp.tags do
	attributes *Tag.column_names
end

child @webapp.comments do
	attributes *Comment.column_names
end