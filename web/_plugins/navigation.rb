module Jekyll

  class SiteNavigation < Jekyll::Generator
    safe true
    priority :lowest

    def generate(site)

      # First remove all invisible items (default: nil = show in nav)
      unsorted = []
      site.pages.each do |page|
        if not page.data["navigation"].nil?
          unsorted << page if page.data["navigation"]["show"] != false
        else
          puts "no nav on page " + page.data["title"].to_s
        end
      end

      # Then sort according to sections
      sorted = unsorted.sort{ |a,b| a.data["navigation"]["section"] <=> b.data["navigation"]["section"] }

      # Debug info.
      puts "Sorted resulting navigation:  (available in site.config['navigation']) "
      sorted.each do |p|
        puts p.inspect
      end

      # Access this in Liquid using: site.navigation
      site.config["navigation"] = sorted
    end
  end
end