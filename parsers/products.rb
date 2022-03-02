html = Nokogiri.HTML(content)

product = {}

product['url'] = page['url']

product['asin'] = page['vars']['asin']

product['title'] = html.at_css('#productTitle').text.strip

seller = html.css('#sellerProfileTriggerId')
seller = seller ? html.css('a#bylineInfo').text.strip.downcase.gsub('visit the', '') : seller.text
product['seller'] = seller.strip

review_elem = html.at_css('#acrCustomerReviewText')
review_count = review_elem ? review_elem.text.strip.split(' ').first.gsub(',', '') : nil
product['review_count'] = review_count =~ /^\d+$/ ? review_count.to_i : 0

rating_elem = html.at_css('i.a-icon-star .a-icon-alt')
rating_count = rating_elem ? rating_elem.text.strip.split(' ').first : nil
product['rating'] = rating_count  =~ /^[0-9.]+$/ ? rating_count.to_f : nil

price = html.at_css('.a-price .a-offscreen')

product['price'] = price ? price.text.strip.gsub(/[$,]/, '').to_f : nil

availability_elem = html.at_css('#availability')

if availability_elem
    product['availability'] = !availability_elem.text.downcase.include?('currently unavailable')
else
    product['availabitily'] = nil
end

desc_elem = html.css('#feature-bullets li')
desc = ''

desc_elem.each do |li|
    unless li['id'] || (li['class'] && li['class'] != 'showHiddenFeatureBullets')
        desc += li.text.strip + ' '
    end
end


product['description'] = desc

product['image_url'] = html.at_css('#main-image-container img')['src']

product['_collection'] = "products"

outputs << product


