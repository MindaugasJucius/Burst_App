struct RecentSearch {
    let query: String
    let date: Date
    
    private enum Keys: String, PlistKey {
        case query
        case date
    }
    
    init(query: String, date: Date) {
        self.query = query
        self.date = date
    }
    
    init(plist: PListDictionary) {
        query = plist.value(forKey: Keys.query)
        date = plist.value(forKey: Keys.date)
    }
    
    func dictionary() -> PListDictionary {
        return ["query": query as AnyObject,
                "date": date as AnyObject]
    }
}
