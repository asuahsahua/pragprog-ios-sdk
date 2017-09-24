//
// Created by Natalie Marion on 9/24/17.
// Copyright (c) 2017 Natalie Marion. All rights reserved.
//

import Foundation

class PodcastEpisodeParser: NSObject, XMLParserDelegate {
    let feedParser: PodcastFeedParser
    var currentEpisode: PodcastEpisode
    var currentElementText: String?

    init(feedParser: PodcastFeedParser, xmlParser: XMLParser) {
        self.feedParser = feedParser
        self.currentEpisode = PodcastEpisode()

        super.init()

        xmlParser.delegate = self
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        currentElementText = nil

        switch elementName {
        case "title", "itunes:duration":
            currentElementText = ""
        case "itunes:image":
            if let urlAttrib = attributeDict["href"] {
                currentEpisode.iTunesImageURL = URL(string: urlAttrib)
            }
        case "enclosure":
            if let href = attributeDict["url"], let url = URL(string: href) {
                currentEpisode.enclosureURL = url
            }
        default: break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentElementText?.append(string)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "title":
            currentEpisode.title = currentElementText
        case "itunes:duration":
            currentEpisode.iTunesDuration = currentElementText
        case "item":
            parser.delegate = feedParser
            feedParser.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        default: break
        }
    }
}
