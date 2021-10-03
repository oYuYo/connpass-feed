require "connpass"
require "rexml/document"

res = Connpass.event_search(keyword: "ruby")


doc = REXML::Document.new
doc << REXML::XMLDecl.new("1.0", "UTF-8")
# root node
root = REXML::Element.new("feed")
root.add_attribute("xmlns","http://www.w3.org/2005/Atom")
doc.add_element(root)
# id / title / link / updated
id = REXML::Element.new("id")
id.add_text("https://oyuyo.github.io/connpass-feed/feed/feed.xml")
root.add_element(id)
title = REXML::Element.new("title")
title.add_text("💎connpass-rss💎")
root.add_element(title)
root.add_element('link rel="alternate" type="text/html" href="https://oyuyo.github.io/connpass-feed/feed/"')
root.add_element('link rel="self" type="application/atom+xml" href="https://oyuyo.github.io/connpass-feed/feed/feed.xml"')
updated = REXML::Element.new("updated")
updated.add_text(Time.now.iso8601.to_s)
root.add_element(updated)
# add entry node
res.events.each do |e|
    entry = REXML::Element.new("entry")
    root.add_element(entry)
    entry_id = REXML::Element.new("id")
    entry_id.add_text(e.event_url)
    entry.add_element(entry_id)
    entry_title = REXML::Element.new("title")
    entry_title.add_text(e.title)
    entry.add_element(entry_title)
    entry_summry = REXML::Element.new("summary")
    entry_summry.add_text(e.catch)
    entry.add_element(entry_summry)
    entry_content = REXML::Element.new("content")
    entry_content.add_attribute("type", "html")
    entry_content.add_attribute("xml:lang", "ja")
    entry_content.add_text(e.description)
    entry.add_element(entry_content)
    entry_url = REXML::Element.new("link")
    entry_url.add_attribute("rel", "alternate")
    entry_url.add_attribute("type", "text/html")
    entry_url.add_attribute("href", e.event_url)
    entry.add_element(entry_url)
    entry_updated = REXML::Element.new("published")
    entry_updated.add_text(e.updated_at)
    entry.add_element(entry_updated)
end

File.open("./public/feed/atom.xml", "w") do |file|
    doc.write(file, indent=2)
end
