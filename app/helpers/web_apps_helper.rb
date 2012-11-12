module WebAppsHelper

    def web_details
    webapp = Webapp.find_by_title("Fleex")
    yield(webapp)
  end

end
