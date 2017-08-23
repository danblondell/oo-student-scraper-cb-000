require 'open-uri'
require 'pry'

class Scraper
 def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open('http://159.203.91.59:30001/fixtures/student-site/'))

    student_cards = doc.css('div .student-card')

    student_cards.collect do |student|
      name = student.css('.card-text-container h4').text
      location = student.css('.card-text-container p').text
      profile_url = student.css('a').attribute('href').value


      {name: "#{name}", location: "#{location}", profile_url: "#{profile_url}"}
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    social = doc.css('.social-icon-container a')
    social_links = social.collect {|link| link.attribute('href').value}
    quote = doc.css('div div .profile-quote').text
    bio = doc.css(".bio-content div p").text

    hash = {bio: "#{bio}", profile_quote: "#{quote}"}


    social_links.each do |l|
      if l.include?("twitter")
        hash[:twitter] = l
      elsif l.include?("linkedin")
        hash[:linkedin] = l
      elsif l.include?("github")
        hash[:github] = l
      else
        hash[:blog] = l
      end
    end

    hash
  end

end
