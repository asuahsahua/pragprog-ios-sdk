//
// Created by Natalie Marion on 9/23/17.
// Copyright (c) 2017 Natalie Marion. All rights reserved.
//

import Foundation

class PodcastFeedParser : NSObject, XMLParserDelegate {
    var currentFeed : PodcastFeed?
    var currentElementText : String?
    var episodeParser: PodcastEpisodeParser?

    init (contentsOf url: URL) {
        super.init()

        if let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            parser.parse()
        }
    }

    func parserDidStartDocument(_ parser: XMLParser) {
        currentFeed = PodcastFeed()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        switch elementName {
        case "title", "link", "description", "itunes:author":
            currentElementText = ""
        case "itunes:image":
            if let urlAttrib = attributeDict["href"] {
                currentFeed?.iTunesImageURL = URL(string: urlAttrib)
            }
        case "item":
            episodeParser = PodcastEpisodeParser(feedParser: self, xmlParser: parser)
            parser.delegate = episodeParser
        default:
            currentElementText = nil
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentElementText?.append(string)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "title":
            currentFeed?.title = currentElementText
        case "link":
            if let linkText = currentElementText {
                currentFeed?.link = URL(string: linkText)
            }
        case "description":
            currentFeed?.description = currentElementText
        case "itunes:author":
            currentFeed?.iTunesAuthor = currentElementText
        case "item":
            if var episode = episodeParser?.currentEpisode {
                if episode.iTunesImageURL == nil {
                    episode.iTunesImageURL = currentFeed?.iTunesImageURL
                }
                currentFeed?.episodes.append(episode)
            }
            episodeParser = nil
        default:
            break
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("Parsing done. feed: \(currentFeed)")
    }
}