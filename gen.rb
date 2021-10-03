require "connpass"
require "rexml/document"

res = Connpass.event_search(keyword: "ruby")


doc = REXML::Document.new
doc << REXML::XMLDecl.new("1.0", "UTF-8")
# root node
root = REXML::Element.new("feed")
root.add_attribute("xmlns","http://www.w3.org/2005/Atom")
doc.add_element(root)
# title / description / link / update
title = REXML::Element.new("title")
title.add_text("connpass-rss")
root.add_element(title)
description = REXML::Element.new("description")
description.add_text("💎connpassイベントのフィード💎")
root.add_element(description)
root.add_element('link href="https://connpass.com/"')
updated = REXML::Element.new("updated")
updated.add_text(Time.now.to_s)
root.add_element(updated)
# add entry node
res.events.each do |e|
    entry = REXML::Element.new("entry")
    root.add_element(entry)
    entry_title = REXML::Element.new("title")
    entry_title.add_text(e.title)
    entry.add_element(entry_title)
    entry_desc = REXML::Element.new("description")
    entry_desc.add_text(e.description)
    entry.add_element(entry_desc)
    entry_url = REXML::Element.new("link")
    entry_url.add_text(e.entry_url)
    entry.add_element(entry_url)
    entry_start = REXML::Element.new("startDate")
    entry_start.add_text(e.startDate)
    entry.add_element(entry_start)
    entry_end = REXML::Element.new("endDate")
    entry_end.add_text(e.endDate)
    entry.add_element(entry_end)
    entry_place = REXML::Element.new("place")
    entry_place.add_text(e.place)
    entry.add_element(entry_place)
end

File.open("feed/feed.xml", "w") do |file|
    doc.write(file, indent=2)
end
