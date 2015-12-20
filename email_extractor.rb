require 'pdf-reader'
require 'open-uri'

puts "Hello, this program extracts emails from papers found in http://www.hicomb.org/"

year = 2 #because it starts at 2003 
article_no = 0
#Use begin, rescue, else 
year_string = " "
article_no_string = " "

last_year = 15
all_emails = [];
while(year < last_year)
	if(year < 10) 
		year_string = "0#{year}"
	else 
		year_string = "#{year}"
	end

	if(article_no < 10) 
		article_no_string = "0#{article_no}"
	else 
		article_no_string = "#{article_no}"
	end
	link = "http://www.hicomb.org/HiCOMB2015/papers/HICOMB20" + year_string + "-" + article_no_string + ".pdf"
	begin
		io = open(link)
	rescue OpenURI::HTTPError => error
		response = error.io
		#puts response.status
		#puts response.string
		puts "year: #{year}"
		year = year + 1 
		article_no = 0
	end
	reader = PDF::Reader.new(io)
	num_pages = reader.pages.size
	page_index = 0
	while page_index < num_pages
		begin
			page_text = reader.pages[page_index].text
		rescue 
			puts "I am trying to rescue"
			page_index = page_index + 1
		end
		emails = page_text.scan(/\b[a-zA-Z0-9.()_%+-]+@[a-zA-Z0-9().-]+\.[a-zA-Z]{2,4}\b/)
		if emails.any? == true
			puts "There are #{emails.size} emails in article #{article_no} from year #{year}"
			all_emails = all_emails + emails;
		end
		page_index = page_index + 1
	end
	puts "Article number: #{article_no}" 
	article_no = article_no + 1
end

puts "There are #{all_emails.size} emails"

num_emails = all_emails.size
email_num = 0
while email_num < num_emails
	email = all_emails[email_num]
	email = email + "\n"
	open('emails.txt', 'a') do |f|
		f << email
	end
	email_num = email_num + 1
end


